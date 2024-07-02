//
//  URLConfig.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/8/24.
//

import Foundation

public enum URLConfig {
    case restMenu, restChat, socket
    
    var baseURL: String {
        switch self {
        case .restMenu:
            guard let url = Bundle.main.object(forInfoDictionaryKey: "REST_MENU_BASE_URL") as? String
            else { fatalError("REST_MENU_BASE_UR is not set in Info.plist") }
            return url
        case .restChat:
            guard let url = Bundle.main.object(forInfoDictionaryKey: "REST_CHAT_BASE_URL") as? String
            else { fatalError("REST_CHAT_BASE_URL is not set in Info.plist") }
            return url
        case .socket:
            guard let url = Bundle.main.object(forInfoDictionaryKey: "SOCKET_BASE_URL") as? String
            else { fatalError("SOCKET_BASE_URL is not set in Info.plist") }
            return url
        }
    }
}
