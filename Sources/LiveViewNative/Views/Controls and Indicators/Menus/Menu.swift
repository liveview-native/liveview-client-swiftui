//
//  Menu.swift
//  
//
//  Created by Carson Katri on 1/19/23.
//
import SwiftUI

/// Tappable element that expands to reveal a list of options.
///
/// Provide the `content` and `label` children to create a menu.
///
///
/// ```html
/// <Menu>
///     <Text template={:label}>
///         Edit Actions
///     </Text>
///     <Group template={:content}>
///         <Button phx-click="arrange">Arrange</Button>
///         <Button phx-click="update">Update</Button>
///         <Button phx-click="remove">Remove</Button>
///     </Group>
/// </Menu>
/// ```
///
/// Menus can be nested by including another ``Menu`` in the `content`.
///
/// ## Children
/// * `label` - Describes the content of the menu.
/// * `content` - Elements displayed when expanded.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, tvOS 17.0, *)
struct Menu<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    public var body: some View {
        #if !os(watchOS)
        SwiftUI.Menu {
            context.buildChildren(of: element, forTemplate: "content", includeDefaultSlot: true)
        } label: {
            context.buildChildren(of: element, forTemplate: "label")
        }
        #endif
    }
}
