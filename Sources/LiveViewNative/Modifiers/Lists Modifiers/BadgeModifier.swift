//
//  BadgeModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/25/2023.
//

import SwiftUI

/// Display secondary information for an element.
/// 
/// Provide a string to the ``label`` argument to create a simple text badge.
///
/// ```html
/// <List>
///   <Text id="a" modifiers={badge("Active")}>
///     Server A
///   </Text>
///   ...
/// </List>
/// ```
/// 
/// Pass an integer to the ``count`` argument to create a numeric badge.
///
/// ```html
/// <List>
///   <Text id="a" modifiers={badge(3)}>
///     Server A
///   </Text>
///   ...
/// </List>
/// ```
/// 
/// Pass a template name to the ``content`` argument to create a badge from a styled ``Text`` element.
/// 
/// - Note: Only ``Text`` elements can be used as the content.
///
/// ```html
/// <List>
///   <Text id="a" modifiers={badge(content: :error)}>
///     Server A
///     <Text template={:error} modifiers={foreground_color(:red)}>
///       Down
///     </Text>
///   </Text>
///   ...
/// </List>
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, *)
struct BadgeModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// The name of a template element to use as the badge content.
    /// 
    /// - Note: Only ``Text`` elements can be used as the content.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let content: String?
    
    /// A string to use for the badge text.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let label: String?
    
    /// An integer to use for the badge content.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let count: Int?

    @ObservedElement private var element
    @LiveContext<R> private var context

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.label = try container.decodeIfPresent(String.self, forKey: .label)
        self.count = try container.decodeIfPresent(Int.self, forKey: .count)
    }

    func body(content: Content) -> some View {
        #if os(iOS) || os(macOS)
        if let reference = self.content {
            content
                .badge(context.children(of: element, forTemplate: reference).first?.asElement().flatMap(Text<R>.init(element:))?.body)
        } else if let label {
            content.badge(label)
        } else if let count {
            content.badge(count)
        } else {
            content
        }
        #else
        content
        #endif
    }

    enum CodingKeys: String, CodingKey {
        case content
        case label
        case count
    }
}

