//
//  PhxHeroView.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 5/2/22.
//

import SwiftUI

struct PhxHeroView<R: CustomRegistry>: View {
    private let element: Element
    private let context: LiveContext<R>
    private let kind: Kind
    @EnvironmentObject private var animationCoordinator: NavAnimationCoordinator
    
    init(element: Element, context: LiveContext<R>) {
        self.element = element
        self.context = context
        self.kind = element.hasAttr("destination") ? .destination : .source
    }
    
    var hidesDuringAnimation: Bool {
        guard !UIAccessibility.prefersCrossFadeTransitions else {
            return false
        }
        // only hide when we're the hero view being animated to/from
        switch kind {
        case .destination:
            return animationCoordinator.destElement == element
        case .source:
            return animationCoordinator.sourceElement == element
        }
    }
    
    var body: some View {
        context.buildChildren(of: element)
            .background {
                GeometryReader { proxy in
                    let frameAndElement = FrameAndElement(globalFrame: proxy.frame(in: .global), element: element)
                    if kind == .source {
                        Color.clear
                            .preference(key: HeroViewSourceKey.self, value: frameAndElement)
                    } else {
                        Color.clear
                            .preference(key: HeroViewDestKey.self, value: frameAndElement)
                    }
                }
            }
            .opacity(animationCoordinator.state.isAnimating && hidesDuringAnimation ? 0 : 1)
    }
    
    private enum Kind {
        case source, destination
    }
}

struct HeroViewSourceKey: PreferenceKey {
    typealias Value = FrameAndElement?
    
    static var defaultValue: Value = nil
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

struct HeroViewDestKey: PreferenceKey {
    typealias Value = FrameAndElement?
    
    static var defaultValue: Value = nil
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

struct FrameAndElement: Equatable {
    let globalFrame: CGRect
    let element: Element
}
