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
                    .padding(.leading, 8)
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
                MenuPage(
                    mealModel: viewModel.menu.today,
                    hoursOfOperation: viewModel.hoursOfOperation,
                    currentMealtime: viewModel.currentMealTime
                )
                .tag(MenuDay.today)
                MenuPage(
                    mealModel: viewModel.menu.tomorrow,
                    hoursOfOperation: viewModel.hoursOfOperation,
                    currentMealtime: viewModel.currentMealTime)
                .tag(MenuDay.tomorrow)
                MenuPage(
                    mealModel: viewModel.menu.theDayAfterTomorrow,
                    hoursOfOperation: viewModel.hoursOfOperation,
                    currentMealtime: viewModel.currentMealTime)
                .tag(MenuDay.afterTomorrow)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.bouncy, value: selectedDay)
            
            NavigationLink(
                destination: ChatView(),
                isActive: $shawChatView
            ) {
                EmptyView()
            }
            
        }
        .onAppear {
            viewModel.$action.send(.onAppear)
        }
        .ignoresSafeArea(edges: .bottom)
        .customNavigationBar()
        .navigationBarItems(
            leading:
                HStack {
                    Image("arambyeol-logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                    Text("아람별")
                        .typo(.body1b)
                        .foregroundColor(.gray06)
                }
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
