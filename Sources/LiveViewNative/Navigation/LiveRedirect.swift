//
//  LiveRedirect.swift
//  
//
//  Created by Carson Katri on 1/6/23.
//

import Foundation

struct LiveRedirect {
    let kind: Kind
    let to: URL
    let mode: Mode
    
    enum Kind: String {
        case push
        case replace
    }
    
    enum Mode: String {
        /// Standard LiveView redirect style. Uses the top-most ``LiveViewCoordinator`` to handle the new page.
        ///
        /// This works with the standard `NavigationStack` and LiveView's `push_navigate/2`.
        ///
        /// When a redirect is received with this default mode, the following takes place:
        ///
        /// 1. The top-most ``LiveViewCoordinator`` is retrieved.
        /// 2. The ``LiveViewCoordinator/url`` is changed to the redirect destination.
        /// 3. A new ``LiveNavigationEntry`` is added to the stack.
        ///
        /// When the ``LiveNavigationEntry`` is popped (via back button or programmatically),
        /// the top-most ``LiveViewCoordinator/url`` is changed to the new top-most destination.
        case replaceTop
        
        /// Connects to a separate Phoenix channel with a fresh ``LiveViewCoordinator`` over the same WebSocket.
        ///
        /// This works with `NavigationSplitView`. It can also be used with `NavigationStack` to keep the previous pages loaded in the background.
        ///
        /// You must send the `native_redirect` event to use this mode:
        /// ```ex
        /// push_event(
        ///   socket,
        ///   "native_redirect",
        ///   %{
        ///     to: "destination",
        ///     kind: :push,
        ///     mode: :multiplex
        ///   }
        /// )
        /// ```
        ///
        /// When a redirect is received with this mode, the following takes place:
        ///
        /// 1. If the kind is ``LiveRedirect/Kind/push``, a new ``LiveViewCoordinator`` is created for the redirect destination.
        /// A separate Phoenix channel is connected for each coordinator.
        /// 2. If the kind is ``LiveRedirect/Kind/redirect`` and the destination is the same as the previous path, the current entry is popped and no new ``LiveViewCoordinator`` is connected.
        /// Otherwise a new ``LiveViewCoordinator`` is created in place of the top-most entry.
        case multiplex
        
        /// A `live_patch` style redirect.
        ///
        /// This replaces the URL of the page without reloading anything. It can be a push or replace kind.
        case patch
    }
    
    init(kind: Kind, to: URL, mode: Mode) {
        self.kind = kind
        self.to = to
        self.mode = mode
    }
    
    init?(from payload: Payload, relativeTo rootURL: URL, mode: Mode = .replaceTop) {
        guard let kind = (payload["kind"] as? String).flatMap(Kind.init),
              let to = (payload["to"] as? String).flatMap({ URL.init(string: $0, relativeTo: rootURL) })
        else { return nil }
        self.kind = kind
        self.to = to.appending(path: "").absoluteURL
        self.mode = (payload["mode"] as? String).flatMap(Mode.init) ?? mode
    }
}
