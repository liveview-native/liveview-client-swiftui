//
//  NavStackEntryView.swift
// LiveViewNative
//
//  Created by Shadowfacts on 3/23/22.
//

import SwiftUI
import LiveViewNativeCore

struct NavStackEntryView<R: CustomRegistry>: View {
    private let entry: LiveNavigationEntry<R>
    @ObservedObject private var coordinator: LiveViewCoordinator<R>
    @StateObject private var liveViewModel = LiveViewModel<R>()
    
    init(_ entry: LiveNavigationEntry<R>) {
        self.entry = entry
        self.coordinator = entry.coordinator
    }
    
    var body: some View {
        let _ = Self._printChanges()
        elementTree
            .environmentObject(liveViewModel)
            .task {
                // If the coordinator is not connected to the right URL, update it.
                if coordinator.url != entry.url {
                    coordinator.url = entry.url
                    await coordinator.reconnect()
                } else {
                    await coordinator.connect()
                }
            }
            .onReceive(coordinator.$document) { newDocument in
                if let doc = newDocument {
                    // todo: doing this every time the DOM changes is probably not efficient
                    liveViewModel.updateForms(nodes: doc[doc.root()].depthFirstChildren())
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
