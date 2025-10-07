//
//  NavigationLink.swift
//  LightpandaRenderer
//
//  Created by Shadowfacts on 6/13/22.
//

import SwiftUI
import Combine
import OSLog
import LightpandaClient

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
/// Use the `data-phx-link` attribute to switch between `redirect` and `patch` modes.
///
/// ```html
/// <NavigationLink data-phx-link="patch" destination={"/?id={@product.id}"}>
///     <Text><%= @product.name %></Text>
/// </NavigationLink>
/// ```
///
/// Use the `data-phx-link-state` attribute to do a `replace` navigation instead of a `push`.
/// This will replace the current route with the destination.
///
/// ```html
/// <NavigationLink data-phx-link-state="replace" destination={"/products/#{@product.id}"}>
///     <Text>More Information</Text>
/// </NavigationLink>
/// ```
///
/// Provide a `destination` template View to customize the View used when transitioning between pages.
/// This is often used to set the navigation title before transitioning to reduce visual hitches.
/// If no destination template is provided, the app will use its global connecting phase view.
///
/// ```html
/// <NavigationLink destination={"/products/#{@product.id}"}>
///     <Text>More Information</Text>
///
///     <ProgressView
///         template="destination"
///         style='navigationTitle(attr("title"));'
///         title={@product.title}
///     />
/// </NavigationLink>
/// ```
///
/// ## Attributes
/// - ``destination``
/// - ``replace``
@_documentation(visibility: public)
@available(iOS 16.0, *)
struct NavigationLink<Library: ElementLibrary>: View {
    let node: Node
    
    /// The URL of the destination live view, relative to the current live view's URL.
    @_documentation(visibility: public)
    private var destination: String? {
        node.attributeValue(for: "destination")
    }
    
    @ViewBuilder
    public var body: some View {
        if let url = destination.flatMap({ URL(string: $0) })?.appending(path: "").absoluteURL {
            let pendingView: (some View)? = if node.hasTemplate("destination") {
                node.children(in: "destination", library: Library.self)
            } else {
                nil
            }
            switch link {
            case .redirect:
                switch linkState {
                case .replace:
                    SwiftUI.Button {
                        Task { @MainActor in
                            try await $liveElement.context.coordinator.session.redirect(
                                .init(
                                    kind: .replace,
                                    to: url,
                                    mode: .replaceTop
                                ),
                                navigationTransition: nil, // FIXME: navigationTransition
                                pendingView: pendingView
                            )
                        }
                    } label: {
                        node.children()
                    }
                case .push:
                    SwiftUI.NavigationLink(
                        value: LiveNavigationEntry(
                            url: url,
                            coordinator: LiveViewCoordinator(session: $liveElement.context.coordinator.session, url: url),
                            navigationTransition: nil, // FIXME: navigationTransition
                            pendingView: pendingView
                        )
                    ) {
                        node.children()
                    }
                }
            case .patch:
                SwiftUI.Button {
                    Task { @MainActor in
                        // send the `live_patch` event
                        try await $liveElement.context.coordinator.doPushEvent("live_patch", payload: .jsonPayload(json: .object(object: [
                            "url": .str(string: url.absoluteString)
                        ])))
                        // update the navigation path
                        let kind: LiveRedirect.Kind = switch linkState {
                        case .push:
                            .push
                        case .replace:
                            .replace
                        }
                        try await $liveElement.context.coordinator.session.redirect(
                            .init(
                                kind: kind,
                                to: url,
                                mode: .patch
                            ),
                            navigationTransition: nil, // FIXME: navigationTransition
                            pendingView: pendingView
                        )
                    }
                } label: {
                    node.children()
                }
            }
        } else {
            node.children()
                .task {
                    logger.error("Missing or invalid `destination` on `<NavigationLink>\($liveElement.element.innerText())</NavigationLink>`")
                }
        }
    }
}
