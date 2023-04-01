//
//  DisabledModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 3/29/23.
//

import SwiftUI

/// Disables interaction for any element.
///
/// ```html
/// <Button
///     modifiers={
///         disabled(@native, disabled: true)
///     }
/// >
///  <Label>This button is disabled</Label>
/// </Button>
/// ```
///
/// ## Arguments
/// * ``disabled``
struct DisabledModifier: ViewModifier, Decodable, Equatable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let disabled: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.disabled = try container.decode(Bool.self, forKey: .disabled)
    }
    
    
    func body(content: Content) -> some View {
        content.disabled(disabled!)
    }
    
    enum CodingKeys: String, CodingKey {
        case disabled
    }
}
