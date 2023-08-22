//
//  SubmitLabelModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/25/23.
//

import SwiftUI

/// Sets the submit label for this view.
///
/// ```html
/// <TextField modifiers={submit_label(:search)}>
///     Search for...
/// </TextField>
/// ```
///
/// ## Arguments
/// * ``submitLabel``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, tvOS 16.0, *)
struct SubmitLabelModifier: ViewModifier, Decodable {
    /// The label to display on the keyboard submit button.
    ///
    /// Possible values:
    /// * `done`
    /// * `go`
    /// * `send`
    /// * `join`
    /// * `route`
    /// * `search`
    /// * `return`
    /// * `next`
    /// * `continue`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let submitLabel: SubmitLabel
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch try container.decode(String.self, forKey: .submitLabel) {
        case "done":
            self.submitLabel = .done
        case "go":
            self.submitLabel = .go
        case "send":
            self.submitLabel = .send
        case "join":
            self.submitLabel = .join
        case "route":
            self.submitLabel = .route
        case "search":
            self.submitLabel = .search
        case "return":
            self.submitLabel = .`return`
        case "next":
            self.submitLabel = .next
        case "continue":
            self.submitLabel = .continue
        default:
            throw DecodingError.dataCorruptedError(forKey: .submitLabel, in: container, debugDescription: "invalid value for \(CodingKeys.submitLabel.rawValue)")
        }
    }
    
    func body(content: Content) -> some View {
        content.submitLabel(submitLabel)
    }
    
    enum CodingKeys: String, CodingKey {
        case submitLabel
    }
}
