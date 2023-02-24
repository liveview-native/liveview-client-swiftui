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
            .onReceive(coordinator.receiveEvent("_live_bindings"), perform: liveViewModel.updateBindings)
            .onReceive(
                liveViewModel.bindingUpdatedByClient
                    .collect(.byTime(RunLoop.main, RunLoop.main.minimumTolerance))
            ) { updates in
                Task {
                    try? await coordinator.pushEvent(type: "_live_bindings", event: "_live_bindings", value: Dictionary(updates, uniquingKeysWith: { cur, new in new }))
                }
            }
    }
    
    @ViewBuilder
    private var elementTree: some View {
        if coordinator.url == entry.url {
            switch coordinator.state {
            case .connected:
                if let doc = coordinator.document {
                    coordinator.builder.fromNodes(doc[doc.root()].children(), coordinator: coordinator, url: coordinator.url)
                        .environment(\.coordinatorEnvironment, CoordinatorEnvironment(coordinator, document: doc))
                        .onPreferenceChange(NavigationTitleModifierKey.self) { navigationTitle in
                            self.liveViewModel.cachedNavigationTitle = navigationTitle
                            print("Nav title changed")
                        }
                } else {
                    fatalError("State is `.connected`, but no `Document` was found.")
                }
            default:
                let content = SwiftUI.Group {
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
                if let cachedNavigationTitle = liveViewModel.cachedNavigationTitle {
                    content.modifier(cachedNavigationTitle)
                } else {
                    content
                }
            }
        } else if let cachedNavigationTitle = liveViewModel.cachedNavigationTitle {
            SwiftUI.Text("").modifier(cachedNavigationTitle)
        }
    }
}
