//
//  Struct.swift
//  arambyeol2023ver
//
//  Created by 김가은 on 2023/03/07.
//

import Foundation



//struct getCourse : Codable {
//    var course : String
//    var menu : [String]
//}
//
//struct getDay : Codable {
//    var moring : [getCourse]
//    var lunch : [getCourse]
//    var dinner : [getCourse]
//}
//
//struct getMenu : Codable {
//    var today : getDay
//    var tomorrow : getDay
//    var theDayAfterTomorrw : getDay
//}
import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let today, tomorrow, theDayAfterTomorrow: TheDayAfterTomorrow
}
struct getSatMenu: Codable {
    let today, tomorrow : TheDayAfterTomorrow
}
struct getSunMenu: Codable {
    let today :TheDayAfterTomorrow
}
// MARK: - TheDayAfterTomorrow
struct TheDayAfterTomorrow: Codable {
    let morning, lunch, dinner: [Dinner]
}

// MARK: - Dinner
struct Dinner: Codable {
    let course: String
    let menu: [String]
}
