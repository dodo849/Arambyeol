//
//  MenuCard.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 7/3/24.
//

import SwiftUI

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
            
            Text("\(menu.split(separator: "").joined(separator: "\u{200B}"))")
                .typo(.body2)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .frame(maxWidth: 200)
        .frame(minHeight: 150)
        .background(active ? colorVariation.backgroundColor : .gray02)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var menu: String {
        return courseModel.menu.joined(separator: ", ")
    }
}
