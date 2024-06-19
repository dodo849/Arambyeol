//
//  TokenService.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/19/24.
//

import Foundation
import OSLog

import Alamofire
import Factory

final class TokenService {
    @Injected(\.tokenRepository) private var tokenRepository
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: "TokenService"
    )
    
    func login() {
        let url = URLConfig.rest.baseURL + "/login"
        
        let did = DeviceIDRepository.shared.getID()
        
        AF.request(url, method: .get, parameters: ["deviceId": did])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: ResponseBase<TokenDTO.Response>.self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let data):
                    let accessToken = data.data.accessToken
                    let refreshToken = data.data.refreshToken
                    tokenRepository.setAccessToken(accessToken)
                    tokenRepository.setRefreshToken(refreshToken)
                    
                case .failure(let error):
                    self.logger.error("Failed to login: \(error)")
                    break
                }
            }
    }
    
    func fetchNewAccessToken(refreshToken: String) async throws -> TokenDTO.Response {
        let url = URLConfig.rest.baseURL + "/generateAccessToken"
        
        return try await withCheckedThrowingContinuation { continuation in
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(refreshToken)"
            ]
            
            AF.request(url, method: .get, headers: headers)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseDecodable(of: ResponseBase<TokenDTO.Response>.self) { response in
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
