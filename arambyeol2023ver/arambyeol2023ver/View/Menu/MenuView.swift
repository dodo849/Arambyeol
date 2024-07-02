//
//  MenuView.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 7/3/24.
//

import SwiftUI

struct MenuView: View {
    @StateObject var viewModel: MenuViewModel = MenuViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Text("아침")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.menu?.today.morning ?? []) { course in
                        MenuCard(
                            course: course,
                            colorVariation: .primary,
                            active: true
                        )
                    }
                }
            }
            .onAppear {
                viewModel.$action.send(.onAppear)
            }
        }
    }
}

#Preview {
    MenuView()
}

struct MenuCard: View {
    enum ColorVariation {
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
    
    let course: CourseModel
    let colorVariation: ColorVariation
    let active: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(courseTitle)")
                Text("\(courseType)")
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
        .padding(.horizontal, 20)
        .frame(width: 220)
        .frame(minHeight: 120)
        .background(active ? colorVariation.backgroundColor : .gray02)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var courseTitle: String {
        let components = course.course.split(separator: "/")
        if components.count > 0 {
            return String(components[0])
        } else {
            return ""
        }
    }

    private var courseType: String {
        let components = course.course.split(separator: "/")
        if components.count > 1 {
            return String(components[1])
        } else {
            return ""
        }
    }
    
    private var menu: String {
        return course.menu.joined(separator: ", ")
    }
}
