//
//  SomperTokenIntercepter.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/19/24.
//

import Foundation

import Factory
import Stomper

struct StompTokenInterceptor: Interceptor {
    @Injected(\.tokenService) private var tokenService
    @Injected(\.tokenRepository) private var tokenRepository
    
    init() { }
    
    func execute(
        message: StompRequestMessage,
        completion: @escaping (StompRequestMessage) -> Void
    ) {
        let accessToken = tokenRepository.getAccessToken()
        
        message.headers.addHeader(key: "Authorization", value: "Bearer \(accessToken)")
        
        completion(message)
    }
    
    func retry(
        message: StompRequestMessage,
        error: any Error,
        completion: @escaping (StompRequestMessage, InterceptorRetryType) -> Void
    ) {
        Task {
              do {
                  let refreshToken = tokenRepository.getRefreshToken()
                  let tokenResponse = try await tokenService.fetchNewAccessToken(refreshToken: refreshToken)

                  tokenRepository.setAccessToken(tokenResponse.accessToken)
                  tokenRepository.setRefreshToken(tokenResponse.refreshToken)
                  
                  let updatedMessage = message
                  updatedMessage.headers.addHeader(key: "Authorization", value: "Bearer \(tokenResponse.accessToken)")
                  
                  completion(updatedMessage, .delayedRetry(1))
              } catch {
                  // Fail to get new access token
                  let tokenError = TokenError.failedFetchNewAccessToken(
                    accessToken: tokenRepository.getAccessToken(),
                    refreshToken: tokenRepository.getRefreshToken()
                  )
                  completion(message, .doNotRetryWithError(tokenError))
              }
          }
    }
}
