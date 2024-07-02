//
//  MenuConverter.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 7/3/24.
//

import Foundation

struct MenuConverter {
    func convertToMenuModel(
        from response: MenuDTO.Response
    ) -> MenuModel {
        let today = convertMeal(from: response.today)
        let tomorrow = convertMeal(from: response.tomorrow)
        let theDayAfterTomorrow = convertMeal(from: response.theDayAfterTomorrow)
        
        return MenuModel(today: today, tomorrow: tomorrow, theDayAfterTomorrow: theDayAfterTomorrow)
    }
    
    private func convertMeal(
        from meal: MenuDTO.Response.Meal
    ) -> MenuModel.Meal {
        let morning = meal.morning.map { convertCourseMenu(from: $0) }
        let lunch = meal.lunch.map { convertCourseMenu(from: $0) }
        let dinner = meal.dinner.map { convertCourseMenu(from: $0) }
        
        return MenuModel.Meal(morning: morning, lunch: lunch, dinner: dinner)
    }
    
    private func convertCourseMenu(
        from courseMenu: MenuDTO.Response.CourseMenu
    ) -> MenuModel.CourseMenu {
        return MenuModel.CourseMenu(course: courseMenu.course, menu: courseMenu.menu)
    }
}
