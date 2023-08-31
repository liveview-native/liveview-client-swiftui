//
//  PresentationDetentsModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 4/28/23.
//

import SwiftUI

/// Specifies the detents that a view presented as a sheet can snap to.
///
/// Use this modifier in the content of a ``SheetModifier``.
///
/// ```html
/// <Button phx-click="toggle" modifiers={sheet(content: :content, on_dismiss: "dismiss", is_presented: :show)}>
///   Present Sheet
///
///   <VStack template={:content} modifiers={presentation_detents([:medium, {:fraction, 0.3}, {:height, 100}])}>
///     <Text>Hello, world!</Text>
///     <Button phx-click="toggle">Dismiss</Button>
///   </VStack>
/// </Button>
/// ```
///
/// Use the ``selection`` and `change` arguments to synchronize the selected detent's index with the backend.
///
/// ```html
/// <VStack modifiers={presentation_detents([...], selection: @active_detent, change: "presentation-changed")}>
///   ...
/// </VStack>
/// ```
///
/// ```elixir
/// defmodule MyAppWeb.SheetLive do
///   def handle_event("presentation-changed", %{ "selection" => selection }, socket) do
///     {:noreply, assign(socket, active_detent: selection)}
///   end
/// end
/// ```
///
/// ## Arguments
/// - ``detents``
/// - ``selection``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct PresentationDetentsModifier: ViewModifier, Decodable {
    /// The detents the sheet can snap to.
    ///
    /// See ``LiveViewNative/SwiftUI/PresentationDetent`` for how to specify detents.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let detents: [PresentationDetent]
    
    @ChangeTracked private var selection: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.detents = try container.decode([PresentationDetent].self, forKey: .detents)
        self._selection = try ChangeTracked(decoding: CodingKeys.selection, in: decoder)
    }
    
    func body(content: Content) -> some View {
        content.presentationDetents(Set(detents), selection: Binding {
            detents[selection]
        } set: {
            selection = detents.firstIndex(of: $0)!
        })
    }
    
    enum CodingKeys: CodingKey {
        case detents
        case selection
    }
}
