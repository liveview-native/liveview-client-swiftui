//
//  LiveSessionConfiguration.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 3/30/22.
//

import SwiftUI

/// An object that configures the behavior of a ``LiveSessionCoordinator``.
public struct LiveSessionConfiguration {
    /// Whether this session allows its live view to navigate.
    ///
    /// By default, navigation is ``NavigationMode-swift.enum/disabled``.
    public var navigationMode: NavigationMode = .disabled
    /// A closure that is invoked by the coordinator to get the parameters that should be sent to the server when the live view connects.
    ///
    /// The closure receives the URL of the live view being connected to. If live navigation is performed, it will be invoked multiple times with different URLs.
    ///
    /// By default, no connection params are provided.
    public var connectParams: ((URL) -> [String: Any])? = nil
    
    /// The URL session the coordinator will use for performing HTTP and socket requests. By default, this is the shared session.
    public var urlSession: URLSession = .shared
    
    /// Constructs a default, empty configuration.
    public init() {
    }
    
    public init(
        navigationMode: NavigationMode = .disabled,
        connectParams: ((URL) -> [String: Any])? = nil,
        urlSession: URLSession = .shared
    ) {
        self.navigationMode = navigationMode
        self.connectParams = connectParams
        self.urlSession = urlSession
    }
    
    /// Possible modes for live view navigation.
    public enum NavigationMode {
        /// Navigation is entirely disabled. The live view will stay on the URL it was initially connected to.
        case disabled
        /// Only live redirects with `replace: true` are allowed.
        case replaceOnly
        /// Navigation is fully enabled. Both replace and push redirects are allowed.
        case enabled
        /// Navigation is fully enabled and uses a `NavigationSplitView` for the UI.
        case splitView
        /// Navigation is fully enabled and uses a `TabView` with the given tabs at the top level.
        ///
        /// Within each tab, navigation is fully enabled.
        case tabView(tabs: [Tab])
        
        /// A top level tab for use with the `.tabView` navigation mode.
        public struct Tab: Identifiable {
            let label: SwiftUI.Label<SwiftUI.Text, SwiftUI.Image>
            let url: URL
            
            public var id: URL { url }
            
            /// Create a tab with the given label and URL.
            public init(label: SwiftUI.Label<SwiftUI.Text, SwiftUI.Image>, url: URL) {
                self.label = label
                self.url = url
            }
        }
        
        var permitsRedirects: Bool {
            switch self {
            case .disabled:
                return false
            default:
                return true
            }
        }
    }
}
