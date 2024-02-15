//
//  TabView.swift
//
//
//  Created by Carson Katri on 3/2/23.
//

import SwiftUI

/// Container that presents content on separate pages.
///
/// Each child element will become its own tab.
///
/// ```html
/// <TabView modifiers={tab_view_style(:page)}>
///     <Rectangle fillColor="system-red" />
///     <Rectangle fillColor="system-red" />
///     <Rectangle fillColor="system-red" />
/// </TabView>
/// ```
///
/// The icon shown in the index view can be configured with the ``TabItemModifier`` modifier.
///
/// ## Bindings
/// * ``selection``
@_documentation(visibility: public)
struct TabView<R: RootRegistry>: View {
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    /// Synchronizes the selected tab with the server.
    ///
    /// Use the ``TagModifier`` modifier to set the selection value for a given tab.
    @_documentation(visibility: public)
    @ChangeTracked(attribute: "selection") private var selection: String? = nil
    
    var body: some View {
        SwiftUI.TabView(selection: $selection) {
            context.buildChildren(of: element)
        }
    }
}
