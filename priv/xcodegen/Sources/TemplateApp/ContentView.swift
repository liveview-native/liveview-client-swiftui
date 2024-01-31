//
//  ContentView.swift
//  TemplateApp
//

import SwiftUI
import LiveViewNative

struct ContentView: View {
    var body: some View {
        LiveView(
            .automatic(
                development: .localhost(path: "%LVN_PREFERRED_ROUTE%"),
                production: URL(string: "https://%LVN_PREFERRED_PROD_URL%%LVN_PREFERRED_ROUTE%")!
            )
        ) {
            ProgressView("Connecting")
        } disconnected: {
            if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
                ContentUnavailableView {
                    Label("No Connection", systemImage: "network.slash")
                } description: {
                    Text("The app will reconnect when network connection is regained.")
                }
            } else {
                Text("No Connection")
            }
        } reconnecting: { content, isReconnecting in
            content
                .safeAreaInset(edge: .top) {
                    if isReconnecting {
                        VStack {
                            Label("No Connection", systemImage: "wifi.slash")
                                .bold()
                            Text("Reconnecting")
                                .foregroundStyle(.secondary)
                        }
                            .font(.caption)
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            #if os(watchOS)
                            .background(
                                if #available(watchOS 10.0, *) {
                                    AnyShapeStyle(.regularMaterial)
                                } else {
                                    AnyShapeStyle(.background)
                                }
                            )
                            #else
                            .background(.regularMaterial)
                            #endif
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .animation(.default, value: isReconnecting)
        } error: { error in
            LiveErrorView(error: error) {
                if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
                    ContentUnavailableView {
                        Label("Connection Failed", systemImage: "network.slash")
                    } description: {
                        #if DEBUG
                        Text(error.localizedDescription)
                            .monospaced()
                        #else
                        Text("The app will reconnect when network connection is regained.")
                        #endif
                    }
                } else {
                    VStack {
                        Label("Connection Failed", systemImage: "network.slash")
                            .font(.subheadline)
                        #if DEBUG
                        Text(error.localizedDescription)
                            .monospaced()
                        #else
                        Text("The app will reconnect when network connection is regained.")
                        #endif
                    }
                }
            }
        }
    }
}
