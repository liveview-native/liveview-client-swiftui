//
//  ErrorModifier.swift
// LiveViewNative
//
//  Created by Shadowfacts on 11/14/22.
//

import SwiftUI
import LiveViewNativeStylesheet
import OSLog

private let errorModifierLogger = Logger(subsystem: "LiveViewNative", category: "Stylesheet")

struct ErrorModifier: ViewModifier, Error {
    let node: ASTNode
    
    init(_ node: ASTNode) {
        self.node = node
    }
    
    func body(content: Content) -> some View {
        content
            .task {
                errorModifierLogger.warning("Using modifier \(node.debugDescription) that failed to decode\n\(node.annotations.debugDescription)")
            }
    }
}
