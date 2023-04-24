//
//  ForegroundColorModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 4/24/23.
//

import SwiftUI

/// Applies a foreground color to a view.
/// ```html
/// <Text modifiers={foreground_color(@native, color: :mint)}>
///   Minty fresh text.
/// </Text>
/// ```
///
/// ## Arguments
/// * ``color``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ForegroundColorModifier: ViewModifier, Decodable {
    /// The foreground color to use when rendering the view.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var color: SwiftUI.Color

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.color = try container.decode(SwiftUI.Color.self, forKey: .color)
    }

    func body(content: Content) -> some View {
        content.foregroundColor(color)
    }

    enum CodingKeys: String, CodingKey {
        case color
    }
}
