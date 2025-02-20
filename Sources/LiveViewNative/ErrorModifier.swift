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

struct ErrorModifier: ViewModifier, LocalizedError {
    let node: ASTNode
    let error: any Error
    
    init(_ node: ASTNode, _ error: any Error) {
        self.node = node
        self.error = error
    }
    
    func body(content: Content) -> some View {
        content
            .task {
                errorModifierLogger.warning("""
                Using modifier \(node.debugDescription) that failed to decode
                \(node.annotations.debugDescription)
                \(error.localizedDescription)
                """)
            }
    }
    
    nonisolated var errorDescription: String? {
        """
        | \(node.debugDescription)
        \(node.annotations.debugDescription)
        \(error.localizedDescription)
        """
    }
}
