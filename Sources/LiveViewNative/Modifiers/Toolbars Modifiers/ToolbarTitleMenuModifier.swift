//
//  ToolbarTitleMenuModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 3/30/2023.
//

import SwiftUI

/// A menu that opens when the navigation title is tapped.
/// 
/// This is equivalent to using the ``ToolbarTitleMenu`` element in a ``ToolbarModifier`` modifier.
/// 
/// ```html
/// <Text
///     modifiers={toolbar_title_menu(content: :my_menu)}
/// >
///     ...
///     <Group template={:my_menu}>
///         <Button phx-click="duplicate">Duplicate</Button>
///         <Button phx-click="print">Print</Button>
///     </Group>
/// </Text>
/// ```
///
/// ## Arguments
/// * ``content``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ToolbarTitleMenuModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// The name of the element with the toolbar content.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let content: String

    @ObservedElement private var element
    @LiveContext<R> private var context
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.content = try container.decode(String.self, forKey: .content)
    }

    func body(content: Content) -> some View {
        content.toolbarTitleMenu {
            context.buildChildren(of: element, forTemplate: self.content)
        }
    }

    enum CodingKeys: String, CodingKey {
        case content
    }
}
