//
//  CourseModel.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 7/3/24.
//

import Foundation

struct CourseModel: Identifiable {
    let courseString: String
    let courseIndex: Int
    let courseName: String
    let courseType: String
    let menu: [String]
    
    var id: String = UUID().uuidString
    
    init(
        course: String,
        menu: [String]
    ) {
        self.courseString = course
        self.menu = menu
        
        self.courseIndex = 0
        self.courseName = ""
        self.courseType = ""
    }
    
    init(
        courseString: String,
        courseIndex: Int,
        courseName: String,
        courseType: String,
        menu: [String]
    ) {
        self.courseString = courseString
        self.courseIndex = courseIndex
        self.courseName = courseName
        self.courseType = courseType
        self.menu = menu
    }
}

extension CourseModel {
    static var empty: CourseModel {
        return CourseModel(
            courseString: "",
            courseIndex: 0,
            courseName: "",
            courseType: "",
            menu: []
        )
    }
}
