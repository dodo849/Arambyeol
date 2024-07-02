//
//  MenuModel.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 7/3/24.
//

import Foundation

struct MenuModel: Codable {
    struct CourseMenu: Codable {
        let course: String
        let menu: [String]
    }

    struct Meal: Codable {
        let morning: [CourseMenu]
        let lunch: [CourseMenu]
        let dinner: [CourseMenu]
    }
    
    let today: Meal
    let tomorrow: Meal
    let theDayAfterTomorrow: Meal
}
