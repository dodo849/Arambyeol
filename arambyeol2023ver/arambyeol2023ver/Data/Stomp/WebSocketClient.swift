//
//  WebSocketClient.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/4/24.
//

import Foundation

public final class StompClient: NSObject, URLSessionDelegate {
    private var websocketClient: WebSocketClient
    private var url: URL
    /// key: topic
    /// value: receive completion
    private var receiveCompletions: [String: (Result<StompBody?, Error>) -> Void] = [:]
    
    init(url: URL) {
        self.url = url
        self.websocketClient = WebSocketClient(url: url)
        super.init()
    }
    
    public func connect(
        accecptVersion: String = "1.2",
        completion: @escaping ((any Error)?) -> Void
    ) {
        websocketClient.connect()
        websocketClient.receiveMessage() { [weak self] result in
            switch result {
            case .failure(let error):
                completion(error)
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.executeReceiveCompletions(text, completion)
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    fatalError()
                }
            }
        }
        
        guard let host = url.host()
        else { completion(StompError.invalidURLHost); return }
        
        let connectMessage = StompConnectMessage(host: host)
        websocketClient.sendMessage(connectMessage.toFrame(), completion)
        
    }
    
    private func executeReceiveCompletions(
        _ text: String,
        _ completion: @escaping ((any Error)?) -> Void
    ) {
        let stompMessageResult = self.toMessage(text)
        
        switch stompMessageResult {
        case .failure(let error):
            completion(error)
        case .success(let stompMessage):
            let executeReceiveCompletions = self.receiveCompletions.filter { key, value in
                key == stompMessage.headers["destination"]
            }
            executeReceiveCompletions.forEach { _, receiveCompletion in
                receiveCompletion(.success(stompMessage.body))
            }
        }
    }
    
    public func send(
        topic: String,
        body: StompBody,
        completion: @escaping ((any Error)?) -> Void
    ) {
        let sendMessage = StompSendMessage(destination: topic, body: body)
        websocketClient.sendMessage(sendMessage.toFrame(), completion)
    }
    
    public func subscribe(
        topic: String,
        id: String? = nil,
        _ receiveCompletion: @escaping (Result<StompBody?, Error>) -> Void
    ) {
        let subscribeMessage = StompSubscribeMessage(
            id: id,
            destination: topic
        )
        websocketClient.sendMessage(subscribeMessage.toFrame(), { _ in })
        receiveCompletions[topic] = receiveCompletion
    }
    
    public func unsubscribe() {
        
    }
    
    public func disconnect() {
        websocketClient.disconnect()
    }
    
    private func toMessage(_ frame: String) -> Result<StompMessage, StompError> {
        let lines = frame.split(separator: "\n", omittingEmptySubsequences: false)
        
        guard let commandString = lines.first,
              let command = StompCommand(rawValue: String(commandString))
        else {
            return .failure(.invalidCommand)
        }
        
        var headers: [String: String] = [:]
        var body: String?
        var isBody = false
        
        for line in lines.dropFirst() {
            if line.isEmpty {
                isBody = true
                continue
            }
            
            if isBody {
                body = (body ?? "") + line
            } else {
                let parts = line.split(separator: ":", maxSplits: 1)
                if parts.count == 2 {
                    headers[String(parts[0])] = String(parts[1])
                }
            }
        }
        
        let stompBody: StompBody?

        if let body = body {
            if headers["content-type"]?.contains("application/json") == true {
                let data = body.data(using: .utf8) ?? Data()
                stompBody = StompBody.json(try? JSONDecoder().decode(AnyCodable.self, from: data))
            } else if headers["content-type"]?.contains("text/plain") == true {
                stompBody = StompBody.string(body)
            } else {
                stompBody = StompBody.data(body.data(using: .utf8) ?? Data())
            }
        } else {
            stompBody = nil
        }
        
        let stompMessage = StompAnyMessage(
            command: command,
            headers: headers,
            body: stompBody
        )
        
        return .success(stompMessage)
    }
}

class WebSocketClient: NSObject, URLSessionWebSocketDelegate {
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession?
    
    init(url: URL) {
        super.init()
        let configuration = URLSessionConfiguration.default
        urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue())
        webSocketTask = urlSession?.webSocketTask(with: url)
    }
    
    func connect(
    ) {
        webSocketTask?.resume()
    }
    
    func sendMessage(_ message: String, _ completion: @escaping ((any Error)?) -> Void) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func receiveMessage(
        _ completion: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void
    ) {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let message):
                completion(.success(message))
                self?.receiveMessage(completion)
            }
        }
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    // URLSessionWebSocketDelegate methods
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("WebSocket connected successfully")
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("WebSocket disconnected")
    }
}

// URLSessionDelegate to handle SSL handshake issues
extension WebSocketClient: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let trust = challenge.protectionSpace.serverTrust!
        let credential = URLCredential(trust: trust)
        completionHandler(.useCredential, credential)
    }
}

