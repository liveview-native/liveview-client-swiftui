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
///     <Text template={:label}>Price</Text>
///     <Text template={:content}>$100.00</Text>
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
/// <LabeledContent value={100} format="currency" currency-code="usd">
///     Price
/// </LabeledContent>
/// ```
///
/// ## Attributes
/// * ``format``
/// * ``style``
///
/// ## Children
/// * `content` - The element to label.
/// * `label` - A description of the content.
///
/// ## See Also
/// ### Formatting Values
/// * ``Text``
///
/// ## Topics
/// ### Supporting Types
/// - ``LabeledContentStyle``
@_documentation(visibility: public)
struct LabeledContent<R: RootRegistry>: View {
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    /// Automatically formats the value of the `value` attribute.
    ///
    /// For more details on formatting options, see ``Text``.
    @_documentation(visibility: public)
    @Attribute("format") private var format: String?
    /// The style to use for this labeled content.
    @_documentation(visibility: public)
    @Attribute("labeled-content-style") private var style: LabeledContentStyle = .automatic
    
    var body: some View {
        SwiftUI.Group {
            if format != nil {
                SwiftUI.LabeledContent {
                    Text<R>()
                } label: {
                    context.buildChildren(of: element)
                }
            } else {
                SwiftUI.LabeledContent {
                    context.buildChildren(of: element, forTemplate: "content", includeDefaultSlot: true)
                } label: {
                    context.buildChildren(of: element, forTemplate: "label")
                }
            }
        }
        .applyLabeledContentStyle(style)
    }
}

@_documentation(visibility: public)
private enum LabeledContentStyle: String, AttributeDecodable {
    @_documentation(visibility: public)
    case automatic
}

private extension View {
    @ViewBuilder
    func applyLabeledContentStyle(_ style: LabeledContentStyle) -> some View {
        switch style {
        case .automatic: self.labeledContentStyle(.automatic)
        }
    }
}
