//
//  ChatRequestModel.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/5/24.
//

import Foundation

struct ChatRequestModel: Encodable {
    let senderDid: String
    let message: String
    let sendTime: Date

    enum CodingKeys: String, CodingKey {
        case senderDid
        case message
        case sendTime
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(senderDid, forKey: .senderDid)
        try container.encode(message, forKey: .message)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateString = formatter.string(from: sendTime)
        try container.encode(dateString, forKey: .sendTime)
    }
}
