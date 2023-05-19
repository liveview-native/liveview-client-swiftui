//
//  RenameActionModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 3/3/23.
//

import SwiftUI

/// Sets the event for a <doc:RenameButton>.
///
/// Apply this modifier to a <doc:RenameButton> or any element above it to set the event to perform.
///
/// ```html
/// <RenameButton
///     modifiers={
///         rename_action(@native, event: "begin_rename", target: @myself)
///     }
/// />
/// ```
///
/// ## Arguments
/// * ``event``
/// * ``target``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct RenameActionModifier: ViewModifier, Decodable {
    /// The name of the event.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let event: String
    /// The LiveView or LiveComponent to perform the event on.
    ///
    /// In a component, you may use the `@myself` assign to handle the event on the LiveComponent.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let target: Int?
    @Environment(\.coordinatorEnvironment) private var coordinatorEnvironment

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.event = try container.decode(String.self, forKey: .event)
        self.target = try container.decode(Int?.self, forKey: .target)
    }

    private enum CodingKeys: String, CodingKey {
        case event
        case target
    }
    
    func body(content: Content) -> some View {
        content
            .renameAction {
                Task {
                    try await coordinatorEnvironment?.pushEvent("click", event, nil, target)
                }
            }
    }
}
