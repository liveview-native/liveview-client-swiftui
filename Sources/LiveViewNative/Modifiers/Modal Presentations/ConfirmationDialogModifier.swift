//
//  ConfirmationDialogModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 4/28/23.
//

import SwiftUI

/// Displays a confirmation dialog when ``isPresented`` is `true`.
///
/// ```html
/// <Button phx-click="toggle-show"
///     modifiers={
///         confirmation_dialog("Are you sure?", title_visibility: :visible, actions: :actions, is_presented: @show, change: "presentation-changed")
///     }
/// >
///   Present Confirmation Dialog
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
///   use AppWeb, :live_view
///   use LiveViewNative.LiveView
///
///   def handle_event("presentation-changed", %{ "is_presented" => show }, socket) do
///     {:noreply, assign(socket, show: show)}
///   end
/// end
/// ```
///
/// ## Arguments
/// - ``title``
/// - ``titleVisibility``
/// - ``actions``
/// - ``message``
/// - ``isPresented``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ConfirmationDialogModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// The title of the confirmation dialog.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let title: String
    
    /// Whether the title is visible. Defaults to `automatic`.
    ///
    /// If the title is not shown, it may still be used by accessibility technologies.
    ///
    /// See ``LiveViewNative/SwiftUI/Visibility``
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let titleVisibility: Visibility
    
    /// A reference to a set of ``Button`` views that are used as the dialog's actions.
    ///
    /// The system will dismiss the alert when any of the buttons is activated.
    ///
    /// The first button provided is used as the confirmation action, and a "Cancel" action is added automatically.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let actions: String
    
    /// A reference to an optional ``Text`` view to use as the dialog''s message.
    ///
    /// If no reference is provided, the alert will not have a message.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let message: String?
    
    /// The name of a value that controls when the dialog is shown.
    ///
    /// Set the value to `true` to show the alert.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @ChangeTracked private var isPresented: Bool
    
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try container.decode(String.self, forKey: .title)
        self.titleVisibility = try container.decode(Visibility.self, forKey: .titleVisibility)
        self.actions = try container.decode(String.self, forKey: .actions)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self._isPresented = try ChangeTracked(decoding: CodingKeys.isPresented, in: decoder)
    }
    
    func body(content: Content) -> some View {
        content.confirmationDialog(title, isPresented: $isPresented, titleVisibility: titleVisibility) {
            context.buildChildren(of: element, forTemplate: self.actions)
        } message: {
            if let message {
                context.buildChildren(of: element, forTemplate: message)
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case titleVisibility
        case actions
        case message
        case isPresented
    }
}
