//
//  LiveViewConfiguration.swift
// LiveViewNative
//
//  Created by Shadowfacts on 3/30/22.
//

import Foundation

/// An object that configures the behavior of a ``LiveViewCoordinator``.
public struct LiveViewConfiguration {
    /// Whether this coordinators allows its live view to navigate.
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
    
    // Non-final API for internal use only.
    @_spi(NarwinChat)
    public var eventHandlersEnabled: Bool = false
    
    @_spi(NarwinChat)
    public var liveRedirectsEnabled: Bool = false
    
    /// Constructs a default, empty configuration.
    public init() {
    }
    
    /// Possible modes for live view navigation.
    public enum NavigationMode {
        /// Navigation is entirely disabled. The live view will stay on the URL it was initially connected to.
        case disabled
        /// Only live redirects with `replace: true` are allowed.
        case replaceOnly
        /// Navigation is fully enabled. Both replace and push redirects are allowed.
        case enabled
    }
}
