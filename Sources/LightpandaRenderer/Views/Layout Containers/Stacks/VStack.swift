//
//  VStack.swift
//  LightpandaRenderer
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI
import LightpandaClient

/// Container that lays out its children in a vertical line.
///
/// ```html
/// <VStack alignment="leading">
///     <Text>Top</Text>
///     <Text>Bottom</Text>
/// </VStack>
/// ```
///
/// ## Attributes
/// - ``alignment``
/// - ``spacing``
@_documentation(visibility: public)
struct VStack<Library: ElementLibrary>: View {
    let node: Node

    /// The horizontal alignment of views within the stack. Defaults to center-aligned.
    ///
    /// See ``LiveViewNative/SwiftUI/HorizontalAlignment``
    @_documentation(visibility: public)
    private var alignment: HorizontalAlignment {
        node.attributeValue(for: "alignment", strategy: HorizontalAlignmentParseStrategy()) ?? .center
    }

    /// The spacing between views in the stack. If not provided, the stack uses the system spacing.
    @_documentation(visibility: public)
    private var spacing: CGFloat? {
        node.attributeValue(for: "spacing", strategy: .number).flatMap(CGFloat.init)
    }

    public var body: some View {
        SwiftUI.VStack(
            alignment: alignment,
            spacing: spacing
        ) {
            node.children(library: Library.self)
        }
    }
}
