//
//  NavigationStack.swift
//
//
//  Created by Carson Katri on 11/16/23.
//

import SwiftUI
import LightpandaClient

struct NavigationStack<Library: ElementLibrary>: View {
    let node: Node
    
    @Environment(\.namespaces)
    private var namespaces
    
    @Environment(LightpandaRuntime.self)
    private var runtime
    
    @State private var path = NavigationPath()
    
    var body: some View {
        SwiftUI.NavigationStack(path: $path) {
            SwiftUI.VStack {
                if path.isEmpty {
                    node.children(library: Library.self)
                }
            }
            .navigationDestination(for: UUID.self) { route in
                node.children(library: Library.self)
            }
        }
        .task {
            let id = UUID().uuidString
            let binding = try! await runtime.cdp.addBinding(name: id)
            
            defer {
                Task { try! await runtime.cdp.removeBinding(name: id) }
            }
            
            // monkey-patch pushState to observe changes
            try! await self.node.callFunction(runtime: runtime, function: #"""
            function() {
                const originalPushState = history.pushState;
                window.history.pushState = function(...args) {
                    globalThis["\#(id)"]("");
            
                    return originalPushState.apply(this, args);
                };
            }
            """#)
            
            for await call in binding {
                self.path.append(UUID())
            }
        }
        // when navigation path loses an item, sync with browser history.back()
        .onChange(of: path) { oldValue, newValue in
            if newValue.count < oldValue.count {
                Task {
                    try! await self.node.callFunction(runtime: runtime, function: #"""
                    function() {
                        window.history.back()
                    }
                    """#)
                }
            }
        }
    }
}
