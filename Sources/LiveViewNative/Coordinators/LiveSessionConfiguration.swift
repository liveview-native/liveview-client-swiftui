//
//  LiveSessionConfiguration.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 3/30/22.
//

import SwiftUI

/// An object that configures the behavior of a ``LiveSessionCoordinator``.
public struct LiveSessionConfiguration {
    /// A closure that is invoked by the coordinator to get the parameters that should be sent to the server when the live view connects.
    ///
    /// The closure receives the URL of the live view being connected to. If live navigation is performed, it will be invoked multiple times with different URLs.
    ///
    /// By default, no connection params are provided.
    public var connectParams: ((URL) -> [String: Any])? = nil
  
    /// Optional headers that are sent when fetching the dead render.
    ///
    /// By default, no addtional headers are provided.
    public var headers: [String: String] = [:]
    
    /// The URL session configuration the coordinator will use for performing HTTP and socket requests.
    /// 
    /// By default, this is the `default` configuration.
    /// 
    /// Some properties of the configuration (such as the `httpCookieStorage`) will be overridden by the session coordinator.
    public var urlSessionConfiguration: URLSessionConfiguration = .default
    
    /// The transition used when the live view changes connects.
    public var transition: AnyTransition?
    
    public var reconnectBehavior: ReconnectBehavior = .exponential
    
    /// Constructs a default, empty configuration.
    public init() {
    }
    
    public init(
        connectParams: ((URL) -> [String: Any])? = nil,
        headers: [String: String] = [:],
        urlSessionConfiguration: URLSessionConfiguration = .default,
        transition: AnyTransition? = nil,
        reconnectBehavior: ReconnectBehavior = .exponential
    ) {
        self.headers = headers
        self.connectParams = connectParams
        self.urlSessionConfiguration = urlSessionConfiguration
        self.transition = transition
        self.reconnectBehavior = reconnectBehavior
    }
    
    public struct ReconnectBehavior {
        let delay: ((_ tries: Int) -> TimeInterval)?
        
        public init(_ delay: @escaping (_ tries: Int) -> TimeInterval) {
            self.delay = delay
        }
        
        private init() {
            self.delay = nil
        }
        
        /// Attempt to reconnect at an exponential rate.
        public static func exponential(
            upTo maxDelay: TimeInterval = 32,
            step: TimeInterval = 1,
            jitter: ClosedRange<TimeInterval> = 0...0.25
        ) -> Self {
            .init { attempt in
                let delay = pow(2, Double(attempt)) * step
                let jitter = TimeInterval.random(in: jitter)
                return min(delay, maxDelay) + jitter
            }
        }
        
        /// Attempt to reconnect at an exponential rate.
        public static let exponential: Self = .exponential()
        
        /// Attempt to reconnect at a constant rate.
        public static func constant(
            _ delay: TimeInterval = 3,
            jitter: ClosedRange<TimeInterval> = 0...0.25
        ) -> Self {
            .init { _ in
                delay + TimeInterval.random(in: jitter)
            }
        }
        
        /// Attempt to reconnect at a constant rate.
        public static let constant: Self = .constant()
        
        /// Never automatically reconnect.
        public static let never: Self = .init()
    }
}
