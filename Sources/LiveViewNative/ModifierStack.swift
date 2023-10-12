//
//  ModifierStack.swift
//
//
//  Created by Carson Katri on 6/29/23.
//

import SwiftUI

/// A container that decodes a modifier stack.
///
/// Use this as a modifier:
///
/// ```swift
/// content
///     .modifier(modifierStack)
/// ```
public struct _ModifierStack<R: RootRegistry>: Decodable, ViewModifier {
    private let stack: [ModifierContainer<R>]
    
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.stack = []
        #warning("todo")
    }
    
    public func body(content: Content) -> some View {
        content
    }
}
