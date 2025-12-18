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
    
    @State private var cachedRootNode: Node?
    @State private var cachedNodes = [Int:Node]()
    
    var body: some View {
        SwiftUI.NavigationStack(path: $path) {
            SwiftUI.VStack {
                if let cachedNode = cachedNodes[-1] {
                    cachedNode.children(library: Library.self)
                } else {
                    node.children(library: Library.self)
                }
            }
            .navigationDestination(for: Int.self) { index in
                if let cachedNode = cachedNodes[index] {
                    cachedNode.children(library: Library.self)
                } else {
                    node.children(library: Library.self)
                }
            }
        }
        .task {
            let bindingName = UUID().uuidString
            try! await runtime.cdp.addBinding(name: bindingName) { [weak node] call in
                cachedNodes[path.count - 1] = node?.cloneForCaching()
                self.path.append(path.count)
            }
            // monkey-patch pushState to observe changes
            try! await self.node.callFunction(runtime: runtime, function: #"""
                function() {
                    const originalPushState = history.pushState;
                    window.history.pushState = function(...args) {
                        console.error("binding started");
                        globalThis["\#(bindingName)"]("");
                        console.error("binding finished");
                
                        return originalPushState.apply(this, args);
                    };
                }
                """#)
            try? await withTaskCancellationHandler {
                try await Task.sleep(nanoseconds: UInt64.max)
            } onCancel: {
                Task { try! await runtime.cdp.removeBinding(name: bindingName) }
            }
        }
        .onChange(of: path) { oldValue, newValue in
            if newValue.count < oldValue.count {
                let diff = oldValue.count - newValue.count
                
                Task {
                    try? await self.node.callFunction(
                        runtime: runtime,
                        function: #"""
                        function() {
                            for (let i = 0; i < \#(diff); i++) {
                                window.history.back();
                            }
                        }
                        """#
                    )
                }
                
                let validIndices = Set(-1..<newValue.count - 1)
                cachedNodes = cachedNodes.filter { validIndices.contains($0.key) }
            }
        }
    }
}
