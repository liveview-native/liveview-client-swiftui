//
//  DigitalCrownAccessoryVisibilityModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/26/23.
//

import SwiftUI

/// Specifies the visibility of Digital Crown accessory Views on Apple Watch.
///
/// Use this method to customize the visibility of a Digital Crown accessory View created with the ``digital_crown_accessory`` modifier.
///
/// ```html
/// <List modifiers={@native |> digital_crown_accessory(content: :dca_view)}>
///     ...
///     <digital_crown_accessory:dca_view>
///         <Image system-name="heart.fill" modifiers={@native |> digital_crown_accessory_visibility(visibility: :visible)} />
///     </digital_crown_accessory:dca_view>
/// </List>
/// ```
///
/// ## Arguments
/// * ``visibility``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(watchOS 9.0, *)
struct DigitalCrownAccessoryVisibilityModifier: ViewModifier, Decodable {
    /// The visibility of the digital crown accessory.
    ///
    /// Possible values:
    /// * `automatic`
    /// * `visible`
    /// * `hidden`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let visibility: Visibility
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        #if os(watchOS)
        switch try container.decode(String.self, forKey: .visibility) {
        case "automatic": self.visibility = .automatic
        case "visible": self.visibility = .visible
        case "hidden": self.visibility = .hidden
        default:
            throw DecodingError.dataCorruptedError(forKey: .visibility, in: container, debugDescription: "invalid value for \(CodingKeys.visibility.rawValue)")
        }
        #else
        fatalError()
        #endif
    }
    
    func body(content: Content) -> some View {
        content
            #if os(watchOS)
            .digitalCrownAccessory(visibility)
            #endif
    }
    
    enum CodingKeys: String, CodingKey {
        case visibility
    }
}
