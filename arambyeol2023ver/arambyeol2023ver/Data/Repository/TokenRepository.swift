//
//  TokenRepository.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/19/24.
//

import Foundation
import OSLog

class TokenRepository {
    static let shared = TokenRepository()
    
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    
    private var logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: "TokenRepository"
    )
    
    private init() { }
    
    func getAccessToken() -> String {
        if let accessToken = UserDefaults.standard.string(forKey: accessTokenKey) {
            return accessToken
        } else {
            logger.error("Failed to get access token from UserDefaults")
            return ""
        }
    }
    
    func getRefreshToken() -> String {
        if let refreshTokenKey = UserDefaults.standard.string(forKey: refreshTokenKey) {
            return refreshTokenKey
        } else {
            logger.error("Failed to get access token from UserDefaults")
            return ""
        }
    }
    
    func setAccessToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: accessTokenKey)
    }

    func setRefreshToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: refreshTokenKey)
    }
}
