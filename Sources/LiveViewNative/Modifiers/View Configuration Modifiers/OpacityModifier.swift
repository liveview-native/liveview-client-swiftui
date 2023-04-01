//
//  OpacityModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 3/28/23.
//

import SwiftUI

/// Sets the opacity for any element.
///
/// ```html
/// <Text
///     modifiers={
///         opacity(@native, opacity: 0.5)
///     }
/// >Hello World!</Text>
/// ```
///
/// ## Arguments
/// * ``opacity``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct OpacityModifier: ViewModifier, Decodable, Equatable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let opacity: Double
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.opacity = try container.decode(Double.self, forKey: .opacity)
    }
    
    
    func body(content: Content) -> some View {
        content.opacity(opacity)
    }
    
    enum CodingKeys: String, CodingKey {
        case opacity
    }
}
