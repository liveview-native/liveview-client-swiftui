//
//  FindNavigatorModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 5/19/2023.
//

import SwiftUI

/// Controls whether the find navigator is shown.
///
/// Use this modifier with a ``TextEditor``:
///
/// ```html
/// <TextEditor text="my_text" modifiers={find_navigator(is_presented: @show, change: "navigator-changed")} />
/// ```
///
/// ```elixir
/// defmodule AppWeb.TestLive do
///   use AppWeb, :live_view
///   use LiveViewNative.LiveView
///
///   def handle_event("navigator-changed", %{ "is_presented" => show }, socket) do
///     {:noreply, assign(socket, show: show)}
///   end
/// end
/// ```
///
/// ## Arguments
/// * ``isPresented``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, *)
struct FindNavigatorModifier: ViewModifier, Decodable {
    /// A value that controls whether the find navigator is shown.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @ChangeTracked private var isPresented: Bool
    
    init(from decoder: Decoder) throws {
        self._isPresented = try ChangeTracked(decoding: CodingKeys.isPresented, in: decoder)
    }

    func body(content: Content) -> some View {
        content
            #if os(iOS)
            .findNavigator(isPresented: $isPresented)
            #endif
    }
    
    enum CodingKeys: String, CodingKey {
        case isPresented
    }
}
