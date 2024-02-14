//
//  NavStackEntryView.swift
// LiveViewNative
//
//  Created by Shadowfacts on 3/23/22.
//

import SwiftUI
import LiveViewNativeCore

struct NavStackEntryView<R: RootRegistry>: View {
    private let entry: LiveNavigationEntry<R>
    @ObservedObject private var coordinator: LiveViewCoordinator<R>
    @StateObject private var liveViewModel = LiveViewModel()
    @Environment(\.liveViewStateViews) private var liveViewStateViews
    
    init(_ entry: LiveNavigationEntry<R>) {
        self.entry = entry
        self.coordinator = entry.coordinator
    }
    
    var body: some View {
        elementTree
            .environmentObject(liveViewModel)
            .onReceive(coordinator.$document) { newDocument in
                if let doc = newDocument {
                    // todo: doing this every time the DOM changes is probably not efficient
                    liveViewModel.updateForms(nodes: doc[doc.root()].depthFirstChildren())
                }
            }
    }
    
    private func buildPhaseView(_ phase: LiveViewPhase<R>) -> some View {
        liveViewStateViews[ObjectIdentifier(R.self)]?(phase)
    }
    
    private var phase: LiveViewPhase<R> {
        switch coordinator.state {
        case .notConnected:
            return .disconnected
        case .connecting:
            return .connecting
        case .connectionFailed(let error):
            return .error(error)
        case .reconnecting, .connected: // these phases should always be handled internally
            fatalError()
        }
    }
    
    @ViewBuilder
    private var elementTree: some View {
        SwiftUI.Group {
            if coordinator.url == entry.url {
                if coordinator.state.isConnected || coordinator.state.isPending,
                   let document = coordinator.document
                {
                    coordinator.builder.fromNodes(document[document.root()].children(), coordinator: coordinator, url: coordinator.url)
                        .environment(\.coordinatorEnvironment, CoordinatorEnvironment(coordinator, document: document))
                        .disabled(coordinator.state.isPending)
                        .transition(coordinator.session.configuration.transition ?? .identity)
                        .id(ObjectIdentifier(document))
                } else {
                    buildPhaseView(phase)
                    .transition(coordinator.session.configuration.transition ?? .identity)
                }
            }
        }
        .animation(coordinator.session.configuration.transition.map({ _ in .default }), value: coordinator.state.isConnected)
    }
}

struct DetachedNavEntryView<R: RootRegistry>: View {
    private var url: URL
    @Environment(\.buildDetachedLiveView) private var buildDetachedLiveView
    
    init(url: URL) {
        self.url = url
    }
    
    var body: some View {
        buildDetachedLiveView(url)
            .id(url)
    }
}

extension EnvironmentValues {
    private enum BuildDetachedLiveViewKey: EnvironmentKey {
        static let defaultValue = { (_: URL) -> AnyView in AnyView(EmptyView()) }
    }
    
    /// Create an instance of ``LiveView`` for a given route.
    /// Used by ``DetachedNavEntryView`` to establish secondary connections.
    var buildDetachedLiveView: (URL) -> AnyView {
        get { self[BuildDetachedLiveViewKey.self] }
        set { self[BuildDetachedLiveViewKey.self] = newValue }
    }
}
