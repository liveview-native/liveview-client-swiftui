//
//  ContentView.swift
//  TemplateApp
//

import SwiftUI
import LiveViewNative

struct ContentView: View {
    var body: some View {
        LiveView(.automatic(
            development: .localhost(path: "%LVN_PREFERRED_ROUTE%"),
            production: .custom(URL(string: "https://%LVN_PREFERRED_PROD_URL%%LVN_PREFERRED_ROUTE%")!)
        ))
    }
}
