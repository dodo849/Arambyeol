//
//  ScrollOffset+Extension.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/8/24.
//

import SwiftUI

//struct ScrollOffsetPreferenceKey: PreferenceKey {
//    typealias Value = CGFloat
//
//    static var defaultValue: CGFloat = 0
//
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value += nextValue()
//    }
//}
//
//
//struct ScrollOffsetModifier: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .background(GeometryReader {
//                Color.clear.preference(
//                    key: ScrollOffsetPreferenceKey.self,
//                    value: $0.frame(in: .named("scrollView")).minY
//                )
//            })
//    }
//}
//
//extension View {
//    func trackScrollOffset() -> some View {
//        self.modifier(ScrollOffsetModifier())
//    }
//}

struct ScrollViewWithOffset<Content: View>: View {
  var axes: Axis.Set = .vertical
  var showsIndicators: Bool = true
  
  @Binding var scrollOffset: CGPoint
  @ViewBuilder var content: (ScrollViewProxy) -> Content
  
  @Namespace var coordinateSpaceName: Namespace.ID
  
  init(
    _ axes: Axis.Set = .vertical,
    showsIndicators: Bool = true,
    scrollOffset: Binding<CGPoint>,
    @ViewBuilder content: @escaping (ScrollViewProxy) -> Content
  ) {
    self.axes = axes
    self.showsIndicators = showsIndicators
    self._scrollOffset = scrollOffset
    self.content = content
  }
  
  var body: some View {
    ScrollView(axes, showsIndicators: showsIndicators) {
      ScrollViewReader { scrollViewProxy in
        content(scrollViewProxy)
          .background {
            GeometryReader { geometryProxy in
              Color.clear
                .preference(
                  key: ScrollOffsetPreferenceKey.self,
                  value: CGPoint(
                    x: -geometryProxy.frame(in: .named(coordinateSpaceName)).minX,
                    y: -geometryProxy.frame(in: .named(coordinateSpaceName)).minY
                  )
                )
            }
          }
      }
    }
    .coordinateSpace(name: coordinateSpaceName)
    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
      scrollOffset = value
    }
  }
  
  private struct ScrollOffsetPreferenceKey: SwiftUI.PreferenceKey {
    static var defaultValue: CGPoint { .zero }
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
      value.x += nextValue().x
      value.y += nextValue().y
    }
  }
}
