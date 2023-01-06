//
//  NavStackEntryView.swift
// LiveViewNative
//
//  Created by Shadowfacts on 3/23/22.
//

import SwiftUI
import LiveViewNativeCore

struct NavStackEntryView<R: CustomRegistry>: View {
    // this is a @StateObject instead of @ObservedObject because changing which DOMWindows for a LiveView is not allowed
    @StateObject private var coordinator: LiveViewCoordinator<R>
    @StateObject private var liveViewModel = LiveViewModel<R>()
    
    init(session: LiveSessionCoordinator<R>, url: URL) {
        self._coordinator = .init(wrappedValue: .init(session: session, url: url))
    }
    
    var body: some View {
        // TODO: the ZStack is a workaround for an iOS 16 beta bug, check back before release to see if it's still needed
        let _ = Self._printChanges()
        SwiftUI.ZStack {
            elementTree
                .environmentObject(liveViewModel)
                .task {
                    await coordinator.connect()
                }
                .onReceive(coordinator.$document) { newDocument in
                    // todo: things will go weird if the same url occurs multiple times in the navigation stack
                    if let doc = newDocument {
                        // todo: doing this every time the DOM changes is probably not efficient
                        liveViewModel.updateForms(nodes: doc[doc.root()].depthFirstChildren())
                    }
                }
        }
    }
    
    @ViewBuilder
    private var elementTree: some View {
        switch coordinator.state {
        case .connected:
            if let doc = coordinator.document {
                coordinator.builder.fromNodes(doc[doc.root()].children(), coordinator: coordinator, url: coordinator.url)
                    .environment(\.coordinatorEnvironment, CoordinatorEnvironment(coordinator, document: doc))
            } else {
                fatalError("State is `.connected`, but no `Document` was found.")
            }
        default:
            if R.LoadingView.self == Never.self {
                switch coordinator.state {
                case .connected:
                    fatalError()
                case .notConnected:
                    SwiftUI.Text("Not Connected")
                case .connecting:
                    SwiftUI.Text("Connecting")
                case .connectionFailed(let error):
                    SwiftUI.VStack {
                        SwiftUI.Text("Connection Failed")
                            .font(.subheadline)
                        SwiftUI.Text(error.localizedDescription)
                    }
                }
            } else {
                R.loadingView(for: coordinator.url, state: coordinator.state)
            }
        }
    }
}
