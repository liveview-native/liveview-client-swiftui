//
//  RedactedModifier.swift
//  LiveViewNative
//
//  Created by murtza on 09/05/2023.
//

import SwiftUI

/// Adds a reason to apply a redaction to this view hierarchy.
///
/// ```html
/// <VStack modifiers={redacted(reason: :placeholder)}>
///   <Text>Title</Text>
///   <Text>Sub Title</Text>
/// </VStack>
/// ```
///
/// ## Arguments
/// * ``reason``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct RedactedModifier: ViewModifier, Decodable {
    /// The reasons to apply a redaction to data displayed on screen.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var reason: SwiftUI.RedactionReasons
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch try container.decode(String.self, forKey: .reason) {
        case "placeholder":
            reason = .placeholder
        case "privacy":
            reason = .privacy
        default:
            throw DecodingError.dataCorruptedError(forKey: .reason, in: container, debugDescription: "invalid value for reason")
        }
    }

    func body(content: Content) -> some View {
        content.redacted(reason: reason)
    }
    
    enum CodingKeys: String, CodingKey {
        case reason
    }
}
