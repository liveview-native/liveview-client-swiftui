//
//  Link.swift
//  
//
//  Created by Carson Katri on 1/12/23.
//

import SwiftUI

/// Opens a URL when tapped.
///
/// Provide a ``destination`` and label content to create a ``Link``.
///
/// ```html
/// <Link destination="https://native.live">
///     Go to <Text modifiers={font_weight(:bold)}>LiveView Native</Text>
/// </Link>
/// ```
///
/// ## Attributes
/// * ``destination``
@_documentation(visibility: public)
struct Link<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// A valid URL to open when tapped.
    @_documentation(visibility: public)
    @Attribute("destination", transform: { $0?.value.flatMap(URL.init(string:)) }) private var destination: URL?
    
    public var body: some View {
        if let destination {
            SwiftUI.Link(
                destination: destination
            ) {
                context.buildChildren(of: element)
            }
        } else {
            context.buildChildren(of: element)
        }
    }
}
