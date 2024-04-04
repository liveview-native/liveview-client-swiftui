//
//  ScrollView.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

/// A view that lets it contents be scrolled if larger than the available space.
///
/// ```html
/// <ScrollView>
///     <VStack>
///         <%= for color <- @colors %>
///             <Rectangle id={color} fillColor={color} class="height:100" />
///         <% end %>
///     </VStack>
/// </ScrollView>
/// ```
///
/// ## Attributes
/// - ``axes``
/// - ``showsIndicators``
/// - ``scrollPosition``
/// - ``scrollPositionAnchor``
@_documentation(visibility: public)
@LiveElement
struct ScrollView<Root: RootRegistry>: View {
    /// Which axes this view is scrollable along (defaults to vertical).
    @_documentation(visibility: public)
    private var axes: Axis.Set = .vertical
    /// Whether the scroll indicators are shown (defaults to true).
    @_documentation(visibility: public)
    private var showsIndicators: Bool = true
    
    /// When the scroll view appears, and whenever this attribute changes, it will scroll to the view with the corresponding `id` attribute.
    ///
    /// The ``scrollPositionAnchor`` attribute governs where in the scroll view the target will be positioned.
    @_documentation(visibility: public)
    private var scrollPosition: String?
    /// Where in the scroll view the view that is being scrolled to is positioned.
    ///
    /// For example, specifying `top` will scroll the target to be at the top of the scroll view.
    ///
    /// See ``LiveViewNative/SwiftUI/UnitPoint`` for how values can be specified.
    @_documentation(visibility: public)
    private var scrollPositionAnchor: UnitPoint?
    
    public var body: some View {
        SwiftUI.ScrollViewReader { proxy in
            SwiftUI.ScrollView(
                axes,
                showsIndicators: showsIndicators
            ) {
                $liveElement.children()
            }
            .onAppear {
                guard let scrollPosition else { return }
                proxy.scrollTo(scrollPosition, anchor: scrollPositionAnchor)
            }
            .onChange(of: scrollPosition) { newValue in
                guard let newValue else { return }
                proxy.scrollTo(newValue, anchor: scrollPositionAnchor)
            }
        }
    }
}
