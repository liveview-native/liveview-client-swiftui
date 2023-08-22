//
//  PopoverModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/23/2023.
//

import SwiftUI

/// A modifier that presents another view as a popover when ``isPresented`` is `true`.
///
/// - Note: Popovers are rendered as a sheet on iOS. Use ``PresentationCompactAdaptationModifier`` to customize this behavior.
///
/// ```html
/// <Button phx-click="toggle" modifiers={popover(content: :content, is_presented: @show, change: "presentation-changed")}>
///   Present Popover
///   <VStack template={:content}>
///     <Text>Hello, world!</Text>
///     <Button phx-click="toggle">Dismiss</Button>
///   </VStack>
/// </Button>
/// ```
///
/// ```elixir
/// defmodule AppWeb.TestLive do
///   use AppWeb, :live_view
///   use LiveViewNative.LiveView
///
///   def handle_event("presentation-changed", %{ "is_presented" => show }, socket) do
///     {:noreply, assign(socket, show: show)}
///   end
/// end
/// ```
///
/// Change the ``attachmentAnchor`` and ``arrowEdge`` to customize the placement of the popover.
///
/// ```html
/// <Button
///   modifiers={
///     popover(
///       content: :content,
///       is_presented: :show,
///       attachment_anchor: {:point, :bottom},
///       arrow_edge: :bottom
///     )
///   }
/// >
///   ...
/// </Button>
/// ```
///
///## Arguments
///- ``isPresented``
///- ``attachmentAnchor``
///- ``arrowEdge``
///- ``content``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, *)
struct PopoverModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// The value that controls when the popover is presented.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @ChangeTracked private var isPresented: Bool

    /// The point where the popover attaches to the element. Defaults to `{:rect, :bounds}`
    ///
    /// See ``LiveViewNative/SwiftUI/PopoverAttachmentAnchor`` for more details.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let attachmentAnchor: PopoverAttachmentAnchor

    /// The edge of the ``attachmentAnchor`` to place the arrow. Defaults to `top`.
    ///
    /// See ``LiveViewNative/SwiftUI/Edge`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let arrowEdge: Edge
    
    /// A reference to the content view for the popover.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let content: String
    
    @ObservedElement private var element
    @LiveContext<R> private var context

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self._isPresented = try ChangeTracked(decoding: CodingKeys.isPresented, in: decoder)
        self.attachmentAnchor = try container.decodeIfPresent(
            PopoverAttachmentAnchor.self,
            forKey: .attachmentAnchor
        ) ?? .rect(.bounds)
        self.arrowEdge = try container.decodeIfPresent(Edge.self, forKey: .arrowEdge) ?? .top
        self.content = try container.decode(String.self, forKey: .content)
    }

    func body(content: Content) -> some View {
        content
            #if os(iOS) || os(macOS)
            .popover(
                isPresented: $isPresented,
                attachmentAnchor: attachmentAnchor,
                arrowEdge: arrowEdge
            ) {
                context.buildChildren(of: element, forTemplate: self.content)
            }
            #endif
    }

    enum CodingKeys: String, CodingKey {
        case isPresented
        case attachmentAnchor
        case arrowEdge
        case content
    }
}

/// The attachment point for a ``PopoverModifier`` modifier.
///
/// Use a tuple to specify the type of anchor, either `point` or `rect`.
///
/// Provide a ``LiveViewNative/SwiftUI/UnitPoint`` or ``LiveViewNative/SwiftUI/Anchor/Source``
/// to create the anchor.
///
/// ```elixir
/// {:point, :center}
/// {:rect, :bounds}
/// {:rect, {:rect, [25, 0, 50, 50]}}
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension PopoverAttachmentAnchor: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(AnchorType.self, forKey: .type) {
        case .point:
            self = .point(try container.decode(UnitPoint.self, forKey: .properties))
        case .rect:
            self = .rect(try container.decode(Anchor<CGRect>.Source.self, forKey: .properties))
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case properties
    }
    
    enum AnchorType: String, Decodable {
        case point
        case rect
    }
}
