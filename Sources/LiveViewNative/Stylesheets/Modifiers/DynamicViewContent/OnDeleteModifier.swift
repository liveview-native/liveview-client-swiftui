//
//  OnDeleteModifier.swift
//
//
//  Created by Carson Katri on 10/2/24.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.DynamicViewContent/onDelete(perform:)`](https://developer.apple.com/documentation/swiftui/dynamicviewcontent/onDelete(perform:)) for more details on this ViewModifier.
///
/// ### onDelete(perform:)
/// - `action`: ``SwiftUI/Image/TemplateRenderingMode`` or `nil` (required)
///
/// See [`SwiftUI.DynamicViewContent/onDelete(perform:)`](https://developer.apple.com/documentation/swiftui/dynamicviewcontent/onDelete(perform:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```html
/// <List style='onDelete(perform: event("delete"))'>
///   ...
/// </List>
/// ```
@_documentation(visibility: public)
@ParseableExpression
struct _OnDeleteModifier: ViewModifier {
    static let name = "onDelete"
    
    @ObservedElement private var element
    @Event private var action: Event.EventHandler
    
    init(perform action: Event) {
        self._action = action
    }
    
    func body(content: Content) -> some View {
        content.environment(\.onDeleteAction, { indices in
            var meta = element.buildPhxValuePayload()
            meta["index_set"] = Array(indices)
            action(value: meta) {}
        })
    }
}

extension EnvironmentValues {
    private enum OnDeleteActionKey: EnvironmentKey {
        static let defaultValue: ((IndexSet) -> ())? = nil
    }
    
    var onDeleteAction: ((IndexSet) -> ())? {
        get { self[OnDeleteActionKey.self] }
        set { self[OnDeleteActionKey.self] = newValue }
    }
}
