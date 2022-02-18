//
//  LiveView.swift
//  LiveViewTest
//
//  Created by Brian Cardarella on 4/28/21.
//

import Foundation
import SwiftUI

/// The SwiftUI root view for a Phoenix LiveView.
///
/// By default, a `LiveView` attempts to connect immediately when it appears. While in states other than ``LiveViewCoordinator/State-swift.enum/connected``, this view only provides a basic text description of the state.
///
/// If you wish to customize this behavior, wrap the `LiveView` in your own view which tells the coordinator to connect and presents the `LiveView` when appropriate. For example:
///
/// ```swift
/// struct MyView: View {
///     @StateObject var coordinator = LiveViewCoordinator(url: URL(string: "http://localhost:4000")!)
///     var body: some View {
///         switch coordinator.state {
///         case .notConnected, .connecting:
///             ProgressView("Connecting...")
///                 .onAppear { coordinator.connect() }
///         case .connected:
///             LiveView(coordinator: coordinator)
///         case .connectionFailed(let error):
///             Text("Error")
///         }
///     }
/// }
/// ```
///
public struct LiveView<R: CustomRegistry>: View {
    // this is a @StateObject instead of @ObservedObject because changing which DOMWindows for a LiveView is not allowed
    @StateObject private var coordinator: LiveViewCoordinator<R>
    @StateObject private var liveViewModel = LiveViewModel<R>()
    
    /// Creates a new LiveView attached to the given coordinator.
    ///
    /// - Note: Changing coordinators after the `LiveView` is setup and connected is forbidden.
    public init(coordinator: LiveViewCoordinator<R>) {
        self._coordinator = StateObject(wrappedValue: coordinator)
    }

    public var body: some View {
        switch self.coordinator.state {
        case .notConnected:
            Text("Not Connected")
                .onAppear {
                    coordinator.connect()
                }
            
        case .connecting:
            Text("Connecting")
            
        case .connected:
            self.coordinator.viewTree()
                .environmentObject(liveViewModel)
                .onChange(of: coordinator.elements) { newValue in
                    // todo: doing this every time the DOM changes is not efficient
                    liveViewModel.pruneMissingForms(elements: newValue)
                }
            
        case .connectionFailed(let error):
            VStack {
                Text("Connection Failed")
                    .font(.subheadline)
                Text(error.localizedDescription)
            }
        }
    }
}

