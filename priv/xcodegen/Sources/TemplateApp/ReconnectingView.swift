//
//  ReconnectingView.swift
//  ReconnectingView
//

import SwiftUI

struct ReconnectingView: View {
    var content: AnyView
    var isReconnecting: Bool
    
    var body: some View {
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
                        .background(.background)
                        #else
                        .background(.regularMaterial)
                        #endif
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .animation(.default, value: isReconnecting)
    }
}

//#Preview {
//    ReconnectingView(
//        content: Text("Test"),
//        isReconnecting: true
//    )
//}
