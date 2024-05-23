//
//  LabeledContent.swift
//  
//
//  Created by Carson.Katri on 2/23/23.
//

import SwiftUI

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
@LiveElement
struct LabeledContent<Root: RootRegistry>: View {
    /// Automatically formats the value of the `value` attribute.
    ///
    /// For more details on formatting options, see ``Text``.
    @_documentation(visibility: public)
    private var format: String?
    
    var body: some View {
        SwiftUI.Group {
            if format != nil {
                SwiftUI.LabeledContent {
                    Text<Root>()
                } label: {
                    $liveElement.children()
                }
            } else {
                SwiftUI.LabeledContent {
                    $liveElement.children(in: "content", default: true)
                } label: {
                    $liveElement.children(in: "label")
                }
            }
        }
    }
}
