//
//  NavStackEntryView.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 3/23/22.
//

import SwiftUI
import LiveViewNativeCore

struct NavStackEntryView<R: CustomRegistry>: View {
    // this is a @StateObject instead of @ObservedObject because changing which DOMWindows for a LiveView is not allowed
    @StateObject private var coordinator: LiveViewCoordinator<R>
    @StateObject private var liveViewModel = LiveViewModel<R>()
    // TODO: once we target iOS 16 only, this should be non-State and only come from the navigationDestination that creates this view
    @State private var url: URL
    @State private var state: ConnectionState = .other(.notConnected)
    
    init(coordinator: LiveViewCoordinator<R>, url: URL) {
        self._coordinator = StateObject(wrappedValue: coordinator)
        self._url = State(initialValue: url)
    }
    
    var body: some View {
        // TODO: the ZStack is a workaround for an iOS 16 beta bug, check back before release to see if it's still needed
        let _ = Self._printChanges()
        ZStack {
            elementTree
                .environmentObject(liveViewModel)
                .onReceive(coordinator.$document) { newDocument in
                    // todo: things will go weird if the same url occurs multiple times in the navigation stack
                    if coordinator.currentURL == url,
                       let doc = newDocument {
                        self.state = .connected(doc)
                        // todo: doing this every time the DOM changes is probably not efficient
                        liveViewModel.updateForms(nodes: doc[doc.root()].depthFirstChildren())
                    }
                }
                .onReceive(coordinator.$internalState) { newValue in
                    if coordinator.currentURL == url {
                        let newState = newValue.publicState
                        if case .connected(_) = state {
                            // if we're already connected, we only want to remove the cached elements if there's been an error reconnecting
                            if case .connectionFailed(_) = newState {
                                state = .other(newState)
                            }
                        } else {
                            state = .other(newState)
                        }
                    }
                }
                .onReceive(coordinator.replaceRedirectSubject) { (oldURL, newURL) in
                    // when the page is redirected, we need to update this view's url so it receives elements from the new page
                    if oldURL == url {
                        self.url = newURL
                    }
                }
        }
    }
    
    @ViewBuilder
    private var elementTree: some View {
        switch state {
        case .connected(let doc):
            coordinator.builder.fromNodes(doc[doc.root()].children(), coordinator: coordinator, url: url)
                .environment(\.coordinatorEnvironment, CoordinatorEnvironment(coordinator))
        case .other(let lvState):
            if R.self.LoadingView == Never.self {
                switch lvState {
                case .connected:
                    fatalError("unreachable")
                case .notConnected:
                    Text("Not Connected")
                case .connecting:
                    Text("Connecting")
                case .connectionFailed(let error):
                    VStack {
                        Text("Connection Failed")
                            .font(.subheadline)
                        Text(error.localizedDescription)
                    }
                }
            } else {
                R.loadingView(for: url, state: lvState)
            }
        }
    }
    
    enum ConnectionState {
        case connected(Document)
        case other(LiveViewCoordinator<R>.State)
    }
    
}
