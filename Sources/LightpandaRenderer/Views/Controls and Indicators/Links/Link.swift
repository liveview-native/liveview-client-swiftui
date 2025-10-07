//
//  Link.swift
//  
//
//  Created by Carson Katri on 1/12/23.
//

import SwiftUI
import OSLog
import LightpandaClient

private let logger = Logger(subsystem: "LiveViewNative", category: "Link")

/// Opens a URL when tapped.
///
/// Provide a ``destination`` and label content to create a ``Link``.
///
/// ```html
/// <Link destination="https://native.live">
///     Go to <Text class="bold">LiveView Native</Text>
/// </Link>
/// ```
///
/// ## Attributes
/// * ``destination``
@_documentation(visibility: public)
struct Link<Library: ElementLibrary>: View {
    let node: Node
    
    /// A valid URL to open when tapped.
    @_documentation(visibility: public)
    private var destination: String? {
        node.attributeValue(for: "destination")
    }
    
    public var body: some View {
        if let destination = destination.flatMap({ URL(string: $0) })?.appending(path: "").absoluteURL {
            SwiftUI.Link(
                destination: destination
            ) {
                node.children(library: Library.self)
            }
        } else {
            node.children(library: Library.self)
                .task {
                    logger.error("Missing or invalid `destination` on `<Link>`")
                }
        }
    }
}
