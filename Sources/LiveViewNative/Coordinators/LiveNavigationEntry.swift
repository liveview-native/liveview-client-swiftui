//
//  LiveNavigationEntry.swift
//  
//
//  Created by Carson Katri on 1/10/23.
//

import Foundation

public struct LiveNavigationEntry<R: RootRegistry>: Hashable {
    public let url: URL
    public let coordinator: LiveViewCoordinator<R>
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.url == rhs.url && lhs.coordinator === rhs.coordinator
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        hasher.combine(ObjectIdentifier(coordinator))
    }
}
