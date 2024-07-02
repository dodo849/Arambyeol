//
//  ChatViewModel.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/5/24.
//

import Foundation
import Combine
import OSLog

import Factory
import Stomper

/// A ViewModel for Chat View. The `ChatViewModel` manages messages sent by users send and the UI state.
///
/// 용어
/// - Chat: 채팅 전체
/// - Cell: 채팅 스크롤에 나타나는 모든 종류의 뷰 (버블, 날짜 등)
/// - Message: 사용자가 보낸 메세지에 대한 데이터에 관한 용어
/// - Bubble: 사용자가 보낸 메세지에 대한 UI 관련 용어
final class ChatViewModel: ObservableObject {
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: "ChatViewModel"
    )
    
    // MARK: Input Action
    enum Action {
        case onAppear, onDisappear
        case sendMessage(String)
        case refresh
        case none
    }
    @Subject var action: Action = .none
    
    // MARK: Output State
    @Published var chatCells: [ChatType]
    
    // MARK: Private data
    private var previousStartDate: Date? = nil
    private let myDid = DeviceIDRepository.shared.getID()
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Dependendcy
    private let provider = StompProvider<ChatMessageEntry>()
        .intercepted(StompTokenInterceptor())
        .enableLogging()
    @Injected(\.chatService) private var chatService
    @Injected(\.chatUsecase) private var chatUsecase
    
    
    init(messages: [ChatModel] = []) {
        self.chatCells = messages.map { .message($0) }
        bind()
    }
    
    private func bind() {
        $action
            .withUnretained(self)
            .sink { (owner, action) in
                switch action {
                case .onAppear:
                    Task { [weak self] in
                        await self?.fetchPreviousChat()
                        owner.connectAndSubscribe()
                    }
                case .onDisappear:
                    owner.provider.request(
                        of: String.self,
                        entry: .disconnect
                    ) { _ in}
                case .sendMessage(let message):
                    owner.sendChat(message)
                case .refresh:
                    Task {
                        await owner.fetchPreviousChat()
                    }
                case .none:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func connectAndSubscribe() {
        provider.request(
            of: String.self,
            entry: .connect
        ) { [weak self] result in
            switch result {
            case .failure(let error):
                if let localizedError = error as? LocalizedError {
                    self?.logger.error("\(#function)\n\(localizedError.errorDescription ?? "Unknown error")")
                } else {
                    self?.logger.error("\(#function)\n\(error)")
                }
            case .success(_):
                self?.subscribeChat()
            }
        }
    }
    
    private func subscribeChat() {
        let _ = DeviceIDRepository.shared.getID()
        
        provider.request(
            of: ChatMessageDTO.Response.self,
            entry: .subscribeChat
        ) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.logger.error("\(#function)\n\(error)")
            case .success(let dto):
                self?.handleChatResponse(dto)
            }
        }
    }
    
    private func handleChatResponse(_ response: ChatMessageDTO.Response) {
        let chatModel = convertToChatModel(
            from: response.body.data
        )
        Task.detached { [unowned self] in
            await MainActor.run {
                if chatModel.did != myDid {
                    self.chatCells.insert(.message(chatModel), at: 0)
                }
            }
        }
    }
    
    private func sendChat(_ message: String) {
        let chatRequest = ChatMessageDTO.Request(
            senderDid: DeviceIDRepository.shared.getID(),
            message: message,
            sendTime: Date.now
        )
        
        let chatModel: ChatModel = convertToChatModel(from: message)
        chatCells.insert(.message(chatModel), at: 0)
        
        provider.request(
            of: StompReceiveMessage.self,
            entry: .sendMessage(message: chatRequest)
        ) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.logger.error("\(#function)\n\(error)")
            case .success(let dto):
                print(dto)
            }
        }
    }
    
    func fetchPreviousChat() async {
        let startDate: Date = {
            if let lastMessageDate = extractLastMessageDate(from: chatCells) {
                return lastMessageDate.addingTimeInterval(-1)
            } else {
                return Date().addingTimeInterval(-1)
            }
        }()
        
        let chats = await chatUsecase.fetchPreviousChat(startDate: startDate)
        
        DispatchQueue.main.async { [weak self] in
            self?.chatCells += chats
        }
    }
    
    private func extractLastMessageDate(
        from chatCells: [ChatType]
    ) -> Date? {
        return chatCells.compactMap { chatType -> ChatModel? in
            if case let .message(chatModel) = chatType {
                return chatModel
            } else {
                return nil
            }
        }.last?.date
    }
    
    func report(
        _ chat: ChatModel,
        content: ChatReportDTO.ContentType
    ) async {
        do {
            let _ = try await chatService.reportChat(
                reporterDid: myDid,
                chatId: chat.id,
                content: content
            )
        }
        catch {
            logger.error("\(#function)\n\(error)")
        }
    }
    
    deinit {

    }
}

extension ChatViewModel {
    private func convertToChatModel(
        from message: String
    ) -> ChatModel {
        return ChatModel(
            id: UUID().uuidString,
            did: myDid,
            message: message,
            nickname: "", // TODO: 닉네임 조회로 가져오기
            author: .me,
            date: Date.now
        )
    }
    
    private func convertToChatModel(
        from decodedResponse: ChatMessageDTO.Response.Data
    ) -> ChatModel {
        return ChatModel(
            id: decodedResponse.chatId,
            did: decodedResponse.senderDid,
            message: decodedResponse.message,
            nickname: decodedResponse.senderNickname,
            author: decodedResponse.senderDid == myDid ? .me : .others,
            date: decodedResponse.sendTime
        )
    }
}
