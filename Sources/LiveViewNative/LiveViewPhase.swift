//
//  LiveViewPhase.swift
//
//
//  Created by Carson Katri on 2/6/24.
//

import SwiftUI

/// The current phase the ``LiveView`` interface is in.
public enum LiveViewPhase<R: RootRegistry> {
    /// The LiveView is connected to the server.
    case connected(_ConnectedContent<R>)
    /// The LiveView is in the process of connecting to the server.
    case connecting
    /// The LiveView lost connection with the server.
    case disconnected
    /// The LiveView lost connection with the server and is attempting to recover.
    case reconnecting(_ConnectedContent<R>)
    /// The LiveView encountered an unrecoverable error.
    case error(Error)
    
    public var isConnected: Bool {
        guard case .connected = self else { return false }
        return true
    }
}
