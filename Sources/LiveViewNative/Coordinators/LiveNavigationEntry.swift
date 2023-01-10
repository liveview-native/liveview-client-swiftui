//
//  LiveNavigationEntry.swift
//  
//
//  Created by Carson Katri on 1/10/23.
//

import Foundation

struct LiveNavigationEntry<R: CustomRegistry>: Hashable {
    let url: URL
    let coordinator: LiveViewCoordinator<R>
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.url == rhs.url && lhs.coordinator === rhs.coordinator
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        hasher.combine(ObjectIdentifier(coordinator))
    }
}
