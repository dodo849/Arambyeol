//
//  Response.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/8/24.
//

import Foundation

struct Response<T: Decodable>: Decodable {
    let success: Bool
    let errorCode: Int
    let message: String
    let data: T
}
