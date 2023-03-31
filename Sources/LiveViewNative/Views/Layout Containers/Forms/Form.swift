//
//  Form.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 1/18/23.
//

import SwiftUI

/// A container for grouping labeled form controls in a consistent style.
///
/// - Note: This element does not provide a form data model. See [LiveView Native Live Form](https://github.com/liveview-native/liveview-native-live-form).
///
/// ## Attributes
/// - ``style``
///
/// ## Topics
/// ### Supporting Types
/// - ``FormStyle``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct Form<R: RootRegistry>: View {
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    /// The style of the form.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("form-style") private var style: FormStyle = .automatic
    
    var body: some View {
        SwiftUI.Form {
            context.buildChildren(of: element)
        }
        .applyFormStyle(style)
    }
}

/// The visual style of a form.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
private enum FormStyle: String, AttributeDecodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic, columns, grouped
}

private extension View {
    @ViewBuilder
    func applyFormStyle(_ style: FormStyle) -> some View {
        switch style {
        case .automatic:
            self.formStyle(.automatic)
        case .columns:
            self.formStyle(.columns)
        case .grouped:
            self.formStyle(.grouped)
        }
    }
}
