//
//  MenuPage.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 7/3/24.
//

import SwiftUI

import Factory

struct MenuPage: View {
    @Injected(\.menuUsecase) private var menuUsecase
    var mealModel: MealModel
    
    var body: some View {
        let hours = menuUsecase.getHoursOfOperation()
        let mealTime = menuUsecase.getCurrentMealTime()
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                mealTitle(
                    "아침",
                    imageName: "sunrise-icon",
                    hours: hours.morning
                )
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
                                active: mealTime == .morning
                            )
                        }
                        Spacer().frame(minWidth: 12)
                    }
                }
                
                mealTitle(
                    "점심",
                    imageName: "sun-icon",
                    hours: hours.lunch
                )
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
                                active: mealTime == .launch
                            )
                        }
                        Spacer().frame(minWidth: 12)
                    }
                }
                
                mealTitle(
                    "저녁",
                    imageName: "moon-icon",
                    hours: hours.dinner
                )
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
                                active: mealTime == .dinner
                            )
                        }
                        Spacer().frame(minWidth: 12)
                    }
                }
            }
        }
    }
    
    private func mealTitle(
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
                Text("운영시간 \(hours)")
                    .typo(.body2)
                    .foregroundStyle(.gray05)
            }
        .padding(.top, 8)
        .padding(.horizontal, 20)
    }
}
