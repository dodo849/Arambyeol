//
//  MenuModel.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 7/3/24.
//

import Foundation

struct MenuModel: Identifiable {
    let today: MealModel
    let tomorrow: MealModel
    let theDayAfterTomorrow: MealModel
    
    var id: String = UUID().uuidString
}

extension MenuModel {
    static var empty: MenuModel {
        return MenuModel(
            today: .empty,
            tomorrow: .empty,
            theDayAfterTomorrow: .empty
        )
    }
}

enum MenuDay: String, CaseIterable, Equatable, Identifiable {
    case today, tomorrow, afterTomorrow
    
    var id: String {
        return self.rawValue
    }
    
    var text: String {
        switch self {
            
        case .today: return "오늘"
        case .tomorrow: return "내일"
        case .afterTomorrow: return "모레"
        }
    }
}
