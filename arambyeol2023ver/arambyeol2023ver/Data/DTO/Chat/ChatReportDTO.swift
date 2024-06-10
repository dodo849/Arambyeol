//
//  ChatReportDTO.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/11/24.
//


import Foundation

struct ChatReportDTO {
    struct Request: Encodable {
        let reporterDid: String
        let chatId: String
        let content: ContentType
    }
    
    struct Response: Decodable {
        let success: Bool
        let errorCode: Int
        let message: String
    }
    
    enum ContentType: String, Encodable {
        case sexual = "SEXUAL"
        case violent = "VIOLENT"
        case hateful = "HATEFUL"
        case harmful = "HARMFUL"
        case spam = "SPAM"
        
        var description: String {
            switch self {
            case .sexual:
                return "성적인 내용"
            case .violent:
                return "폭력적 또는 혐오스러운 내용"
            case .hateful:
                return "증오 또는 학대하는 내용"
            case .harmful:
                return "유해하거나 위험한 내용"
            case .spam:
                return "스팸 또는 혼동을 야기하는 내용"
            }
        }
    }

}
