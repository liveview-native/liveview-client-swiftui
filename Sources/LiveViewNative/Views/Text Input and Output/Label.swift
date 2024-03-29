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
///     <Text template={:title}>John Doe</Text>
///     <Image template={:icon} systemName="person.crop.circle.fill" />
/// </Label>
/// ```
///
/// When using a symbol as the icon, use the ``systemImage`` attribute.
///
/// ```html
/// <Label systemImage="person.crop.circle.fill">
///     <Text>John Doe</Text>
/// </Label>
/// ```
///
/// ## Attributes
/// * ``systemImage``
@_documentation(visibility: public)
struct Label<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// A symbol to use for the `icon`.
    ///
    /// This attribute takes precedence over the `icon` child.
    ///
    /// This is equivalent to the `systemName` attribute on ``Image``.
    @_documentation(visibility: public)
    @Attribute("systemImage") private var systemImage: String?
    
    public var body: some View {
        SwiftUI.Label {
            context.buildChildren(of: element, forTemplate: "title", includeDefaultSlot: true)
        } icon: {
            if let systemImage {
                SwiftUI.Image(systemName: systemImage)
            } else {
                context.buildChildren(of: element, forTemplate: "icon")
            }
        }
    }
}
