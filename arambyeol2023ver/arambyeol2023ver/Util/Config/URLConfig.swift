//
//  URLConfig.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/8/24.
//

import Foundation

public enum URLConfig {
    case rest, socket
    
    var baseURL: String {
        switch self {
        case .rest:
            guard let url = Bundle.main.object(forInfoDictionaryKey: "REST_BASE_URL") as? String
            else { fatalError("REST_BASE_URL is not set in Info.plist") }
            return url
        case .socket:
            guard let url = Bundle.main.object(forInfoDictionaryKey: "SOCKET_BASE_URL") as? String
            else { fatalError("SOCKET_BASE_URL is not set in Info.plist") }
            return url
        }
    }
}
