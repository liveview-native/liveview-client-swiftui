//
//  LiveSessionState.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/23/23.
//

import Foundation

/// The live view connection state.
public enum LiveSessionState {
    /// The coordinator has not yet connected to the live view.
    case setup
    /// The coordinator is attempting to connect.
    case connecting
    /// The coordinator is attempting to reconnect.
    case reconnecting
    /// The coordinator has connected and the view tree can be rendered.
    case connected
    /// The coordinator is disconnected.
    case disconnected
    /// The coordinator failed to connect and produced the given error.
    case connectionFailed(Error)
    
    /// Either `setup` or `connecting`
    var isPending: Bool {
        switch self {
        case .setup,
             .disconnected,
             .connecting,
             .reconnecting:
            return true
        default:
            return false
        }
    }
    
    /// Is the enum in the `connected` state.
    var isConnected: Bool {
        if case .connected = self {
            return true
        } else {
            return false
        }
    }
    
    /// Is the enum in the `reconnecting` state.
    var isReconnecting: Bool {
        if case .reconnecting = self {
            return true
        } else {
            return false
        }
    }
}
