//
//  AlertModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 4/28/23.
//

import SwiftUI

/// Displays a system-style alert when a ``isPresented`` is `true`.
///
/// ```html
/// <Button phx-click="toggle-show"
///     modifiers={
///         @native
///         |> alert(title: "My Alert", message: :message, actions: :actions, is_presented: :show)
///     }
/// >
///   Present Alert
///   <Text template={:message}>
///     Hello, world!
///   </Text template={:message}>
///   <Group template={:actions}>
///     <Button>
///       OK
///     </Button>
///   </Group template={:actions}>
/// </Button>
/// ```
///
/// ```elixir
/// defmodule AppWeb.TestLive do
///     use AppWeb, :live_view
///     use LiveViewNative.LiveView
///
///     native_binding :show, Atom, false
/// end
/// ```
///
/// ## Arguments
/// - ``title``
/// - ``actions``
/// - ``message``
/// - ``isPresented``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct AlertModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// The title of the alert.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let title: String
    
    /// A reference to a set of ``Button`` views that are used as the actions for the alert.
    ///
    /// The system will dismiss the alert when any of the buttons is activated.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let actions: String
    
    /// A reference to an optional ``Text`` view to use as the alert's message.
    ///
    /// If no reference is provided, the alert will not have a message.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let message: String?
    
    /// The name of a value that controls when the alert is shown.
    ///
    /// Set the binding to `true` to show the alert.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @ChangeTracked private var isPresented: Bool
    
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try container.decode(String.self, forKey: .title)
        self.actions = try container.decode(String.self, forKey: .actions)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self._isPresented = try ChangeTracked(decoding: .isPresented, in: container)
    }
    
    func body(content: Content) -> some View {
        content.alert(title, isPresented: $isPresented) {
            context.buildChildren(of: element, forTemplate: self.actions)
        } message: {
            if let message {
                context.buildChildren(of: element, forTemplate: message)
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case actions
        case message
        case isPresented
    }
}
