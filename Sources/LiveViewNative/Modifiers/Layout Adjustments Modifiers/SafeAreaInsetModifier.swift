//
//  SafeAreaInsetModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/6/2023.
//

import SwiftUI

/// Overlays content while shifting the safe area.
///
/// Use this modifier to overlay content on scrollable areas.
/// This will ensure the content it covers is never completely hidden.
///
/// Nested content is referenced by its namespace using the ``content`` argument.
///
/// ```html
/// <List modifiers={safe_area_inset(edge: :bottom, content: :bottom_bar)}>
///     ...
///     <GroupBox template={:bottom_bar} id="bottom_bar">
///         <HStack template={:label}>
///             <Text>Bottom Bar</Text>
///             <Spacer />
///         </HStack>
///         <Text>This will allow the list to scroll further up so no rows are covered.</Text>
///     </GroupBox>
/// </List>
/// ```
///
/// ## Arguments
/// * ``edge``
/// * ``alignment``
/// * ``spacing``
/// * ``content``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct SafeAreaInsetModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// The edge to position the safe area on.
    ///
    /// Possible values:
    /// * `leading`
    /// * `trailing`
    /// * `top`
    /// * `bottom`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let edge: AnyEdge
    
    enum AnyEdge {
        case horizontal(HorizontalEdge)
        case vertical(VerticalEdge)
    }

    /// The alignment of the inset.
    ///
    /// When the ``edge`` is `leading` or `trailing`, use a ``LiveViewNative/SwiftUI/VerticalAlignment``.
    ///
    /// When the ``edge`` is `top` or `bottom`, use a ``LiveViewNative/SwiftUI/HorizontalAlignment``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let alignment: Alignment

    /// Space between the underlying content and the inset.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let spacing: CGFloat?

    /// The name of the child element to place in the inset.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let content: String
    
    @ObservedElement private var element
    @LiveContext<R> private var context

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch try container.decode(String.self, forKey: .edge) {
        case "leading": self.edge = .horizontal(.leading)
        case "trailing": self.edge = .horizontal(.trailing)
        case "top": self.edge = .vertical(.top)
        case "bottom": self.edge = .vertical(.bottom)
        case let fallback: throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unknown edge '\(fallback)'"))
        }

        self.alignment = try container.decode(Alignment.self, forKey: .alignment)
        self.spacing = try container.decodeIfPresent(CGFloat.self, forKey: .spacing)
        self.content = try container.decode(String.self, forKey: .content)
    }

    func body(content: Content) -> some View {
        switch edge {
        case .horizontal(let horizontalEdge):
            content.safeAreaInset(
                edge: horizontalEdge,
                alignment: alignment.vertical,
                spacing: spacing
            ) {
                context.buildChildren(of: element, forTemplate: self.content)
            }
        case .vertical(let verticalEdge):
            content.safeAreaInset(
                edge: verticalEdge,
                alignment: alignment.horizontal,
                spacing: spacing
            ) {
                context.buildChildren(of: element, forTemplate: self.content)
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case edge
        case alignment
        case spacing
        case content
    }
}
