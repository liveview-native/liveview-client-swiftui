//
//  ContextMenuModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 5/12/23.
//

import SwiftUI

/// Adds a context menu with actions and an optional preview. to the given view.
///
/// ```html
/// <Text modifiers={context_menu(menu_items: :items, preview: :preview)}>
///   My Menu
///
///   <Group template={:items}>
///     <Button>Action 1</Button>
///     <Button>Action 2</Button>
///   </Group>
///   <Rectangle template={:preview} fill-color="system-red" modifiers={frame(width: 100, height: 100)} />
/// </Text>
/// ```
///
/// ## Arguments
/// * ``menuItems``
/// * ``preview``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, tvOS 16.0, *)
struct ContextMenuModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// A reference to a set of ``Button`` views that are used as the context menu actions.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let menuItems: String
    
    /// A reference to an optional view to show as the context  menu preview.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let preview: String?
    
    @ObservedElement private var element
    @LiveContext<R> private var context
    @Environment(\.coordinatorEnvironment) private var coordinatorEnvironment
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.menuItems = try container.decode(String.self, forKey: .menuItems)
        self.preview = try container.decodeIfPresent(String.self, forKey: .preview)
    }
    
    func body(content: Content) -> some View {
        #if !os(watchOS)
        if let preview {
            content.contextMenu {
                context.buildChildren(of: element, forTemplate: menuItems)
            } preview: {
                context.buildChildren(of: element, forTemplate: preview)
                    .environment(\.coordinatorEnvironment, coordinatorEnvironment)
                    .environment(\.anyLiveContextStorage, context.storage)
            }
        } else {
            content.contextMenu {
                context.buildChildren(of: element, forTemplate: menuItems)
            }
        }
        #else
        content
        #endif
    }
    
    enum CodingKeys: String, CodingKey {
        case menuItems
        case preview
    }
}
