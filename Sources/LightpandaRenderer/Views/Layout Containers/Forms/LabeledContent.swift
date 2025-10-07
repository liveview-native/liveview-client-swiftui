//
//  LabeledContent.swift
//  
//
//  Created by Carson.Katri on 2/23/23.
//

import SwiftUI
import LightpandaClient

/// Presents an element with an associated label.
///
/// Use the `content` and `label` children to create this element.
///
/// ```html
/// <LabeledContent>
///     <Text template="label">Price</Text>
///     <Text template="content">$100.00</Text>
/// </LabeledContent>
/// ```
///
/// ### Formatting Values
/// A value can be automatically formatted when the ``format`` attribute is used.
/// In this case, all child elements are used as the label, and the `value` attribute stores the content.
///
/// For more details on formatting options, see ``Text``.
///
/// ```html
/// <LabeledContent value={100} format="currency" currencyCode="usd">
///     Price
/// </LabeledContent>
/// ```
///
/// ## Attributes
/// * ``format``
///
/// ## Children
/// * `content` - The element to label.
/// * `label` - A description of the content.
///
/// ## See Also
/// ### Formatting Values
/// * ``Text``
@_documentation(visibility: public)
struct LabeledContent<Library: ElementLibrary>: View {
    let node: Node

    /// Automatically formats the value of the `value` attribute.
    ///
    /// For more details on formatting options, see ``Text``.
    @_documentation(visibility: public)
    private var format: String? {
        node.attributeValue(for: "format")
    }
    
    var body: some View {
        SwiftUI.Group {
            if format != nil {
                SwiftUI.LabeledContent {
                    TextView<Library>(node: node)
                } label: {
                    node.children(library: Library.self)
                }
            } else {
                SwiftUI.LabeledContent {
                    node.children(in: "content", default: true, library: Library.self)
                } label: {
                    node.children(in: "label", library: Library.self)
                }
            }
        }
    }
}
