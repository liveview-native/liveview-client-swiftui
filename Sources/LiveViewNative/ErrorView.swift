//
//  ErrorView.swift
//  
//
//  Created by Carson Katri on 4/27/23.
//

import SwiftUI

#if os(macOS)
import WebKit
struct ErrorView: NSViewRepresentable {
    let html: String
    
    func makeNSView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.loadHTMLString(html, baseURL: nil)
        return view
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.loadHTMLString(html, baseURL: nil)
    }
}
#elseif os(iOS)
import WebKit
struct ErrorView: UIViewRepresentable {
    let html: String
    
    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.loadHTMLString(html, baseURL: nil)
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(html, baseURL: nil)
    }
}
#else
struct ErrorView: View {
    let html: String
    
    var body: some View {
        SwiftUI.Text("Unexpected response received from the server: \(html)")
    }
}
#endif
