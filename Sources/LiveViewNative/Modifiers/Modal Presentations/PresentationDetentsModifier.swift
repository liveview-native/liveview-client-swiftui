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
/// <Button phx-click="toggle" modifiers={sheet(@native, content: :content, on_dismiss: "dismiss", is_presented: :show)}>
///   Present Sheet
///
///   <VStack template={:content} modifiers={presentation_detents(@native, detents: [:medium, {:fraction, 0.3}, {:height, 100}])}>
///     <Text>Hello, world!</Text>
///     <Button phx-click="toggle">Dismiss</Button>
///   </VStack>
/// </Button>
/// ```
///
/// Use the ``selection`` argument to synchronize the selected detent's index with the backend.
///
/// ```html
/// <VStack modifiers={presentation_detents(@native, detents: [...], selection: :active_detent)}>
///   ...
/// </VStack>
/// ```
///
/// ```elixir
/// defmodule MyAppWeb.SheetLive do
///   native_binding :active_detent, Integer, 0
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
    
    @LiveBinding private var selection: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.detents = try container.decode([PresentationDetent].self, forKey: .detents)
        self._selection = try LiveBinding(decoding: .selection, in: container)
    }
    
    func body(content: Content) -> some View {
        if _selection.isBound {
            content.presentationDetents(Set(detents), selection: Binding {
                detents[selection]
            } set: {
                selection = detents.firstIndex(of: $0)!
            })
        } else {
            content.presentationDetents(Set(detents))
        }
    }
    
    enum CodingKeys: CodingKey {
        case detents
        case selection
    }
}
