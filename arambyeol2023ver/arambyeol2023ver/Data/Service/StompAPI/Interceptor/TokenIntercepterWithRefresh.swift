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
    
    func execute<E>(
        entry: E,
        completion: @escaping (E) -> Void
    ) where E: EntryType {
        let accessToken = tokenRepository.getAccessToken()
        
        entry.headers.addHeader(key: "Authorization", value: "Bearer \(accessToken)")
        completion(entry)
    }
    
    func retry<E>(
        entry: E,
        error: any Error,
        completion: @escaping (E, InterceptorRetryType) -> Void
    ) where E: EntryType {
        Task {
              do {
                  let refreshToken = tokenRepository.getRefreshToken()
                  let tokenResponse = try await tokenService.fetchNewAccessToken(refreshToken: refreshToken)

                  tokenRepository.setAccessToken(tokenResponse.accessToken)
                  tokenRepository.setRefreshToken(tokenResponse.refreshToken)
                  
                  var updatedEntry = entry
                  updatedEntry.headers.addHeader(key: "Authorization", value: "Bearer \(tokenResponse.accessToken)")
                  
                  completion(updatedEntry, .retry)
              } catch {
                  // Fail to get new access token
                  let tokenError = TokenError.failedFetchNewAccessToken(
                    accessToken: tokenRepository.getAccessToken(),
                    refreshToken: tokenRepository.getRefreshToken()
                  )
                  completion(entry, .doNotRetryWithError(tokenError))
              }
          }
    }
}
