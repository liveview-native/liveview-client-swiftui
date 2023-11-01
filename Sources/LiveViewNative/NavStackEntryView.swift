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
        elementTree
            .environmentObject(liveViewModel)
            .onReceive(coordinator.$document) { newDocument in
                if let doc = newDocument {
                    // todo: doing this every time the DOM changes is probably not efficient
                    liveViewModel.updateForms(nodes: doc[doc.root()].depthFirstChildren())
                }
            }
    }
    
    @ViewBuilder
    private var elementTree: some View {
        SwiftUI.Group {
            if coordinator.url == entry.url {
                switch coordinator.state {
                case .connected:
                    coordinator.builder.fromNodes(coordinator.document![coordinator.document!.root()].children(), coordinator: coordinator, url: coordinator.url)
                        .environment(\.coordinatorEnvironment, CoordinatorEnvironment(coordinator, document: coordinator.document!))
                        .transition(coordinator.session.configuration.transition ?? .identity)
                default:
                    SwiftUI.Group {
                        if case .notConnected = coordinator.state,
                           let document = coordinator.document
                        {
                           coordinator.builder.fromNodes(document[document.root()].children(), coordinator: coordinator, url: coordinator.url)
                               .environment(\.coordinatorEnvironment, CoordinatorEnvironment(coordinator, document: document))
                               .disabled(true)
                       } else if R.LoadingView.self == Never.self {
                            switch coordinator.state {
                            case .connected:
                                fatalError()
                            case .notConnected:
                                SwiftUI.Text("Not Connected")
                            case .connecting:
                                SwiftUI.ProgressView("Connecting")
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
                    .transition(coordinator.session.configuration.transition ?? .identity)
                }
            } else if let cachedNavigationTitle = liveViewModel.cachedNavigationTitle {
                SwiftUI.Text("").modifier(cachedNavigationTitle)
            }
        }
        .animation(coordinator.session.configuration.transition.map({ _ in .default }), value: { () -> Bool in
            if case .connected = coordinator.state {
                return true
            } else {
                return false
            }
        }())
    }
}
