//
//  ChatResponseModel.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/5/24.
//

import Foundation

struct ChatResponseModel: Decodable {
        struct Data: Decodable {
            let senderDid: String
            let senderNickname: String
            let chatId: String
            let message: String
            let sendTime: Date

            enum CodingKeys: String, CodingKey {
                case senderDid
                case senderNickname
                case chatId
                case message
                case sendTime
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                senderDid = try container.decode(String.self, forKey: .senderDid)
                senderNickname = try container.decode(String.self, forKey: .senderNickname)
                chatId = try container.decode(String.self, forKey: .chatId)
                message = try container.decode(String.self, forKey: .message)
                
                let sendTimeString = try container.decode(String.self, forKey: .sendTime)
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                if let date = formatter.date(from: sendTimeString) {
                    sendTime = date
                } else {
                    throw DecodingError.dataCorruptedError(forKey: .sendTime, in: container, debugDescription: "Date string does not match format expected by formatter.")
                }
            }
        }
    
    let headers: [String: String]
    let body: Response<Data>
    let statusCodeValue: Int
    let statusCode: String
}
