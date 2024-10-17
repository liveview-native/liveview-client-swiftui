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
    
    private var id: String?
    
    public var body: some View {
        SwiftUI.ScrollViewReader { proxy in
            SwiftUI.ScrollView(
                axes,
                showsIndicators: showsIndicators
            ) {
                $liveElement.children()
            }
            .scrollRestoration(Root.self, id: id)
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

/// A modifier that tracks the scroll position and restores it on back navigation.
///
/// The scroll position is stored in the ``LiveSessionCoordinator``.
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, *)
struct ScrollRestorationModifier<R: RootRegistry>: ViewModifier {
    let id: String
    
    @LiveContext<R> private var context
    
    @State private var position = ScrollPosition()
    @State private var didAttemptRestoration = false
    
    func body(content: Content) -> some View {
        content
            .onScrollGeometryChange(for: CGPoint.self, of: { geometry in
                CGPoint(
                    x: geometry.contentOffset.x + geometry.contentInsets.leading,
                    y: geometry.contentOffset.y + geometry.contentInsets.top
                )
            }, action: { _, newValue in
                guard didAttemptRestoration else { return }
                // update the stored scrollPosition in the ``LiveSessionCoordinator``
                context.coordinator.session.scrollPositions[context.coordinator.session.navigationPath.count, default: [:]][id] = .offset(newValue)
            })
            .scrollPosition($position)
            .task {
                // restore the scroll position from the ``LiveSessionCoordinator``
                defer { didAttemptRestoration = true }
                guard case let .offset(restoredValue) = context.coordinator.session.scrollPositions[context.coordinator.session.navigationPath.count, default: [:]][id]
                else { return }
                position = .init(x: restoredValue.x, y: restoredValue.y)
            }
    }
}

extension View {
    /// Apply the ``ScrollRestorationModifier``.
    @ViewBuilder
    func scrollRestoration<R: RootRegistry>(_: R.Type = R.self, id: String?) -> some View {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, *),
           let id
        {
            self.modifier(ScrollRestorationModifier<R>(id: id))
        } else {
            self
        }
    }
}
