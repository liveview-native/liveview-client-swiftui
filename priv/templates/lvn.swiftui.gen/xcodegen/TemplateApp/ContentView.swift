//
//  ContentView.swift
//  <%= @app_namespace %>
//

import SwiftUI
import LiveViewNative

struct ContentView: View {
    var body: some View {
        #LiveView(
            .automatic(
                development: .localhost(path: "/"),
                production: URL(string: "https://example.com")!
            ),
            addons: []
        ) {
            ConnectingView()
        } disconnected: {
            DisconnectedView()
        } reconnecting: { content, isReconnecting in
            ReconnectingView(isReconnecting: isReconnecting) {
                content
            }
        } error: { error in
            ErrorView(error: error)
        }
    }
}
