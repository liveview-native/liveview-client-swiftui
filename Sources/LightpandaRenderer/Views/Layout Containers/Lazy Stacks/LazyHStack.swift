//
//  LazyVStack.swift
//
//
//  Created by Carson Katri on 2/9/23.
//

import SwiftUI
import LightpandaClient

/// Horizontal stack that creates Views lazily.
///
/// Lazy stacks behave similar to their non-lazy counterparts.
///
/// Use the ``pinnedViews`` attribute to pin section headers/footers when contained in a `ScrollView`.
///
/// ```html
/// <ScrollView axes="horizontal">
///     <LazyHStack>
///         <%= for i <- 1..50 do %>
///             <Text id={i |> Integer.to_string} font="largeTitle"><%= i %></Text>
///         <% end %>
///     </LazyHStack>
/// </ScrollView>
/// ```
///
/// ## Attributes
/// * ``alignment``
/// * ``spacing``
/// * ``pinnedViews``
///
/// ## See Also
/// ### Stacks
/// * ``HStack``
@_documentation(visibility: public)
struct LazyHStack<Library: ElementLibrary>: View {
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
    /// Pins section headers/footers.
    ///
    /// See ``LiveViewNative/SwiftUI/PinnedScrollableViews``.
    @_documentation(visibility: public)
    private var pinnedViews: PinnedScrollableViews {
        node.attributeValue(for: "pinnedViews", strategy: PinnedScrollableViewsParseStrategy()) ?? []
    }
    
    public var body: some View {
        SwiftUI.LazyHStack(
            alignment: alignment,
            spacing: spacing,
            pinnedViews: pinnedViews
        ) {
            node.children(library: Library.self)
        }
    }
}

struct VerticalAlignmentParseStrategy: ParseStrategy {
    func parse(_ value: String) throws -> VerticalAlignment {
        switch value {
        case "bottom":
            return .bottom
        case "center":
            return .center
        case "top":
            return .top
        case "firstTextBaseline":
            return .firstTextBaseline
        case "lastTextBaseline":
            return .lastTextBaseline
        default:
            throw ParseError()
        }
    }
}


struct PinnedScrollableViewsParseStrategy: ParseStrategy {
    func parse(_ value: String) throws -> PinnedScrollableViews {
        switch value {
        case "sectionFooters":
            return .sectionFooters
        case "sectionHeaders":
            return .sectionHeaders
        case "all":
            return [.sectionFooters, .sectionHeaders]
        default:
            throw ParseError()
        }
    }
}
