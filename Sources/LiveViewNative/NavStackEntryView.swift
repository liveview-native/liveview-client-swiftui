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
    
    var stateViews: LiveViewStateViews<R> {
        (liveViewStateViews[ObjectIdentifier(R.self)] as? LiveViewStateViews<R>)
            ?? LiveViewStateViews<R>(connecting: { fatalError() }, disconnected: { fatalError() }, reconnecting: { _, _ in fatalError() }, error: { _ in fatalError() })
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
                    SwiftUI.Group {
                        switch coordinator.state {
                        case .connected, .reconnecting:
                            fatalError()
                        case .notConnected:
                            stateViews.disconnectedView()
                        case .connecting:
                            stateViews.connectingView()
                        case .connectionFailed(let error):
                            stateViews.errorView(error)
                        }
                    }
                    .transition(coordinator.session.configuration.transition ?? .identity)
                }
            }
        }
        .animation(coordinator.session.configuration.transition.map({ _ in .default }), value: coordinator.state.isConnected)
    }
}
