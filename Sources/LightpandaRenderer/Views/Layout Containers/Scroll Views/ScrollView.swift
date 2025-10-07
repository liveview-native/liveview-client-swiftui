//
//  ScrollView.swift
//  LightpandaRenderer
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import LightpandaClient

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
struct ScrollView<Library: ElementLibrary>: View {
    let node: Node
    
    /// Which axes this view is scrollable along (defaults to vertical).
    @_documentation(visibility: public)
    private var axes: Axis.Set {
        node.attributeValue(for: "axes", strategy: AxisSetParseStrategy()) ?? .vertical
    }
    /// Whether the scroll indicators are shown (defaults to true).
    @_documentation(visibility: public)
    private var showsIndicators: Bool {
        node.attributeValue(for: "showsIndicators") != "false"
    }
    
    /// When the scroll view appears, and whenever this attribute changes, it will scroll to the view with the corresponding `id` attribute.
    ///
    /// The ``scrollPositionAnchor`` attribute governs where in the scroll view the target will be positioned.
    @_documentation(visibility: public)
    private var scrollPosition: String? {
        node.attributeValue(for: "scrollPosition")
    }
    /// Where in the scroll view the view that is being scrolled to is positioned.
    ///
    /// For example, specifying `top` will scroll the target to be at the top of the scroll view.
    ///
    /// See ``LiveViewNative/SwiftUI/UnitPoint`` for how values can be specified.
    @_documentation(visibility: public)
    private var scrollPositionAnchor: UnitPoint? {
        node.attributeValue(for: "scrollPositionAnchor", strategy: UnitPointParseStrategy())
    }
    
    private var id: String? {
        node.attributeValue(for: "id")
    }
    
    public var body: some View {
        SwiftUI.ScrollViewReader { proxy in
            SwiftUI.ScrollView(
                axes,
                showsIndicators: showsIndicators
            ) {
                node.children(library: Library.self)
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

struct AxisSetParseStrategy: ParseStrategy {
    func parse(_ value: String) throws -> Axis.Set {
        switch value {
        case "horizontal":
            return .horizontal
        case "vertical":
            return .vertical
        case "all":
            return [.horizontal, .vertical]
        default:
            throw ParseError()
        }
    }
}

struct UnitPointParseStrategy: ParseStrategy {
    func parse(_ value: String) throws -> UnitPoint {
        switch value {
        case "zero":
            return .zero
        case "center":
            return .center
        case "leading":
            return .leading
        case "trailing":
            return .trailing
        case "top":
            return .top
        case "bottom":
            return .bottom
        case "topLeading":
            return .topLeading
        case "topTrailing":
            return .topTrailing
        case "bottomLeading":
            return .bottomLeading
        case "bottomTrailing":
            return .bottomTrailing
        default:
            throw ParseError()
        }
    }
}
