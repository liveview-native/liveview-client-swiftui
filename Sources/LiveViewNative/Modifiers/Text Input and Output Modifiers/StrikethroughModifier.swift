//
//  StrikethroughModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/6/2023.
//

import SwiftUI

/// Adds a line through ``Text``.
///
/// The line can be customized with the ``pattern`` and ``color`` arguments.
///
/// ```html
/// <Text modifiers={strikethrough(@native, color: :red, pattern: :dash_dot)}>
///     Hello, world!
/// </Text>
/// ```
///
/// ## Arguments
/// * [`is_active`](doc:StrikethroughModifier/isActive)
/// * ``pattern``
/// * ``color``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct StrikethroughModifier: ViewModifier, Decodable {
    /// `is_active`, enables/disables the effect.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let isActive: Bool

    /// The pattern to use for the line. Defaults to `solid`.
    ///
    /// Possible values:
    /// * `dash`
    /// * `dash_dot`
    /// * `dash_dot_dot`
    /// * `dot`
    /// * `solid`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let pattern: SwiftUI.Text.LineStyle.Pattern

    /// The color of the line. Defaults to `nil`.
    ///
    /// See ``LiveViewNative/SwiftUI/Color`` for details on creating colors.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let color: SwiftUI.Color?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.isActive = try container.decode(Bool.self, forKey: .isActive)
        switch try container.decode(String.self, forKey: .pattern) {
        case "dash": self.pattern = .dash
        case "dash_dot": self.pattern = .dashDot
        case "dash_dot_dot": self.pattern = .dashDotDot
        case "dot": self.pattern = .dot
        case "solid": self.pattern = .solid
        case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "unknown pattern '\(`default`)'"))
        }

        self.color = try container.decodeIfPresent(SwiftUI.Color.self, forKey: .color)
    }

    func body(content: Content) -> some View {
        content.strikethrough(isActive, pattern: pattern, color: color)
    }

    enum CodingKeys: String, CodingKey {
        case isActive = "is_active"
        case pattern
        case color
    }
}
