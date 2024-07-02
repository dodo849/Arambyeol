//
//  TokenError.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/19/24.
//

import Foundation

enum TokenError: LocalizedError {
    case failedFetchNewAccessToken(accessToken: String, refreshToken: String)
    
    var errorDescription: String? {
        switch self {
        case .failedFetchNewAccessToken(let accessToken, let refreshToken):
            return NSLocalizedString(
                    """
                    refresh token을 이용해 새로운 access token을 가져오는데 실패했습니다.
                    access token: \(accessToken)
                    refresh token: \(refreshToken)
                    """,
                    comment: "Error when fetching a new access token using the provided refresh token"
                )
        }
    }
}
