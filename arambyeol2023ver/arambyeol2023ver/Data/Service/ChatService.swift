//
//  ChatService.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/8/24.
//

import Foundation

import Alamofire

final class ChatService {
    static func fetchPreviousChat(
        start: Date,
        size: Int = 10,
        page: Int = 1
    ) async throws -> [ChatResponseModel.Data] {
        let url = URLConfig.rest.baseURL + "/chatList"
        
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
            AF.request(url, method: .get, parameters: parameters)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseDecodable(of: Response<[ChatResponseModel.Data]>.self) { response in
                    switch response.result {
                    case .success(let data):
                        continuation.resume(returning: data.data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
