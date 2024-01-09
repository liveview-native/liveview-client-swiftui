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
@_documentation(visibility: public)
struct Form<R: RootRegistry>: View {
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    /// The style of the form.
    @_documentation(visibility: public)
    @Attribute("form-style") private var style: FormStyle = .automatic
    
    var body: some View {
        SwiftUI.Form {
            context.buildChildren(of: element)
        }
        .applyFormStyle(style)
    }
}

/// The visual style of a form.
@_documentation(visibility: public)
private enum FormStyle: String, AttributeDecodable {
    @_documentation(visibility: public)
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
