//
//  ChatViewModel.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/5/24.
//

import Foundation
import Combine

import StompClient

final class ChatViewModel: ObservableObject {
    // MARK: Display Model
    struct ChatModel {
        enum ChatAuthor {
            case me
            case others
        }
        let id: String
        let did: String
        let message: String
        let nickname: String
        let author: ChatAuthor
        let date: Date
    }
    
    // MARK: Input Action
    enum Action {
        case onAppear, onDisappear
        case sendMessage(String)
        case refresh
        case none
    }
    @Subject var action: Action = .none
    
    // MARK: Output State
    @Published var messages: [ChatModel]
    
    // MARK: Private data
    private var previousStartDate: Date? = nil
    private let myDid = DiviceIDManager.shared.getID()
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Dependendcy
    private let client = StompClient(url: URL(string: URLConfig.socket.baseURL)!)
    
    
    init(messages: [ChatModel] = []) {
        self.messages = messages
        bind()
        Task { [weak self] in
            await self?.fetchPreviousChat()
        }
    }
    
    private func bind() {
        $action
            .withUnretained(self)
            .sink { (owner, action) in
                switch action {
                case .onAppear:
                    owner.connectAndSubscribe()
                case .onDisappear:
                    owner.client.disconnect()
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
        client.connect { [weak self] error in
            if let error = error {
                print("Failed to connect: \(error)")
            } else {
                self?.subscribeChat()
            }
        }
    }
    
    private func subscribeChat() {
        let did = DiviceIDManager.shared.getID()
        
        client.subscribe(
            topic: "/sub/ArambyeolChat",
            id: did
        ) { [weak self] (result: Result<StompReceiveMessage, Error>) in
            switch result {
            case .failure(let error):
                print(error) // TODO: handle error
            case .success(let response):
                self?.handleChatResponse(response)
            }
        }
    }

    private func handleChatResponse(_ response: StompReceiveMessage) {
        do {
            if let decodedResponse = try response.decode(ChatResponseModel.self)?.body.data {
                let chatModel = convertToChatModel(
                    from: decodedResponse
                )
                Task.detached { [unowned self] in
                    await MainActor.run {
                        if chatModel.did != myDid {
                            self.messages.append(chatModel)
                        }
                    }
                }
            }
        } catch {
            print(error) // TODO: handle decoding error
        }
    }
    
    private func sendChat(_ message: String) {
        let chatRequest = ChatRequestModel(
            senderDid: DiviceIDManager.shared.getID(),
            message: message,
            sendTime: Date.now
        )
        
        messages.insert(convertToChatModel(from: message), at: 0)
        
        client.send(
            topic: "/pub/chat",
            body: .json(chatRequest)
        ) { _ in }
    }
    
    func fetchPreviousChat() async {
        let startDate: Date = {
            if let date = messages.last?.date {
                return date.addingTimeInterval(-1)
            } else {
                return Date().addingTimeInterval(-1)
            }
        }()
        
        do {
            let fetchedChats = try await ChatService.fetchPreviousChat(
                start: startDate,
                size: 25,
                page: 1
            )
            let convertedChats = fetchedChats.map {
                convertToChatModel(from: $0)
            }
            
            DispatchQueue.main.async {
                self.messages += convertedChats
//                self.messages.insert(contentsOf: convertedChats, at: 0)
            }
        } catch {
            print("Fetch chat error: \(error)")
        }
    }
    
    deinit {
        client.disconnect()
    }
}

extension ChatViewModel.ChatModel: Identifiable, Hashable { }

extension ChatViewModel {
    private func convertToChatModel(
        from message: String
    ) -> ChatViewModel.ChatModel {
        return ChatViewModel.ChatModel(
            id: UUID().uuidString,
            did: myDid,
            message: message,
            nickname: "", // TODO: 닉네임 조회로 가져오기
            author: .me,
            date: Date.now
        )
    }
    
    private func convertToChatModel(
        from decodedResponse: ChatResponseModel.Data
    ) -> ChatViewModel.ChatModel {
        return ChatViewModel.ChatModel(
            id: decodedResponse.chatId,
            did: decodedResponse.senderDid,
            message: decodedResponse.message,
            nickname: decodedResponse.senderNickname,
            author: decodedResponse.senderDid == myDid ? .me : .others,
            date: decodedResponse.sendTime
        )
    }
}
