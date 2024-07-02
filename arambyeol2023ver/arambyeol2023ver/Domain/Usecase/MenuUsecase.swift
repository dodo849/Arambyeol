//
//  MenuUsecase.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 7/3/24.
//

import OSLog

import Factory

final class MenuUsecase {
    @Injected(\.menuService) private var menuService: MenuService
    
    let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: "MenuUsecase"
    )
    
    func fetchMenu() async throws -> MenuModel {
        do {
            var menuModel = try await menuService.fetchMenu()
            
            menuModel = calculateMenuIndices(menuModel)
            
            return menuModel
        } catch {
            logger.error("Fetch menu error: \(error.localizedDescription)")
            throw MenuError.failedFetchMenu(error)
        }
    }
    
    private func calculateMenuIndices(_ menuModel: MenuModel) -> MenuModel {
        let todayMeals = calculateMealIndices(meal: menuModel.today)
        let tomorrowMeals = calculateMealIndices(meal: menuModel.tomorrow)
        let theDayAfterTomorrowMeals = calculateMealIndices(meal: menuModel.theDayAfterTomorrow)
        
        return MenuModel(
            today: todayMeals,
            tomorrow: tomorrowMeals,
            theDayAfterTomorrow: theDayAfterTomorrowMeals
        )
    }
    
    private func calculateMealIndices(meal: MealModel) -> MealModel {
        let morningCourses = meal.morning.enumerated().map { (index, course) in
            createCourseModel(
                courseString: course.courseString,
                courseIndex: index,
                menu: course.menu
            )
        }
        let lunchCourses = meal.lunch.enumerated().map { (index, course) in
            createCourseModel(
                courseString: course.courseString,
                courseIndex: index,
                menu: course.menu
            )
        }
        let dinnerCourses = meal.dinner.enumerated().map { (index, course) in
            createCourseModel(
                courseString: course.courseString,
                courseIndex: index,
                menu: course.menu
            )
        }
        
        return MealModel(morning: morningCourses, lunch: lunchCourses, dinner: dinnerCourses)
    }
    
    private func createCourseModel(
        courseString: String,
        courseIndex: Int,
        menu: [String]
    ) -> CourseModel {
        let components = courseString.split(separator: "/")
        let courseName = components.count > 0 ? String(components[0]) : ""
        let courseType = components.count > 1 ? String(components[1]) : ""
        
        return CourseModel(
            courseString: courseString,
            courseIndex: courseIndex,
            courseName: courseName,
            courseType: courseType,
            menu: menu
        )
    }
}
