//
//  ErrorModifier.swift
// LiveViewNative
//
//  Created by Shadowfacts on 11/14/22.
//

import SwiftUI
import LiveViewNativeStylesheet

struct ErrorModifier: ViewModifier {
    let node: ASTNode
    
    init(_ node: ASTNode) {
        self.node = node
    }
    
    func body(content: Content) -> some View {
        content
            .overlay {
//                AnyErrorView<R>(error)
                Text("failed to decode \(node)")
                    .foregroundStyle(.red)
            }
    }
}
