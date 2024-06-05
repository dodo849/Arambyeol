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
    struct ChatModel {
        let chatID = UUID() // TODO: 현재 스키마에 없어서 임시 할당
        let did: String
        let message: String
        let nickname: String
        let date: Date
    }
    
    // MARK: Input Action
    @Subject var onAppear: Void = ()
    @Subject var sendMessage: String = ""
    
    // MARK: Output State
    @Published var messages: [ChatModel] = []
    
    private let client = StompClient(url: URL(string: "wss://aramchat.kro.kr:443/ws-stomp")!)
    private var cancellables: Set<AnyCancellable> = []
    
    
    init() {
        bind()
    }
    
    private func bind() {
        $onAppear
            .withUnretained(self)
            .sink { (owner, _) in
                owner.connectAndSubscribe()
            }
            .store(in: &cancellables)
        
        $sendMessage
            .withUnretained(self)
            .sink { (owner, message) in
                owner.sendChat(message)
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
                print(response)
                do {
                    if let decodedResponse = try response.decode(ChatResponseModel.self)?.body.data {
                        let chatModel = ChatViewModel.ChatModel(
                            did: decodedResponse.senderDid,
                            message: decodedResponse.message,
                            nickname: decodedResponse.senderNickname,
                            date: decodedResponse.sendTime
                        )
                        DispatchQueue.main.async { // TODO: DispatchQueue 외에 다른 방법 찾기
                            self?.messages.append(chatModel)
                        }
                    }
                } catch {
                    print(error) // TODO: handle decoding error
                }
            }
        }
    }
    
    private func sendChat(_ message: String) {
        let chatRequest = ChatRequestModel(
            senderDid: DiviceIDManager.shared.getID(),
            message: message,
            sendTime: Date.now
        )
        
        client.send(
            topic: "/pub/chat",
            body: .json(chatRequest)
        ) { _ in }
    }
    
    deinit {
        client.disconnect()
    }
}

extension ChatViewModel.ChatModel: Identifiable, Hashable {
    var id: UUID {
        return self.chatID
    }
}
