//
//  TokenDTO.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/19/24.
//

import Foundation

struct TokenDTO: Decodable {
    struct Response: Decodable {
        let accessToken: String
        let refreshToken: String
    }
}
