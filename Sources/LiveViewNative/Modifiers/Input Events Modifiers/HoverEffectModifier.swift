//
//  HoverEffectModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/26/23.
//

import SwiftUI

/// Applies a pointer hover effect to the view.
///
/// Note: The system may fall back to a more appropriate effect.
///
/// ```html
/// <Label modifiers={hover_effect(:lift)}>
///     Do you lift bro
/// </Label>
/// ```
///
/// ## Arguments
/// * ``effect``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, tvOS 16.0, *)
struct HoverEffectModifier: ViewModifier, Decodable {
    /// The effect applied when the pointer hovers over a view. Defaults to `automatic`.
    ///
    /// Possible values:
    /// * `automatic`
    /// * `highlight`
    /// * `lift`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let effect: HoverEffect
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        #if os(iOS) || os(tvOS)
        switch try container.decode(String.self, forKey: .effect) {
        case "automatic": self.effect = .automatic
        case "highlight": self.effect = .highlight
        case "lift": self.effect = .lift
        default:
            throw DecodingError.dataCorruptedError(forKey: .effect, in: container, debugDescription: "invalid value for \(CodingKeys.effect.rawValue)")
        }
        #else
        throw DecodingError.typeMismatch(Self.self, .init(codingPath: container.codingPath, debugDescription: "`hover_effect` modifier not available on this platform"))
        #endif
    }
    
    func body(content: Content) -> some View {
        content
            #if os(iOS) || os(tvOS)
            .hoverEffect(effect)
            #endif
    }
    
    enum CodingKeys: String, CodingKey {
        case effect
    }
}

extension HoverEffectModifier {
    #if os(macOS) || os(watchOS)
    typealias HoverEffect = Never
    #endif
}
