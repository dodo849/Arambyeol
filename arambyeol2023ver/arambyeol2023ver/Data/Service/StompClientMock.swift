//
//  StompClientMock.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/9/24.
//

import Foundation
import StompClient

class StompClientMock: StompProtocol {
    
    private var receiveCompletions:
    [String: [(Result<StompReceiveMessage, any Error>) -> Void]] = [:]
    
    func connect(
        acceptVersion: String,
        _ completion: @escaping ((any Error)?) -> Void
    ) {
        print("(Stomp Mock)Connect success")
        completion(nil)
    }
    
    func send(
        topic: String,
        body: StompBody,
        completion: @escaping ((any Error)?
        ) -> Void) {
        print("(Stomp Mock)Send message:\n \(body)")
        
        let executeReceiveCompletions = self.receiveCompletions
            .filter { key, value in
                key == topic
            }
//        executeReceiveCompletions.forEach { _, receiveCompletions in
//            let response = StompReceiveMessage(
//                command: <#T##StompResponseCommand#>,
//                headers: <#T##[String : String]#>,
//                body: <#T##Data?#>)
//            switch response {
//            case .failure(let error):
//                receiveCompletions.forEach {
//                    $0.completion(.failure(error))
//                }
//            case .success(let responseMessage):
//                receiveCompletions.forEach {
//                    $0.completion(.success(responseMessage))
//                }
//            }
//        }
    }
    
    
    func subscribe(
        topic: String,
        id: String?,
        _ receiveCompletion: @escaping (Result<StompReceiveMessage, any Error>) -> Void
    ) {
        print("(Stomp Mock)Subscribe topic:\n \(topic), id:\(String(describing: id))")
        if let _ = receiveCompletions[topic] {
            receiveCompletions[topic]?.append(receiveCompletion)
        } else {
            receiveCompletions[topic] = [receiveCompletion]
        }
    }
    
    func unsubscribe(topic: String, completion: @escaping ((any Error)?) -> Void) {
        print("(Stomp Mock)Unsubscribe success")
        completion(nil)
    }
    
    func disconnect() {
        print("(Stomp Mock)Disconnect success")
    }
}
