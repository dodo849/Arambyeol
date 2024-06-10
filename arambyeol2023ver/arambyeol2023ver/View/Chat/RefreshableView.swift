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
        /// The state where the user has pulled down completely, triggering a refresh.
        case loading
        
        var indicatorOpacity: CGFloat {
            switch self {
            case .none:
                return 0
            case .pending:
                return 0.3
            case .loading:
                return 1
            }
        }
    }
    
    private var firstScrollOffset: CGFloat? = nil
    private var previousScrollOffset: CGFloat = 0
    var scrollOffset: CGFloat = 0 {
        didSet {
            if let initialOffset = firstScrollOffset {
                previousScrollOffset = oldValue
                let offsetDifference = scrollOffset - initialOffset
                scrollOffset = offsetDifference

                if state == .pending && scrollOffset <= 0 {
                    state = .none
                }
            } else {
                firstScrollOffset = scrollOffset
            }
        }
    }
    var differentialOffset: CGFloat {
        scrollOffset - previousScrollOffset
    }
    var state: State = .none
}

struct Block: View {
    @State var dragAmount = CGSize.zero
    var index: Int
    var body: some View {
        Rectangle()
            .foregroundColor(.black)
            .offset(dragAmount)
            .zIndex(dragAmount == .zero ? 0 : 1)
        
            .onTapGesture { }
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged {
                        self.dragAmount = CGSize(width: $0.translation.width, height: $0.translation.height)
                        print("\($0.translation.width)")
                    }
            )
    }
}


struct RefreshableView<Content: View>: View {
    let GEOMETRY_HEIGHT: CGFloat = 10
    let START_PENDING_OFFSET: CGFloat = 40
    let START_LOADING_OFFSET: CGFloat = 90
    
    @Namespace private var namespace
    
    @State var text: String = ""
    @State var refresable: Refreshable = .init()
    @State var isRefreshing: Bool = false
    
    @ViewBuilder var content: () -> Content
    var onRefresh: () async -> Void
    
    var body: some View {
//        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                geometry()
                
                content()
            }
//        }
        .offset(y: -GEOMETRY_HEIGHT)
        .overlay {
            VStack {
                indicatorImage
                    .opacity(refresable.state.indicatorOpacity)
                    .animation(.linear, value: refresable.state)
                    .offset(y: refresable.scrollOffset * 0.3)
                    .padding(.top, 10)
                Spacer()
            }
        }
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
                
                if refresable.state == .none
                    && refresable.scrollOffset > START_PENDING_OFFSET
                {
                    refresable.state = .pending
                }
                
                    if refresable.state == .pending
                        && refresable.scrollOffset > START_LOADING_OFFSET
                        && refresable.differentialOffset < -10
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
