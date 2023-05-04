//
//  ErrorView.swift
//  
//
//  Created by Carson Katri on 4/27/23.
//

import SwiftUI

enum ErrorSource {
    case html(String)
    case error(Error)
}

struct ErrorView<R: RootRegistry>: View {
    let source: ErrorSource
    
    init(html: String) {
        self.source = .html(html)
    }
    
    init(_ error: Error) {
        self.source = .error(error)
    }
    
    @State private var isPresented = false
    
    var body: some View {
        switch source {
        case let .html(html):
            WebErrorView(html: html)
        case let .error(error):
            if R.ErrorView.self == Never.self {
                SwiftUI.Text(error.localizedDescription)
                    .alert(error.localizedDescription, isPresented: $isPresented) {
                        SwiftUI.Button("OK", action: {})
                    }
                    .task {
                        isPresented = true
                    }
            } else {
                R.errorView(for: error)
            }
        }
    }
}

#if os(macOS)
import WebKit
struct WebErrorView: NSViewRepresentable {
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
struct WebErrorView: UIViewRepresentable {
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
struct WebErrorView: View {
    let html: String
    
    var body: some View {
        SwiftUI.Text("Unexpected response received from the server: \(html)")
    }
}
#endif
