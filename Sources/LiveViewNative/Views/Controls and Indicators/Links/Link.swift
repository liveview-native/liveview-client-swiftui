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
///     Go to <Text class="bold">LiveView Native</Text>
/// </Link>
/// ```
///
/// ## Attributes
/// * ``destination``
@_documentation(visibility: public)
@LiveElement
struct Link<Root: RootRegistry>: View {
    /// A valid URL to open when tapped.
    @_documentation(visibility: public)
    private var destination: String?
    
    public var body: some View {
        if let destination = destination.flatMap({ URL(string: $0, relativeTo: $liveElement.context.coordinator.url) })?.appending(path: "").absoluteURL {
            SwiftUI.Link(
                destination: destination
            ) {
                $liveElement.children()
            }
        } else {
            $liveElement.children()
                .task {
                    logger.error("Missing or invalid `destination` on `<Link>\($liveElement.element.innerText())</Link>`")
                }
        }
    }
}
