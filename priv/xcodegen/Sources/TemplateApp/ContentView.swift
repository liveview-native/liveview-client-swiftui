//
//  ContentView.swift
//  TemplateApp
//

import SwiftUI
import LiveViewNative

struct ContentView: View {
    var body: some View {
        LiveView(
            .automatic(development: .localhost, production: .custom(URL(string: "example.com")!)),
            configuration: .init(connectParams: { _ in ["apns_token": "tokenValue"] })
        )
    }
}
