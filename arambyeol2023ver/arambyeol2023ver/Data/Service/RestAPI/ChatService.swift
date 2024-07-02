//
//  ChatService.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/8/24.
//

import Foundation

import Alamofire
import Factory

final class ChatService {
    @Injected(\.chatConverter) private var chatConverter
    
    func fetchPreviousChat(
        start: Date,
        size: Int = 10,
        page: Int = 1
    ) async throws -> [ChatModel] {
        let url = URLConfig.restChat.baseURL + "/chatList"
        
        // Date를 문자열로 변환하는 DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let startDateString = dateFormatter.string(from: start)
        
        let parameters: [String: Any] = [
            "start": startDateString,
            "size": size,
            "page": page
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: .get,
                parameters: parameters,
                interceptor: AFTokenIntercepter()
            )
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(
                of: ResponseBase<[ChatMessageDTO.Response.Data]>.self
            ) { [weak self ] response in
                guard let self = self else { return }
                switch response.result {
                case .success(let data):
                    let convertedData = data.data
                        .map { self.chatConverter.convertToChatModel(from: $0) }
                    continuation.resume(returning: convertedData)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // TODO: Make usecase and converter
    func reportChat(
        reporterDid: String,
        chatId: String,
        content: ChatReportDTO.ContentType
    ) async throws -> ChatReportDTO.Response {
        let url = URLConfig.restChat.baseURL + "/reportChat"
        
        let requestDTO = ChatReportDTO.Request(
            reporterDid: reporterDid,
            chatId: chatId,
            content: content
        )
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: .post,
                parameters: requestDTO,
                encoder: JSONParameterEncoder.default,
                interceptor: AFTokenIntercepter()
            )
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: ChatReportDTO.Response.self) { response in
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
