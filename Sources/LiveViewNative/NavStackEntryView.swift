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
    @StateObject private var liveViewModel = LiveViewModel(bindingValue: R.bindingValue, setBindingValue: R.setBindingValue, globalBindings: { R.globalBindings }, registerGlobalBinding: R.registerGlobalBinding)
    
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
            .onReceive(coordinator.receiveEvent("_native_bindings"), perform: liveViewModel.updateBindings)
            .onReceive(coordinator.receiveEvent("_native_bindings_init"), perform: liveViewModel.initBindings(payload:))
            .onReceive(
                liveViewModel.bindingUpdatedByClient
                    .collect(.byTime(RunLoop.current, RunLoop.current.minimumTolerance))
            ) { updates in
                Task {
                    // In some cases, the bindings will update as the page is navigating.
                    // Don't send the bindings to the wrong live view in this case.
                    guard entry.url == coordinator.url else { return }
                    try? await coordinator.pushEvent(type: "_native_bindings", event: "_native_bindings", value: Dictionary(updates, uniquingKeysWith: { cur, new in new }))
                }
            }
    }
    
    @ViewBuilder
    private var elementTree: some View {
        if coordinator.url == entry.url {
            switch coordinator.state {
            case .connected:
                coordinator.builder.fromNodes(coordinator.document![coordinator.document!.root()].children(), coordinator: coordinator, url: coordinator.url)
                    .environment(\.coordinatorEnvironment, CoordinatorEnvironment(coordinator, document: coordinator.document!))
                    .onPreferenceChange(NavigationTitleModifierKey.self) { navigationTitle in
                        self.liveViewModel.cachedNavigationTitle = navigationTitle
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
