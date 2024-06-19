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
    @Injected(\.tokenRepository) var tokenRepository: TokenRepository
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        let accessToken = tokenRepository.getAccessToken()
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            completion(.retry)
        } else {
            completion(.doNotRetry)
        }
    }
}
