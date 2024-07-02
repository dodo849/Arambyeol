//
//  MenuView.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 7/3/24.
//

import SwiftUI

struct MenuView: View {
    @StateObject var viewModel: MenuViewModel = MenuViewModel()
    @State var selectedDay: MenuDay = .today
    
    @State var showTimetable : Bool = false
    @State var shawChatView: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                GeometryReader { geometry in
                    SegmentControl(MenuDay.allCases, selection: $selectedDay) { day in
                        Text("\(day.text)")
                            .typo(.body2b)
                    }
                    .styled(color: .stone, shape: .pill)
                    .frame(maxWidth: geometry.size.width * 0.6)
                    .shadow(color: .clear, radius: 0)
                }
                .frame(maxHeight: 50)
            }
            .background(.basicBackground)
            .background(
                Rectangle()
                    .shadow(color: .basicText.opacity(0.1), radius: 10)
            )
            
            TabView(selection: $selectedDay) {
                MenuPage(mealModel: viewModel.menu.today)
                    .tag(MenuDay.today)
                MenuPage(mealModel: viewModel.menu.tomorrow)
                    .tag(MenuDay.tomorrow)
                MenuPage(mealModel: viewModel.menu.theDayAfterTomorrow)
                    .tag(MenuDay.afterTomorrow)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
        }
        .onAppear {
            viewModel.$action.send(.onAppear)
        }
        .customNavigationBar()
        .navigationBarItems(
            leading: Button(
                action: {
                    showTimetable = true
                }, label: {
                    HStack {
                        Image("arambyeol-logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                            .sheet(isPresented: $showTimetable) {
                                TimeTableView()
                            }
                        Text("아람별")
                            .typo(.body1b)
                            .foregroundColor(.gray06)
                    }
                }
            )
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    shawChatView = true
                } label: {
                    Image(systemName: "bubble.left.and.bubble.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.gray06)
                        .frame(width: 25)
                }
            }
        }
    }
}

#Preview {
    MenuView()
}

struct MenuPage: View {
    var mealModel: MealModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                MealTitle("아침", imageName: "sunrise-icon", hours: "07:00~09:00")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
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
                    }
                }
                
                MealTitle("점심", imageName: "sun-icon", hours: "11:30~13:30")
                    .padding(.top, 8)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
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
                    }
                }
                
                MealTitle("저녁", imageName: "moon-icon", hours: "17:30~19:00")
                    .padding(.top, 8)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
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

struct MenuCard: View {
    enum ColorVariation: CaseIterable {
        case primary
        case secondary
        case tertiary
        
        var highlightColor: Color {
            switch self {
            case .primary: .basicYellow
            case .secondary: .basicGreen
            case .tertiary: .basicPink
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .primary: .basicYellowSoft
            case .secondary: .basicGreenSoft
            case .tertiary: .basicPinkSoft
            }
        }
    }
    
    let courseModel: CourseModel
    let colorVariation: ColorVariation
    let active: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Text("\(courseModel.courseName)")
                Text("\(courseModel.courseType)")
                    .foregroundStyle(
                        active ? colorVariation.highlightColor : .gray05
                    )
            }
            .typo(.body1b)
            
            Text("\(menu)")
                .typo(.body2)
            
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 18)
        .frame(width: 220)
        .frame(minHeight: 120)
        .background(active ? colorVariation.backgroundColor : .gray02)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var menu: String {
        return courseModel.menu.joined(separator: ", ")
    }
}
