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
    case notConnected
    /// The coordinator is attempting to connect.
    case connecting
    /// The coordinator has connected and the view tree can be rendered.
    case connected
    // todo: disconnected state?
    /// The coordinator failed to connect and produced the given error.
    case connectionFailed(Error)
    
    /// Either `notConnected` or `connecting`
    var isPending: Bool {
        switch self {
        case .notConnected,
             .connecting:
            return true
        default:
            return false
        }
    }
}
