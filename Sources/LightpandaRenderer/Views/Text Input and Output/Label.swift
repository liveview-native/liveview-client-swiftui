//
//  Label.swift
//  
//
//  Created by Carson Katri on 1/31/23.
//

import SwiftUI
import LightpandaClient

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
struct Label<Library: ElementLibrary>: View {
    let node: Node

    /// A symbol to use for the `icon`.
    ///
    /// This attribute takes precedence over the `icon` child.
    ///
    /// This is equivalent to the `systemName` attribute on ``Image``.
    @_documentation(visibility: public)
    private var systemImage: String? {
        node.attributeValue(for: "systemImage")
    }
    
    public var body: some View {
        SwiftUI.Label {
            node.children(in: "title", default: true, library: Library.self)
        } icon: {
            if let systemImage {
                SwiftUI.Image(systemName: systemImage)
            } else {
                node.children(in: "icon", library: Library.self)
            }
        }
    }
}
