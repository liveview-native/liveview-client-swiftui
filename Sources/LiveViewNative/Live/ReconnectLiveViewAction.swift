//
//  ReconnectLiveViewAction.swift
//
//
//  Created by Carson.Katri on 4/16/24.
//

import SwiftUI

/// Calls ``LiveSessionCoordinator/reconnect(url:httpMethod:httpBody:)`` in the current context.
@MainActor
public struct ReconnectLiveViewAction {
    let baseURL: URL?
    let action: (_ url: URL?, _ httpMethod: String?, _ httpBody: Data?) async -> ()
    
    public func callAsFunction(_ style: ReconnectionStyle = .automatic) async {
        switch style {
        case .automatic:
            await action(nil, nil, nil)
        case .restart:
            await action(baseURL, nil, nil)
        }
    }
    
    public enum ReconnectionStyle {
        /// Preserve navigation state and reconnect on the current route
        case automatic
        /// Clear the navigation state and reconnect from the base path
        case restart
    }
}

extension EnvironmentValues {
    @MainActor
    private enum ReconnectLiveViewActionKey: @preconcurrency EnvironmentKey {
        static let defaultValue: ReconnectLiveViewAction = .init(baseURL: nil, action: { _, _, _ in })
    }
    
    /// An action that calls ``LiveSessionCoordinator/reconnect(url:httpMethod:httpBody:)`` in the current context.
    public var reconnectLiveView: ReconnectLiveViewAction {
        get { self[ReconnectLiveViewActionKey.self] }
        set { self[ReconnectLiveViewActionKey.self] = newValue }
    }
}
