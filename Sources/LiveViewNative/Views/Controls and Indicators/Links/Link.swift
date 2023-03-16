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
///     Go to <Text font="body" font-weight="bold">LiveView Native</Text>
/// </Link>
/// ```
///
/// ## Attributes
/// * ``destination``
struct Link<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    let context: LiveContext<R>
    
    /// A valid URL to open when tapped.
    @Attribute("destination", transform: { $0?.value.flatMap(URL.init(string:)) }) private var destination: URL?
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        SwiftUI.Link(
            destination: destination!
        ) {
            context.buildChildren(of: element)
        }
    }
}
