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
    
    func signup() async -> Result<Void, Error> {
        let url = URLConfig.restChat.baseURL + "/signUp"
        let did = DeviceIDRepository.shared.getID()
        
        return await withCheckedContinuation { continuation in
            AF.request(
                url,
                method: .post,
                parameters: ["deviceId": did],
                encoding: JSONEncoding.default
            )
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: ResponseBase<TokenDTO.Response>.self) { [weak self] response in
                guard let self = self else {
                    continuation.resume(returning: .failure(NSError(domain: "Self is nil", code: -1, userInfo: nil)))
                    return
                }
                
                switch response.result {
                case .success(let data):
                    let accessToken = data.data.accessToken
                    let refreshToken = data.data.refreshToken
                    tokenRepository.setAccessToken(accessToken)
                    tokenRepository.setRefreshToken(refreshToken)
                    continuation.resume(returning: .success(()))
                    
                case .failure(let error):
                    self.logger.error("Failed to signup: \(error)")
                    continuation.resume(returning: .failure(error))
                }
            }
        }
    }
    
    func login() async -> Result<Void, Error> {
        let url = URLConfig.restChat.baseURL + "/login"
        let did = DeviceIDRepository.shared.getID()
        
        return await withCheckedContinuation { continuation in
            AF.request(url, method: .get, parameters: ["deviceId": did])
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseDecodable(of: ResponseBase<TokenDTO.Response>.self) { [weak self] response in
                    guard let self = self else {
                        continuation.resume(returning: .failure(NSError(domain: "Self is nil", code: -1, userInfo: nil)))
                        return
                    }
                    
                    switch response.result {
                    case .success(let data):
                        let accessToken = data.data.accessToken
                        let refreshToken = data.data.refreshToken
                        tokenRepository.setAccessToken(accessToken)
                        tokenRepository.setRefreshToken(refreshToken)
                        continuation.resume(returning: .success(()))
                        
                    case .failure(let error):
                        self.logger.error("Failed to login: \(error)")
                        continuation.resume(returning: .failure(error))
                    }
                }
        }
    }
    
    func fetchNewAccessToken() async throws -> TokenDTO.Response {
        let url = URLConfig.restChat.baseURL + "/generateAccessToken"
        let refreshToken = tokenRepository.getRefreshToken()
        
        return try await withCheckedThrowingContinuation { continuation in
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(refreshToken)"
            ]
            
            AF.request(url, method: .get, headers: headers)
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
                        
                        continuation.resume(returning: data.data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
