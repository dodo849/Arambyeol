//
//  ChatModel.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/14/24.
//

import Foundation

enum ChatType: Equatable, Identifiable, Hashable {
    case message(ChatModel)
    case date(Date)
}

extension ChatType {
    var id: String {
        switch self {
        case .message(let chat):
            return chat.id
        case .date(let date):
            return date.description
        }
    }
}

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

extension ChatModel: Identifiable, Hashable { }
