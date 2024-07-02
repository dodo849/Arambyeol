//
//  MenuError.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 7/3/24.
//

import Foundation

enum MenuError: LocalizedError {
    case failedFetchMenu(Error)
    
    var errorDescription: String? {
        switch self {
        case .failedFetchMenu(let error):
            return NSLocalizedString(
                    """
                    메뉴를 가져오는데 실패했습니다.\n Network error: \(error)
                    """,
                    comment: "Error when fetching a menu"
                )
        }
    }
}
