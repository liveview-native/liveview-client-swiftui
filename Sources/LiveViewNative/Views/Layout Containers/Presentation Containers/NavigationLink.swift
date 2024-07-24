//
//  NavigationLink.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 6/13/22.
//

import SwiftUI
import Combine
import OSLog

private let logger = Logger(subsystem: "LiveViewNative", category: "NavigationLink")

/// A control users can tap to navigate to another live view.
///
/// This only has an effect if the ``LiveSessionConfiguration`` was configured with navigation enabled.
///
/// ```html
/// <NavigationLink destination={"/products/#{@product.id}"}>
///     <Text>More Information</Text>
/// </NavigationLink>
/// ```
///
/// ## Attributes
/// - ``destination``
/// - ``disabled``
@_documentation(visibility: public)
@available(iOS 16.0, *)
@LiveElement
struct NavigationLink<Root: RootRegistry>: View {
    /// The URL of the destination live view, relative to the current live view's URL.
    @_documentation(visibility: public)
    private var destination: String?
    
    @LiveElementIgnored
    @Environment(\._anyNavigationTransition)
    private var anyNavigationTransition: Any?
    
    @ViewBuilder
    public var body: some View {
        if let url = destination.flatMap({ URL(string: $0, relativeTo: $liveElement.context.coordinator.url) })?.appending(path: "").absoluteURL {
            SwiftUI.NavigationLink(
                value: LiveNavigationEntry(
                    url: url,
                    coordinator: LiveViewCoordinator(session: $liveElement.context.coordinator.session, url: url),
                    navigationTransition: anyNavigationTransition
                )
            ) {
                $liveElement.children()
            }
        } else {
            $liveElement.children()
                .task {
                    logger.error("Missing or invalid `destination` on `<NavigationLink>\($liveElement.element.innerText())</NavigationLink>`")
                }
        }
    }
}
