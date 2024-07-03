//
//  RefreshableView.swift
//  arambyeol2023ver
//
//  Created by DOYEON LEE on 6/10/24.
//

import SwiftUI

fileprivate struct Refreshable {
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
                return 0.2
            case .ready, .loading:
                return 1
            }
        }
    }
    
    private var previousScrollOffset: CGFloat = 0
    var topOffset: CGFloat = 0
    var scrollOffset: CGFloat = 0 {
        didSet {
            previousScrollOffset = oldValue
            scrollOffset -= topOffset // Subtract top area offset based on full screen
        }
    }
    var differentialOffset: CGFloat {
        scrollOffset - previousScrollOffset
    }
    var state: State = .none
}

extension View {
    func asIndicator() -> AnyView {
        return AnyView(self)
    }
}

struct RefreshableView<Content: View>: View {
    private let GEOMETRY_HEIGHT: CGFloat = 15
    private let START_PENDING_OFFSET: CGFloat = 40
    private let START_READY_OFFSET: CGFloat = 90
    
    @Namespace private var namespace
    
    @State private var refreshable: Refreshable = .init()
    @State private var isRefreshing: Bool = false
    
    private let reverse: Bool
    @ViewBuilder private var content: () -> Content
    @ViewBuilder private var indicator: () -> AnyView?
    private var onRefresh: () async -> Void
    
    init(
        reverse: Bool = false,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder indicator: @escaping () -> AnyView? = { nil },
        onRefresh: @escaping () async -> Void
    ) {
        self.reverse = reverse
        self.content = content
        self.indicator = indicator
        self.onRefresh = onRefresh
    }
    
    var body: some View {
        ScrollView(.vertical) {
            Group {
                if !reverse {
                    geometry()
                }
                content()
                    .rotationEffect(.degrees(reverse ? 180 : 0))
                    .scaleEffect(x: -1)
                
                if reverse {
                    geometry()
                }
            }
        }
        .background(
            GeometryReader { geometry in
                DispatchQueue.main.async {
                    refreshable.topOffset = geometry.frame(in: .named(namespace)).minY
                }
                return Color.clear
            }
        )
        .overlay {
            VStack {
                Group {
                    if let customIndicator = indicator() {
                        customIndicator
                    } else {
                        basicIndicator
                    }
                }
                .opacity(refreshable.state.indicatorOpacity)
                .offset(y: refreshable.scrollOffset * 0.3)
                .animation(.linear, value: refreshable.state)
                .padding(.top, 10)
                Spacer()
            }
            .rotationEffect(.degrees(reverse ? 180 : 0))
            .scaleEffect(x: -1)
        }
        .rotationEffect(.degrees(reverse ? 180 : 0))
        .scaleEffect(x: -1)
    }
    
    private var basicIndicator: some View {
        Image(systemName: "arrow.up")
            .padding(5)
            .background(.gray02)
            .cornerRadius(10)
            .foregroundStyle(.black)
    }
    
    @ViewBuilder
    private func geometry() -> some View {
        GeometryReader { geometry in
            DispatchQueue.main.async {
                refreshable.scrollOffset = geometry.frame(in: .named(namespace)).minY
                
                // If in pending or ready state and canceled before reaching ready
                if refreshable.state == .pending
                    || refreshable.state == .ready
                    && refreshable.scrollOffset <= 0
                {
                    refreshable.state = .none
                }
                
                // If pulled to pending state where the refresh indicator is visible
                if refreshable.state == .none
                    && refreshable.scrollOffset > START_PENDING_OFFSET
                {
                    refreshable.state = .pending
                }
                
                // If pulled to ready state confirming the refresh
                if refreshable.state == .pending
                    && refreshable.scrollOffset > START_READY_OFFSET
                {
                    refreshable.state = .ready
                }
                
                // If in ready state and the view is released (detected by dy), start refresh loading
                if refreshable.state == .ready
                    && refreshable.scrollOffset > START_READY_OFFSET
                    && isDragEnd(dy: refreshable.differentialOffset) // dy
                    && !isRefreshing
                {
                    isRefreshing = true
                    refreshable.state = .loading
                    Task {
                        await onRefresh()
                        DispatchQueue.main.async {
                            refreshable.state = .none
                            isRefreshing = false
                        }
                    }
                }
            }
            
            return Color.clear
        }
    }
    
    /// Considered as the user has released their touch and the scroll view is returning to its original state
    /// if the change in the scroll view's offset is significantly negative.
    private func isDragEnd(dy: CGFloat) -> Bool {
        return refreshable.differentialOffset < -10
    }
}
