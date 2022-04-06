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
    @State private var state: ConnectionState = .notConnected
    
    init(coordinator: LiveViewCoordinator<R>, url: URL) {
        self._coordinator = StateObject(wrappedValue: coordinator)
        self._url = State(initialValue: url)
    }
    
    var body: some View {
        elementTree
            .environmentObject(liveViewModel)
            .onReceive(coordinator.$elements) { newValue in
                // todo: things will go weird if the same url occurs multiple times in the navigation stack
                if coordinator.currentURL == url {
                    self.state = .connected(newValue)
                    // todo: doing this every time the DOM changes is probably not efficient
                    liveViewModel.pruneMissingForms(elements: newValue)
                }
            }
            .onReceive(coordinator.$state) { newValue in
                if coordinator.currentURL == url,
                   case .connectionFailed(let error) = state {
                    self.state = .connectionFailed(error)
                }
            }
            .onReceive(coordinator.replaceRedirectSubject) { (oldURL, newURL) in
                // when the page is redirected, we need to update this view's url so it receives elements from the new page
                if oldURL == url {
                    self.url = newURL
                }
            }
    }
    
    @ViewBuilder
    private var elementTree: some View {
        // todo: make this customizable via the registry?
        switch state {
        case .notConnected:
            Text("Not Connected")
        case .connected(let elements):
            coordinator.builder.fromElements(elements, coordinator: coordinator, url: url)
        case .connectionFailed(let error):
            VStack {
                Text("Connection Failed")
                    .font(.subheadline)
                Text(error.localizedDescription)
            }
        }
    }
    
    enum ConnectionState {
        case notConnected
        case connected(Elements)
        case connectionFailed(Error)
    }
    
}
