//
//  ContentView.swift
//  TemplateApp
//

import SwiftUI
import LiveViewNative

struct ContentView: View {
    var body: some View {
        #LiveView(
            .automatic(
                development: .localhost(path: "%LVN_PREFERRED_ROUTE%"),
                production: URL(string: "https://%LVN_PREFERRED_PROD_URL%%LVN_PREFERRED_ROUTE%")!
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
