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
/// Use the `phx-replace` attribute to do a replace navigation instead of a push.
/// This will replace the current route with the destination.
///
/// ```html
/// <NavigationLink phx-replace destination={"/products/#{@product.id}"}>
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
@LiveElement
struct NavigationLink<Root: RootRegistry>: View {
    /// The URL of the destination live view, relative to the current live view's URL.
    @_documentation(visibility: public)
    private var destination: String?
    
    @LiveAttribute("phx-replace")
    private var replace: Bool = false
    
    @LiveElementIgnored
    @Environment(\._anyNavigationTransition)
    private var anyNavigationTransition: Any?
    
    @LiveElementIgnored
    @Environment(\.anyLiveContextStorage)
    private var anyLiveContextStorage: Any?
    
    @LiveElementIgnored
    @Environment(\.coordinatorEnvironment)
    private var coordinatorEnvironment: CoordinatorEnvironment?
    
    @ViewBuilder
    public var body: some View {
        if let url = destination.flatMap({ URL(string: $0, relativeTo: $liveElement.context.coordinator.url) })?.appending(path: "").absoluteURL {
            let pendingView: (some View)? = if $liveElement.hasTemplate("destination") {
                $liveElement.children(in: "destination")
                    .environment(\.anyLiveContextStorage, anyLiveContextStorage)
                    .environment(\.coordinatorEnvironment, coordinatorEnvironment)
            } else {
                nil
            }
            if replace {
                SwiftUI.Button {
                    Task { @MainActor in
                        try await $liveElement.context.coordinator.session.redirect(
                            .init(
                                kind: .replace,
                                to: url,
                                mode: .replaceTop
                            ),
                            navigationTransition: anyNavigationTransition,
                            pendingView: pendingView
                        )
                    }
                } label: {
                    $liveElement.children()
                }
            } else {
                SwiftUI.NavigationLink(
                    value: LiveNavigationEntry(
                        url: url,
                        coordinator: LiveViewCoordinator(session: $liveElement.context.coordinator.session, url: url),
                        navigationTransition: anyNavigationTransition,
                        pendingView: pendingView
                    )
                ) {
                    $liveElement.children()
                }
            }
        } else {
            $liveElement.children()
                .task {
                    logger.error("Missing or invalid `destination` on `<NavigationLink>\($liveElement.element.innerText())</NavigationLink>`")
                }
        }
    }
}
