//
//  TabView.swift
//
//
//  Created by Carson Katri on 3/2/23.
//

import SwiftUI

/// Container that presents content on separate pages.
///
/// - Note: To create a tab view that supports navigation, use the ``LiveSessionConfiguration/NavigationMode-swift.enum/tabView(tabs:)`` configuration option.
///
/// Each child element will become its own tab.
///
/// ```html
/// <TabView modifiers={tab_view_style(@native, style: :page)}>
///     <Rectangle fill-color="system-red" />
///     <Rectangle fill-color="system-red" />
///     <Rectangle fill-color="system-red" />
/// </TabView>
/// ```
///
/// The icon shown in the index view can be configured with the ``TabItemModifier`` modifier.
///
/// ## Bindings
/// * ``selection``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct TabView<R: RootRegistry>: View {
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    /// Synchronizes the selected tab with the server.
    ///
    /// Use the ``TagModifier`` modifier to set the selection value for a given tab.
    @LiveBinding(attribute: "selection") private var selection: String?
    
    var body: some View {
        if _selection.isBound {
            SwiftUI.TabView(selection: $selection) {
                context.buildChildren(of: element)
            }
        } else {
            SwiftUI.TabView {
                context.buildChildren(of: element)
            }
        }
    }
}
