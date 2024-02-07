//
//  ErrorView.swift
//  ErrorView
//

import SwiftUI
import LiveViewNative

struct ErrorView: View {
    let error: Error

    var body: some View {
        LiveErrorView(error: error) {
            if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
                ContentUnavailableView {
                    Label("Connection Failed", systemImage: "network.slash")
                } description: {
                    description
                } actions: {
                    Button {
                        UIPasteboard.general.string = error.localizedDescription
                    } label: {
                        Label("Copy Error", systemImage: "doc.on.doc")
                    }
                }
            } else {
                VStack {
                    Label("Connection Failed", systemImage: "network.slash")
                        .font(.headline)
                    description
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    @ViewBuilder
    var description: some View {
        #if DEBUG
        ScrollView {
            Text(error.localizedDescription)
                .font(.caption.monospaced())
                .multilineTextAlignment(.leading)
        }
        #else
        Text("The app will reconnect when network connection is regained.")
        #endif
    }
}

#Preview {
   ErrorView(error: LiveConnectionError.initialParseError(missingOrInvalid: .csrfToken))
}
