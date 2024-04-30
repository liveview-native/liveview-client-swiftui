//
//  LiveErrorView.swift
//
//
//  Created by Carson Katri on 1/31/24.
//

import SwiftUI

/// A View that renders a ``LiveConnectionError``, or a fallback View.
/// This can be used to display the stack trace HTML returned by Phoenix when debugging.
///
/// When the app is built in release configuration, the `fallback` will always be used.
public struct LiveErrorView<Fallback: View>: View {
    let error: Error
    let fallback: Fallback
    
    @Environment(\.reconnectLiveView) private var reconnectLiveView
    
    public init(error: Error, @ViewBuilder fallback: () -> Fallback) {
        self.error = error
        self.fallback = fallback()
    }
    
    public var body: some View {
        #if DEBUG
        if let error = error as? LiveConnectionError,
           case let .initialFetchUnexpectedResponse(_, trace?) = error
        {
            SwiftUI.VStack {
                WebErrorView(html: trace)
                #if os(watchOS) || os(tvOS)
                SwiftUI.Button {
                    Task {
                        await reconnectLiveView(.restart)
                    }
                } label: {
                    SwiftUI.Label("Restart", systemImage: "arrow.circlepath")
                }
                .padding()
                #else
                SwiftUI.Menu {
                    SwiftUI.Button {
                        Task {
                            await reconnectLiveView(.automatic)
                        }
                    } label: {
                        SwiftUI.Label("Reconnect this page", systemImage: "arrow.2.circlepath")
                    }
                    SwiftUI.Button {
                        Task {
                            await reconnectLiveView(.restart)
                        }
                    } label: {
                        SwiftUI.Label("Restart from root", systemImage: "arrow.circlepath")
                    }
                } label: {
                    SwiftUI.Label("Reconnect", systemImage: "arrow.2.circlepath")
                }
                .padding()
                #endif
            }
        } else {
            fallback
        }
        #else
        fallback
        #endif
    }
}
