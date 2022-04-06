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
public struct LiveView<R: CustomRegistry>: View {
    private let coordinator: LiveViewCoordinator<R>
    @State private var hasAppeared = false
    
    /// Creates a new LiveView attached to the given coordinator.
    ///
    /// - Note: Changing coordinators after the `LiveView` is setup and connected is forbidden.
    public init(coordinator: LiveViewCoordinator<R>) {
        self.coordinator = coordinator
    }

    public var body: some View {
        rootNavEntry
            .onAppear {
                if !hasAppeared {
                    hasAppeared = true
                    coordinator.connect()
                }
            }
    }
        
    @ViewBuilder
    private var rootNavEntry: some View {
        if case .enabled = coordinator.config.navigationMode {
            NavigationView {
                NavStackEntryView(coordinator: coordinator, url: coordinator.initialURL)
            }
        } else {
            NavStackEntryView(coordinator: coordinator, url: coordinator.initialURL)
        }
    }
    
}

