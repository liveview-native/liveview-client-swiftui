//
//  NavigationLink.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 6/13/22.
//

import SwiftUI
import Combine

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
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, *)
struct NavigationLink<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// The URL of the destination live view, relative to the current live view's URL.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("destination") private var destination: String
    /// Whether the link is disabled.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("disabled") private var disabled: Bool
    
    @ViewBuilder
    public var body: some View {
        SwiftUI.NavigationLink(
            value: LiveNavigationEntry(
                url: URL(string: destination, relativeTo: context.coordinator.url)!.appending(path: "").absoluteURL,
                coordinator: context.coordinator
            )
        ) {
            context.buildChildren(of: element)
        }
        .disabled(disabled)
    }
}
