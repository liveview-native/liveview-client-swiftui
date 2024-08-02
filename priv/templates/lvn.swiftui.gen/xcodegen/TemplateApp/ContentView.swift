//
//  ContentView.swift
//  <%= @app_namespace %>
//

import SwiftUI
import LiveViewNative<%= if @live_form? do %>
import LiveViewNativeLiveForm<% end %>

struct ContentView: View {
    var body: some View {
        #LiveView(
            .automatic(
                development: .localhost(path: "/"),
                production: URL(string: "https://example.com")!
            ),
            addons: [<%= if @live_form? do %>
               .liveForm
            ]<% else %>]<% end %>
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
