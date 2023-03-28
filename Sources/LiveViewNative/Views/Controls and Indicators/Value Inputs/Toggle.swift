//
//  Toggle.swift
//
//
//  Created by Carson Katri on 1/17/23.
//

import SwiftUI

/// A form element that controls a boolean value.
///
/// Add elements within the toggle to provide a label.
///
/// ```html
/// <Toggle value-binding="is_on">
///     Lights On
/// </Toggle>
/// ```
///
/// > Booleans in Elixir are atoms, so bindings can be declared with
/// > ```elixir
/// > native_binding :is_on, Atom, false
/// > ```
///
/// ## Attributes
/// * ``style``
///
/// ## See Also
/// * [LiveView Native Live Form](https://github.com/liveview-native/liveview-native-live-form)
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct Toggle<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    @FormState(default: false) var value: Bool
    
    /// The style to apply to this toggle.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("toggle-style") private var style: ToggleStyle = .automatic
    
    public var body: some View {
        SwiftUI.Toggle(isOn: $value) {
            context.buildChildren(of: element)
        }
        .applyToggleStyle(style)
    }
}

#if swift(>=5.8)
@_documentation(visibility: public)
#endif
fileprivate enum ToggleStyle: String, AttributeDecodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case button
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case `switch`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(macOS 13.0, *)
    case checkbox
}

fileprivate extension View {
    @ViewBuilder
    func applyToggleStyle(_ style: ToggleStyle) -> some View {
        switch style {
        case .automatic:
            self.toggleStyle(.automatic)
        case .button:
            self.toggleStyle(.button)
        case .`switch`:
            self.toggleStyle(.switch)
        case .checkbox:
            #if os(macOS)
            self.toggleStyle(.checkbox)
            #endif
        }
    }
}
