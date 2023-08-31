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
///         rename_action(%{ event: "begin_rename", target: @myself })
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
    @Event private var action: Event.EventHandler

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._action = try container.decode(Event.self, forKey: .action)
    }

    private enum CodingKeys: String, CodingKey {
        case action
    }
    
    func body(content: Content) -> some View {
        content
            .renameAction {
                action(value: [String:String]())
            }
    }
}
