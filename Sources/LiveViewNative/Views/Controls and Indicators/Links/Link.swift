//
//  Link.swift
//  
//
//  Created by Carson Katri on 1/12/23.
//

import SwiftUI
import OSLog

private let logger = Logger(subsystem: "LiveViewNative", category: "Link")

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
    @Attribute("destination") private var destination: String?
    
    public var body: some View {
        if let destination = destination.flatMap({ URL(string: $0, relativeTo: context.coordinator.url) })?.appending(path: "").absoluteURL {
            SwiftUI.Link(
                destination: destination
            ) {
                context.buildChildren(of: element)
            }
        } else {
            context.buildChildren(of: element)
                .task {
                    logger.error("Missing or invalid `destination` on `<Link>\(element.innerText())</Link>`")
                }
        }
    }
}
