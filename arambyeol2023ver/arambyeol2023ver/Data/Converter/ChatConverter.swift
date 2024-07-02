//
//  ChatConverter.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/24/24.
//

import Foundation

struct ChatConverter {
    func convertToChatModel(
        from message: String
    ) -> ChatModel {
        let myDid = DeviceIDRepository.shared.getID()
        return ChatModel(
            id: UUID().uuidString,
            did: myDid,
            message: message,
            nickname: "", // TODO: 닉네임 조회로 가져오기
            author: .me,
            date: Date.now
        )
    }
    
    func convertToChatModel(
        from decodedResponse: ChatMessageDTO.Response.Data
    ) -> ChatModel {
        let myDid = DeviceIDRepository.shared.getID()
        return ChatModel(
            id: decodedResponse.chatId,
            did: decodedResponse.senderDid,
            message: decodedResponse.message,
            nickname: decodedResponse.senderNickname,
            author: decodedResponse.senderDid == myDid ? .me : .others,
            date: decodedResponse.sendTime
        )
    }
}
