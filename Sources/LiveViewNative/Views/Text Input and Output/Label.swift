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
@LiveElement
struct Label<Root: RootRegistry>: View {
    /// A symbol to use for the `icon`.
    ///
    /// This attribute takes precedence over the `icon` child.
    ///
    /// This is equivalent to the `systemName` attribute on ``Image``.
    @_documentation(visibility: public)
    private var systemImage: String?
    
    public var body: some View {
        SwiftUI.Label {
            $liveElement.children(in: "title", default: true)
        } icon: {
            if let systemImage {
                SwiftUI.Image(systemName: systemImage)
            } else {
                $liveElement.children(in: "icon")
            }
        }
    }
}
