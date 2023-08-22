//
//  FixedSizeModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/13/2023.
//

import SwiftUI

/// Ensures the element only takes the space it needs.
///
/// Some elements, such as shapes, are flexible. This means they will take up all of the space given to them, filling the screen.
///
/// This modifier ensures an element does not extend beyond the size it needs to present its children.
///
/// ```html
/// <ZStack modifiers={fixed_size([])}>
///     <Rectangle fill-color="system-red" />
///     <Text>Hello, world!</Text>
/// </ZStack>
/// ```
///
/// With the modifier applied, the rectangle will only be as large as the text. If the modifier was removed, the rectangle would fill the screen.
///
/// By default, both axes are fixed. Pass ``horizontal`` and/or ``vertical`` to specify which axes should be fixed to their ideal size.
///
/// ```html
/// <ZStack modifiers={fixed_size(vertical: true)}>
///     <Rectangle fill-color="system-red" />
///     <Text>Hello, world!</Text>
/// </ZStack>
/// ```
///
/// Now the rectangle is the same size as the text vertically, but fills the screen horizontally.
///
/// ## Arguments
/// * ``horizontal``
/// * ``vertical``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct FixedSizeModifier: ViewModifier, Decodable {
    /// Whether the horizontal axis is fixed to the element's ideal size.
    ///
    /// If this argument and ``vertical`` are not passed, both are assumed to be `true`.
    /// Otherwise, it defaults to `false`.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let horizontal: Bool

    /// Whether the vertical axis is fixed to the element's ideal size.
    ///
    /// If this argument and ``horizontal`` are not passed, both are assumed to be `true`.
    /// Otherwise, it defaults to `false`.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let vertical: Bool

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let horizontal = try container.decodeIfPresent(Bool.self, forKey: .horizontal)
        let vertical = try container.decodeIfPresent(Bool.self, forKey: .vertical)
        if (horizontal, vertical) == (nil, nil) {
            self.horizontal = true
            self.vertical = true
        } else {
            self.horizontal = horizontal ?? false
            self.vertical = vertical ?? false
        }
    }

    func body(content: Content) -> some View {
        content.fixedSize(horizontal: horizontal, vertical: vertical)
    }

    enum CodingKeys: String, CodingKey {
        case horizontal
        case vertical
    }
}

