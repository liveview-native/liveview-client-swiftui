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
struct NavigationLink<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// The URL of the destination live view, relative to the current live view's URL.
    @_documentation(visibility: public)
    @Attribute("destination") private var destination: String?
    /// Whether the link is disabled.
    @_documentation(visibility: public)
    @Attribute("disabled") private var disabled: Bool
    
    @Environment(\.navigationSplitViewContext) private var navigationSplitViewContext
    
    @ViewBuilder
    public var body: some View {
        if let url = destination.flatMap({ URL(string: $0, relativeTo: context.coordinator.url) })?.appending(path: "").absoluteURL {
            if navigationSplitViewContext {
                // split view requires opening a separate LiveView for each column
                SwiftUI.NavigationLink {
                    DetachedNavEntryView<R>(url: url)
                } label: {
                    context.buildChildren(of: element)
                }
                .disabled(disabled)
            } else {
                SwiftUI.NavigationLink(
                    value: LiveNavigationEntry(
                        url: url,
                        coordinator: LiveViewCoordinator(session: context.coordinator.session, url: url)
                    )
                ) {
                    context.buildChildren(of: element)
                }
                .disabled(disabled)
            }
        } else {
            context.buildChildren(of: element)
                .task {
                    logger.error("Missing or invalid `destination` on `<NavigationLink>\(element.innerText())</NavigationLink>`")
                }
        }
    }
}
