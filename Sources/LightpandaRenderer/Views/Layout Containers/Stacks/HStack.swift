//
//  HStack.swift
//  LightpandaRenderer
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI
import LightpandaClient

/// Container that lays out its children in a horizontal line.
///
/// ```html
/// <HStack>
///     <Text>Leading</Text>
///     <Spacer />
///     <Text>Trailing</Text>
/// </HStack>
/// ```
///
/// ## Attributes
/// - ``alignment``
/// - ``spacing``
@_documentation(visibility: public)
struct HStack<Library: ElementLibrary>: View {
    let node: Node

    /// The vertical alignment of views within the stack. Defaults to center-aligned.
    ///
    /// See ``LiveViewNative/SwiftUI/VerticalAlignment``.
    @_documentation(visibility: public)
    private var alignment: VerticalAlignment {
        node.attributeValue(for: "alignment", strategy: VerticalAlignmentParseStrategy()) ?? .center
    }
    
    /// The spacing between views in the stack. If not provided, the stack uses the system spacing.
    @_documentation(visibility: public)
    private var spacing: CGFloat? {
        node.attributeValue(for: "spacing", strategy: .number).flatMap(CGFloat.init)
    }
    
    public var body: some View {
        SwiftUI.HStack(
            alignment: alignment,
            spacing: spacing
        ) {
            node.children(library: Library.self)
        }
    }
}
