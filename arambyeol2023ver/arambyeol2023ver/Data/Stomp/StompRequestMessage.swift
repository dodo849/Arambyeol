//
//  StompMessage.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/4/24.
//

import Foundation

enum StompCommand: String {
    case connect = "CONNECT"
    case connected = "CONNECTED"
    case subscribe = "SUBSCRIBE"
    case send = "SEND"
    case disconnect = "DISCONNECT"
    case message = "MESSAGE"
    case unsubscribe = "UNSUBSCRIBE"
    case receipt = "RECEIPT"
    case error = "ERROR"
}

public enum StompBody {
    case data(Data)
    case string(String)
    case json(Codable)
}

protocol StompRequestMessage {
    var command: StompCommand { get }
    var headers: [String: String] { get }
    var body: StompBody? { get }
    
    func toFrame() -> String
}

extension StompRequestMessage {
    func toFrame() -> String {
        var frame = "\(command.rawValue)\n"
        for (key, value) in headers {
            frame += "\(key):\(value)\n"
        }
        frame += "\n"
        
        if let body = body {
            switch body {
            case .data(let data):
                frame += String(data: data, encoding: .utf8) ?? ""
            case .string(let string):
                frame += string
            case .json(let json):
                let encoder = JSONEncoder()
                if let jsonData = try? encoder.encode(json) {
                    frame += String(data: jsonData, encoding: .utf8) ?? ""
                }
            }
        }
        
        frame += "\u{00}"
        return frame
    }
}

struct StompAnyMessage: StompRequestMessage {
    let command: StompCommand
    let headers: [String: String]
    var body: StompBody? = nil
    
    init(
        command: StompCommand,
        headers: [String: String],
        body: StompBody?
    ) {
        self.command = command
        self.headers = headers
        self.body = body
    }
}

struct StompConnectMessage: StompRequestMessage {
    let command: StompCommand = .connect
    let headers: [String: String]
    var body: StompBody? = nil
    
    init(
        accecptVersion: String = "1.2",
        host: String
    ) {
        self.headers = [
            "accept-version": accecptVersion,
            "host": host
        ]
    }
    
    init(headers: [String: String]) {
        self.headers = headers
    }
}

struct StompSubscribeMessage: StompRequestMessage {
    let command: StompCommand = .subscribe
    let headers: [String: String]
    let body: StompBody? = nil
    
    init(
        id: String?,
        destination: String
    ) {
        self.headers = [
            "id" : id ?? UUID().uuidString,
            "destination": destination
        ]
    }
    
    init(headers: [String: String]) {
        self.headers = headers
    }
}

struct StompSendMessage: StompRequestMessage {
    let command: StompCommand = .send
    let headers: [String: String]
    let body: StompBody?
    
    init(
        destination: String,
        body: StompBody
    ) {
        self.headers = [
            "destination": destination
        ]
        self.body = body
    }
    
    init(headers: [String: String]) {
        self.headers = headers
        self.body = nil
    }
}

/// 미완
struct StompDisconnectMessage: StompRequestMessage {
    let command: StompCommand = .disconnect
    let headers: [String: String]
    let body: StompBody? = nil
    
    init(
        destination: String
    ) {
        self.headers = [
            "destination": destination
        ]
    }
    
    init(headers: [String: String]) {
        self.headers = headers
    }
}
