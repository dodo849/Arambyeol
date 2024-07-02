//
//  MealModel.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 7/3/24.
//

import Foundation

struct MealModel:Identifiable {
    let morning: [CourseModel]
    let lunch: [CourseModel]
    let dinner: [CourseModel]
    
    var id: String = UUID().uuidString
}

extension MealModel {
    static var empty: MealModel {
        return MealModel(
            morning: [],
            lunch: [],
            dinner: []
        )
    }
}

enum MealTime {
    case morning, launch, dinner
    
    var text: String {
        switch self {
        case .morning: return "아침"
        case .launch: return "점심"
        case .dinner: return "저녁"
        }
    }
}
