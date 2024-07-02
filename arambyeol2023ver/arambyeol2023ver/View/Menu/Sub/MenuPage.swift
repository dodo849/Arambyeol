//
//  MenuPage.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 7/3/24.
//

import SwiftUI

struct MenuPage: View {
    var mealModel: MealModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                MealTitle("아침", imageName: "sunrise-icon", hours: "07:00~09:00")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Spacer().frame(minWidth: 12)
                        ForEach(
                            Array(mealModel.morning.enumerated()),
                            id: \.offset
                        ) { index, courseModel in
                            MenuCard(
                                courseModel: courseModel,
                                colorVariation: .allCases[index % 3],
                                active: currentMealTime == .morning
                            )
                        }
                        Spacer().frame(minWidth: 12)
                    }
                }
                
                MealTitle("점심", imageName: "sun-icon", hours: "11:30~13:30")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Spacer().frame(minWidth: 12)
                        ForEach(
                            Array(mealModel.lunch.enumerated()),
                            id: \.offset
                        ) { index, courseModel in
                            MenuCard(
                                courseModel: courseModel,
                                colorVariation: .allCases[index % 3],
                                active: currentMealTime == .launch
                            )
                        }
                        Spacer().frame(minWidth: 12)
                    }
                }
                
                MealTitle("저녁", imageName: "moon-icon", hours: "17:30~19:00")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Spacer().frame(minWidth: 12)
                        ForEach(
                            Array(mealModel.dinner.enumerated()),
                            id: \.offset
                        ) { index, courseModel in
                            MenuCard(
                                courseModel: courseModel,
                                colorVariation: .allCases[index % 3],
                                active: currentMealTime == .dinner
                            )
                        }
                        Spacer().frame(minWidth: 12)
                    }
                }
            }
        }
    }
    
    private func MealTitle(
        _ title: String,
        imageName: String,
        hours: String = ""
    ) -> some View {
        return HStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24)
            Text(title)
                .typo(.body0b)
            Text("운영 시간 \(hours)")
                .typo(.body2)
                .foregroundStyle(.gray05)

        }
        .padding(.top, 8)
        .padding(.horizontal, 20)
    }
    
    private var currentMealTime: MealTime {
        let hour = Calendar.current.component(.hour, from: Date.now)
        let minute = Calendar.current.component(.minute, from: Date.now)
        
        if hour < 9 {
            return .morning
        } else if hour < 13 && minute < 30  {
            return .launch
        } else if hour < 19 {
            return .dinner
        } else {
            return .morning
        }
    }
    
}
