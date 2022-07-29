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
    @EnvironmentObject private var navCoordinator: NavigationCoordinator
    @State private var globalFrame: CGRect?
    
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
            return navCoordinator.destElement == element
        case .source:
            return navCoordinator.sourceElement == element
        }
    }
    
    var body: some View {
        withFramePreference(context.buildChildren(of: element))
            .background {
                // can't use GeometryReader because on iOS 16, it returns the wrong frame in the global coordinate space during the navigation transition
                GlobalGeometryReader {
                    // when animating, don't update the source's position because the builtin navigation transition
                    // alters the position in window-space of the source but we want to keep the original, unaltered pos
                    if kind != .source || !navCoordinator.state.isAnimating {
                        self.globalFrame = $0
                    }
                }
            }
            .opacity(navCoordinator.state.isAnimating && hidesDuringAnimation ? 0 : 1)
    }
    
    private enum Kind {
        case source, destination
    }
    
    @ViewBuilder
    func withFramePreference<V: View>(_ content: V) -> some View {
        if kind == .source {
            content.preference(key: HeroViewSourceKey.self, value: FrameAndElement(globalFrame: globalFrame ?? .zero, element: element))
        } else {
            content.preference(key: HeroViewDestKey.self, value: FrameAndElement(globalFrame: globalFrame ?? .zero, element: element))
        }
    }
}

private struct GlobalGeometryReader: UIViewRepresentable {
    typealias UIViewType = View
    
    let callback: (CGRect) -> Void
    
    func makeUIView(context: Context) -> View {
        return View()
    }
    
    func updateUIView(_ uiView: View, context: Context) {
        uiView.callback = callback
    }
    
    class View: UIView {
        var callback: ((CGRect) -> Void)? = nil
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            callback?(self.convert(bounds, to: nil))
        }
    }
}

struct HeroViewOverrideKey: PreferenceKey {
    typealias Value = Image?
    
    static var defaultValue: Value = nil
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
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
