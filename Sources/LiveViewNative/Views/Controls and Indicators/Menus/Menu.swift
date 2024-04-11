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
@_documentation(visibility: public)
@available(iOS 16.0, macOS 13.0, tvOS 17.0, *)
@LiveElement
struct Menu<Root: RootRegistry>: View {
    public var body: some View {
        #if !os(watchOS) && (!os(tvOS) || swift(>=5.9))
        SwiftUI.Menu {
            $liveElement.children(in: "content", default: true)
        } label: {
            $liveElement.children(in: "label")
        }
        #endif
    }
}
