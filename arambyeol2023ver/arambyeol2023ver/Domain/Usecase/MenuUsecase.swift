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
    
    func getHoursOfOperation() -> HoursOfOperation {
        if isWeekend() {
            return .init(
                morning: "8:00~9:00",
                lunch: "12:00~13:30",
                dinner: "17:30~18:40"
            )
        } else {
            return .init(
                morning: "7:30~9:00 테이크아웃 8:30~9:30",
                lunch: "11:30~13:30",
                dinner: "17:30~19:00"
            )
        }
    }
    
    func getCurrentMealTime() -> MealTime {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: Date())
        
        guard let hour = components.hour, let minute = components.minute else {
            return .morning
        }
        
        let timeInMinutes = hour * 60 + minute
        
        if isWeekend() {
            switch timeInMinutes {
            case 0..<540: // 00:00 - 08:59
                return .morning
            case 540..<810: // 09:00 - 13:29
                return .launch
            default:
                return .dinner
            }
        } else {
            switch timeInMinutes {
            case 0..<570: // 00:00 - 09:29
                return .morning
            case 570..<810: // 09:30 - 13:29
                return .launch
            default:
                return .dinner
            }
        }
    }
}
    
extension MenuUsecase {
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
    
    private func isWeekend() -> Bool {
        let calendar = Calendar.current
        let today = Date()
        let components = calendar.dateComponents([.weekday], from: today)
        
        guard let weekday = components.weekday else {
            return false
        }

        return weekday == 1 || weekday == 7
    }
}
