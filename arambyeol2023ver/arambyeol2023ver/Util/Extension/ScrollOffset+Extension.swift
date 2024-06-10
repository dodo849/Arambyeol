//
//  ScrollOffset+Extension.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/8/24.
//

import SwiftUI

fileprivate struct ScrollOffsetPreferenceKey: SwiftUI.PreferenceKey {
    static var defaultValue: CGPoint { .zero }
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value.x += nextValue().x
        value.y += nextValue().y
    }
}

extension View {
    func trackScrollOffset(namespace: Namespace.ID) -> some View {
        self.background {
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(
                        key: ScrollOffsetPreferenceKey.self,
                        value: CGPoint(
                            x: -geometryProxy.frame(in: .named(namespace)).minX,
                            y: -geometryProxy.frame(in: .named(namespace)).minY
                        )
                    )
            }
        }
    }
    
    func bindScrollOffset(scrollOffset: Binding<CGPoint>) -> some View {
        self.onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset.wrappedValue = value
        }
    }
}

//struct ScrollViewWithOffset<Content: View>: View {
//    var axes: Axis.Set = .vertical
//    var showsIndicators: Bool = true
//
//    @Binding var scrollOffset: CGPoint
//    @ViewBuilder var content: (ScrollViewProxy) -> Content
//
//    @Namespace var coordinateSpaceName: Namespace.ID
//
//    init(
//        _ axes: Axis.Set = .vertical,
//        showsIndicators: Bool = true,
//        scrollOffset: Binding<CGPoint>,
//        @ViewBuilder content: @escaping (ScrollViewProxy) -> Content
//    ) {
//        self.axes = axes
//        self.showsIndicators = showsIndicators
//        self._scrollOffset = scrollOffset
//        self.content = content
//    }
//
//    var body: some View {
//        ScrollViewReader { scrollViewProxy in
//            ScrollView(axes, showsIndicators: showsIndicators) {
//                content(scrollViewProxy)
//                    .background {
//                        GeometryReader { geometryProxy in
//                            Color.clear
//                                .preference(
//                                    key: ScrollOffsetPreferenceKey.self,
//                                    value: CGPoint(
//                                        x: -geometryProxy.frame(in: .named(coordinateSpaceName)).minX,
//                                        y: -geometryProxy.frame(in: .named(coordinateSpaceName)).minY
//                                    )
//                                )
//                        }
//                    }
//            }
//            .coordinateSpace(name: coordinateSpaceName)
//            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
//                scrollOffset = value
//                print(value)
//            }
//        }
//    }
//
//}
//

