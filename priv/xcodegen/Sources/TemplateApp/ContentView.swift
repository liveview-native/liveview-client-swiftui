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
          // connecting
            ProgressView()
        } disconnected: {
            DisconnectedView()
        } reconnecting: { content, isReconnecting in
            ReconnectingView(content: content, isReconnecting: isReconnecting)
        } error: { error in
            ErrorView(error: error)
        }
    }
}