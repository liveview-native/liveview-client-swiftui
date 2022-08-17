//
//  PhxHeroView.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 5/2/22.
//

import SwiftUI

/// `<phx-hero>`, wraps the source and destination elements that are used for the hero transition when navigating.
public struct PhxHeroView<R: CustomRegistry>: View {
    private let element: Element
    private let context: LiveContext<R>
    private let kind: Kind
    @EnvironmentObject private var navCoordinator: NavigationCoordinator
    @State private var frameProvider: FrameProvider?
    
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
    
    public var body: some View {
        withFramePreference(context.buildChildren(of: element))
            .background {
                // can't use GeometryReader because on iOS 16, it returns the wrong frame in the global coordinate space during the navigation transition
                GlobalGeometryReader {
                    // when animating, don't update the source's position because the builtin navigation transition
                    // alters the position in window-space of the source but we want to keep the original, unaltered pos
                    if kind != .source || !navCoordinator.state.isAnimating {
                        self.frameProvider = $0
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
        if let frameProvider = frameProvider {
            let frameAndElement = FrameAndElement(element: element, frameProvider: frameProvider)
            if kind == .source {
                content.preference(key: HeroViewSourceKey.self, value: frameAndElement)
            } else {
                content.preference(key: HeroViewDestKey.self, value: frameAndElement)
            }
        } else {
            content
        }
    }
}

private struct GlobalGeometryReader: UIViewRepresentable {
    typealias UIViewType = UIView
    
    let callback: (FrameProvider?) -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            let provider = FrameProvider { [weak view] in
                guard let view = view else {
                    return .zero
                }
                return view.convert(view.bounds, to: nil)
            }
            callback(provider)
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

struct HeroViewOverride: Equatable {
    let view: AnyView
    let id: UUID
    
    init<V: View>(_ view: V) {
        self.view = AnyView(view)
        self.id = UUID()
    }
    
    static func ==(lhs: HeroViewOverride, rhs: HeroViewOverride) -> Bool {
        return lhs.id == rhs.id
    }
}

struct HeroViewOverrideKey: PreferenceKey {
    typealias Value = HeroViewOverride?
    
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
    let element: Element
    let frameProvider: FrameProvider
}

struct FrameProvider: Equatable {
    let provider: () -> CGRect
    let id: UUID
    
    init(_ provider: @escaping () -> CGRect) {
        self.provider = provider
        self.id = UUID()
    }
    
    func callAsFunction() -> CGRect {
        return provider()
    }
    
    static func ==(lhs: FrameProvider, rhs: FrameProvider) -> Bool {
        return lhs.id == rhs.id
    }
}
