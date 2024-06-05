//
//  ChatResponseModel.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/5/24.
//

import Foundation

struct ChatResponseModel: Decodable {
    struct Body: Decodable {
        struct Data: Decodable {
            let senderDid: String
            let senderNickname: String
            let message: String
            let sendTime: Date

            enum CodingKeys: String, CodingKey {
                case senderDid
                case senderNickname
                case message
                case sendTime
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                senderDid = try container.decode(String.self, forKey: .senderDid)
                senderNickname = try container.decode(String.self, forKey: .senderNickname)
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
        
        let success: Bool
        let errorCode: Int
        let message: String
        let data: Data
    }
    
    let headers: [String: String]
    let body: Body
    let statusCodeValue: Int
    let statusCode: String
}
