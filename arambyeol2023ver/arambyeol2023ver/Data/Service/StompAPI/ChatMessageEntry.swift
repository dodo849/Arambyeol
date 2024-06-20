//
//  StompEntry.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/15/24.
//

import Foundation

import Factory
import Stomper

enum ChatMessageEntry {
    case connect
    case subscribeChat
    case sendMessage(message: ChatMessageDTO.Request)
    case disconnect
}

extension ChatMessageEntry: EntryType {
    static var baseURL: URL {
        URL(string: URLConfig.socket.baseURL)!
    }
    
    var topic: String? {
        switch self {
        case .subscribeChat:
            return "/sub/ArambyeolChat"
        case .sendMessage:
            return "/pub/chat"
        default:
            return nil
        }
    }
    
    var command: EntryCommand {
        switch self {
        case .connect: 
            return .connect(host: URLConfig.socket.baseURL)
        case .subscribeChat:
            return .subscribe()
        case .sendMessage(_):
            return .send()
        case .disconnect:
            return .disconnect()
        }
    }
    
    var body: EntryRequestBodyType {
        switch self {
        case .sendMessage(let message):
            return .withJSON(message)
        default:
            return .none
        }
    }
    
    var additionalHeaders: [String : String] {
        return [:]
    }
}
