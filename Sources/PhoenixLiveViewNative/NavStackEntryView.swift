//
//  NavStackEntryView.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 3/23/22.
//

import SwiftUI
import SwiftSoup

struct NavStackEntryView<R: CustomRegistry>: View {
    // this is a @StateObject instead of @ObservedObject because changing which DOMWindows for a LiveView is not allowed
    @StateObject private var coordinator: LiveViewCoordinator<R>
    @StateObject private var liveViewModel = LiveViewModel<R>()
    @State private var url: URL
    @State private var state: ConnectionState = .other(.notConnected)
    
    init(coordinator: LiveViewCoordinator<R>, url: URL) {
        self._coordinator = StateObject(wrappedValue: coordinator)
        self._url = State(initialValue: url)
    }
    
    var body: some View {
        // TODO: the ZStack is a workaround for an iOS 16 beta bug, check back before release to see if it's still needed
        ZStack {
            elementTree
                .environmentObject(liveViewModel)
                .onReceive(coordinator.$elements) { newValue in
                    // todo: things will go weird if the same url occurs multiple times in the navigation stack
                    if coordinator.currentURL == url,
                       let elements = newValue {
                        self.state = .connected(elements)
                        // todo: doing this every time the DOM changes is probably not efficient
                        liveViewModel.pruneMissingForms(elements: elements)
                    }
                }
                .onReceive(coordinator.$state) { newValue in
                    if coordinator.currentURL == url {
                        if case .connected(_) = state {
                            // if we're already connected, we only want to remove the cached elements if there's been an error reconnecting
                            if case .connectionFailed(_) = newValue {
                                state = .other(newValue)
                            }
                        } else {
                            state = .other(newValue)
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
        case .connected(let elements):
            coordinator.builder.fromElements(elements, coordinator: coordinator, url: url)
        case .other(let lvState):
            if R.self.LoadingView == Never.self {
                let _ = print(lvState)
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
        case connected(Elements)
        case other(LiveViewCoordinator<R>.State)
    }
    
}
