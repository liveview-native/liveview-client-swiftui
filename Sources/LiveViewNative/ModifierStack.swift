//
//  ModifierStack.swift
//
//
//  Created by Carson Katri on 6/29/23.
//

import SwiftUI

/// A container that decodes a modifier stack.
///
/// Use ``apply(to:)`` to use the modifier stack on a View.
public struct _ModifierStack<R: RootRegistry>: Decodable {
    private let stack: [ModifierContainer<R>]
    
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.stack = try container.decode([ModifierContainer<R>].self)
    }
    
    public func apply(to content: some View) -> some View {
        content
            .applyModifiers(stack[...], element: element, context: context.storage)
    }
}
