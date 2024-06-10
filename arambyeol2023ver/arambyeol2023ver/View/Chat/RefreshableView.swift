//
//  RefreshableView.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/10/24.
//

import SwiftUI


struct Refreshable {
    let START_OFFSET: CGFloat = 40
    
    enum State {
        /// The state where the user has not pulled down.
        case none
        /// The state where the user has slightly pulled down but not enough to trigger a refresh.
        case pending
        /// The state where the user has pulled down sufficiently to be ready to trigger a refresh.
        case ready
        /// The state where the user has pulled down completely, and the refresh action is actively running.
        case loading
        
        var indicatorOpacity: CGFloat {
            switch self {
            case .none:
                return 0
            case .pending:
                return 0.4
            case .ready, .loading:
                return 1
            }
        }
    }
    
    private var previousScrollOffset: CGFloat = 0
    var scrollOffset: CGFloat = 0 {
        didSet {
                previousScrollOffset = oldValue
                scrollOffset -= 97.66666666666666 // 이 값을 어떻게 뺄지 모르겠다. 하단에 텍스트필드 영역 + 세이프영역인듯
        }
    }
    var differentialOffset: CGFloat {
        scrollOffset - previousScrollOffset
    }
    var state: State = .none
}

struct RefreshableView<Content: View>: View {
    let GEOMETRY_HEIGHT: CGFloat = 10
    let START_PENDING_OFFSET: CGFloat = 40
    let START_READY_OFFSET: CGFloat = 90
    
    @Namespace private var namespace
    
    @State var text: String = ""
    @State var refresable: Refreshable = .init()
    @State var isRefreshing: Bool = false
    
    @ViewBuilder var content: () -> Content
    var onRefresh: () async -> Void
    let reverse: Bool
    
    init(
        reverse: Bool = false,
        @ViewBuilder content: @escaping () -> Content,
        onRefresh: @escaping () async -> Void)
    {
        self.reverse = reverse
        self.content = content
        self.onRefresh = onRefresh
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Group {
                if !reverse {
                    geometry()
                }
                content()
                    .rotationEffect(Angle(degrees: reverse ? 180 : 0))
                
                if reverse {
                    geometry()
                }
            }
        }
        .offset(y: 0)
        .overlay {
            VStack {
                indicatorImage
                    .opacity(refresable.state.indicatorOpacity)
                    .offset(y: refresable.scrollOffset * 0.3)
                    .animation(.linear, value: refresable.state)
                    .padding(.top, 10)
                Spacer()
            }
            .rotationEffect(Angle(degrees: reverse ? 180 : 0))
        }
        .rotationEffect(Angle(degrees: reverse ? 180 : 0))
    }
    
    var indicatorImage: some View {
        Image(systemName: "arrow.up")
            .padding(5)
            .background(.gray01)
            .cornerRadius(10)
            .foregroundStyle(.black)
    }
    
    @ViewBuilder
    private func geometry() -> some View {
        GeometryReader { geometry in
            DispatchQueue.main.async {
                refresable.scrollOffset = geometry.frame(in: .named(namespace)).minY
                
                // If in pending or ready state and canceled before reaching ready
                if refresable.state == .pending
                    || refresable.state == .ready
                    && refresable.scrollOffset <= 0
                {
                    refresable.state = .none
                }

                // If pulled to pending state where the refresh indicator is visible
                if refresable.state == .none
                    && refresable.scrollOffset > START_PENDING_OFFSET
                {
                    refresable.state = .pending
                }

                // If pulled to ready state confirming the refresh
                if refresable.state == .pending
                    && refresable.scrollOffset > START_READY_OFFSET
                {
                    refresable.state = .ready
                }

                // If in ready state and the view is released (detected by dy), start refresh loading
                if refresable.state == .ready
                    && refresable.scrollOffset > START_READY_OFFSET
                    && refresable.differentialOffset < -10 // dy
                    && !isRefreshing
                {
                    isRefreshing = true
                    refresable.state = .loading
                    Task {
                        await onRefresh()
                        DispatchQueue.main.async {
                            refresable.state = .none
                            isRefreshing = false
                        }
                    }
                }

            }
            
            return Color.clear
        }
    }
    
}
