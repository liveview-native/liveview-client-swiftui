//
//  Label.swift
//  
//
//  Created by Carson Katri on 1/31/23.
//

import SwiftUI

/// A title and icon pair.
///
/// Use the `title` and `icon` children to create a label.
///
/// ```html
/// <Label>
///     <Label:title>
///         <Text>John Doe</Text>
///     </Label:title>
///     <Label:icon>
///         <Image system-name="person.crop.circle.fill" />
///     </Label:icon>
/// </Label>
/// ```
///
/// When using a symbol as the icon, use the ``systemImage`` attribute.
///
/// ```html
/// <Label system-image="person.crop.circle.fill">
///     <Text>John Doe</Text>
/// </Label>
/// ```
///
/// ## Attributes
/// * ``systemImage``
/// * ``style``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct Label<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// A symbol to use for the `icon`.
    ///
    /// This attribute takes precedence over the `icon` child.
    ///
    /// This is equivalent to the `system-name` attribute on ``Image``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("system-image") private var systemImage: String?
    /// The style to use for this label.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("label-style") private var style: LabelStyle = .automatic
    
    public var body: some View {
        SwiftUI.Label {
            context.buildChildren(of: element, withTagName: "title", namespace: "Label", includeDefaultSlot: true)
        } icon: {
            if let systemImage {
                SwiftUI.Image(systemName: systemImage)
            } else {
                context.buildChildren(of: element, withTagName: "icon", namespace: "Label")
            }
        }
        .applyLabelStyle(style)
    }
}

fileprivate enum LabelStyle: String, AttributeDecodable {
    case iconOnly = "icon-only"
    case titleOnly = "title-only"
    case titleAndIcon = "title-and-icon"
    case automatic = "automatic"
}

fileprivate extension View {
    @ViewBuilder
    func applyLabelStyle(_ style: LabelStyle) -> some View {
        switch style {
        case .iconOnly:
            self.labelStyle(.iconOnly)
        case .titleOnly:
            self.labelStyle(.titleOnly)
        case .titleAndIcon:
            self.labelStyle(.titleAndIcon)
        case .automatic:
            self.labelStyle(.automatic)
        }
    }
}
