//
//  AFTokenIntercepter.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/19/24.
//

import Foundation

import Factory
import Alamofire

class AFTokenIntercepter: RequestInterceptor {
    @Injected(\.tokenService) var tokenService: TokenService
    @Injected(\.tokenRepository) var tokenRepository: TokenRepository
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        let accessToken = tokenRepository.getAccessToken()
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            Task { [weak self] in
                guard let self = self else { return }
                
                let _ = try await tokenService.fetchNewAccessToken()
                let newAccessToken = self.tokenRepository.getAccessToken()
                
                completion(.retry)
            }
        } else {
            completion(.doNotRetry)
        }
    }
}
