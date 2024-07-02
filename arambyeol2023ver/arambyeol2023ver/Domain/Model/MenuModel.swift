//
//  MenuModel.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 7/3/24.
//

import Foundation

struct MenuModel: Codable, Identifiable {
    let today: MealModel
    let tomorrow: MealModel
    let theDayAfterTomorrow: MealModel
    
    var id: String = UUID().uuidString
}

struct CourseModel: Codable, Identifiable {
    let course: String
    let menu: [String]
    
    var id: String = UUID().uuidString
}

struct MealModel: Codable, Identifiable {
    let morning: [CourseModel]
    let lunch: [CourseModel]
    let dinner: [CourseModel]
    
    var id: String = UUID().uuidString
}
