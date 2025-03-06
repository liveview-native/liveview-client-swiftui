//
//  LiveNavigationEntry.swift
//  
//
//  Created by Carson Katri on 1/10/23.
//

import Foundation
import SwiftUI

public struct LiveNavigationEntry<R: RootRegistry>: Hashable {
    public let url: URL
    public let coordinator: LiveViewCoordinator<R>
    
    let mode: LiveRedirect.Mode
    
    let navigationTransition: Any?
    let pendingView: (any View)?
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.url == rhs.url && lhs.coordinator === rhs.coordinator
        && lhs.mode == rhs.mode
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        hasher.combine(ObjectIdentifier(coordinator))
        hasher.combine(mode)
    }
}
