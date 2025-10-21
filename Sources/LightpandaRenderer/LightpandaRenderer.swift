//
//  LightpandaRenderer.swift
//  LightpandaClient
//
//  Created by Carson.Katri on 10/7/25.
//

import SwiftUI
import LightpandaClient

public struct LightpandaRenderer<Library: ElementLibrary>: View {
    @State private var lightpanda: LightpandaRuntime
    @Namespace private var namespace
    
    public init(url: URL) {
        self._lightpanda = .init(wrappedValue: LightpandaRuntime(url: url))
    }
    
    public var body: some View {
        SwiftUI.Group {
            if let dom = lightpanda.dom {
                NodeView<Library>(node: dom)
            }
        }
        .environment(lightpanda)
        .environment(\.lightpandaNamespace, namespace)
        .task {
            try! await lightpanda.start()
        }
        #if DEBUG
        .overlay(alignment: .top) {
            if let pausedInDebuggerMessage = self.lightpanda.cdp?.pausedInDebuggerMessage {
                GlassEffectContainer(spacing: 8) {
                    SwiftUI.HStack {
                        SwiftUI.Text(pausedInDebuggerMessage)
                            .frame(maxHeight: .infinity)
                            .padding(8)
                            .glassEffect(.clear)
                        SwiftUI.Button {
                            
                        } label: {
                            Image(systemName: "arrow.turn.up.right")
                                .frame(maxHeight: .infinity)
                        }
                        .buttonStyle(.glass)
                        SwiftUI.Button {
                            
                        } label: {
                            Image(systemName: "play.fill")
                                .frame(maxHeight: .infinity)
                        }
                        .buttonStyle(.glassProminent)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }
                .transition(.move(edge: .top))
            }
        }
        #endif
    }
}

extension EnvironmentValues {
    @Entry var lightpandaNamespace: Namespace.ID? = nil
}
