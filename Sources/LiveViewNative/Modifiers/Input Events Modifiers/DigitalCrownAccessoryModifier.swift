//
//  DigitalCrownAccessoryModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/26/23.
//

import SwiftUI

/// Places an accessory View next to the Digital Crown on Apple Watch.
///
/// Nested content is referenced by its namespace using the `content` argument.
///
/// ```html
/// <List modifiers={
///     digital_crown_accessory(content: :dca_view)
///     |> digital_crown_accessory_visibility(:visible)
/// }>
///     <Image template={:dca_view} system-name="heart.fill" />
/// </List>
/// ```
///
/// ## Arguments
/// * ``content``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(watchOS 9.0, *)
struct DigitalCrownAccessoryModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// A reference to the element that contains the accessory view.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let content: String

    @ObservedElement private var element
    @LiveContext<R> private var context
    @Environment(\.coordinatorEnvironment) private var coordinatorEnvironment

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.content = try container.decode(String.self, forKey: .content)
    }

    func body(content: Content) -> some View {
        content
            #if os(watchOS)
            .digitalCrownAccessory {
                context.buildChildren(of: element, forTemplate: self.content)
                    .environment(\.coordinatorEnvironment, coordinatorEnvironment)
                    .environment(\.anyLiveContextStorage, context.storage)
            }
            #endif
    }

    enum CodingKeys: CodingKey {
        case content
    }
}
