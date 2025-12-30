//
//  PasteButton.swift
//  
//
//  Created by Carson Katri on 3/2/23.
//

import SwiftUI
import LightpandaClient

/// Sends an event with the clipboard's contents when tapped.
///
/// ```html
/// <PasteButton />
/// ```
///
/// The pasted strings are dispatched as a "paste" event with the clipboard contents.
///
/// > ``PasteButton`` only sends copied `String` types.
@_documentation(visibility: public)
struct PasteButton<Library: ElementLibrary>: View {
    let node: Node
    
    @Environment(LightpandaRuntime.self) private var lightpanda
    
    var body: some View {
        #if os(iOS) || os(macOS)
        SwiftUI.PasteButton(payloadType: String.self) { strings in
            Task {
                let jsonStrings = String(data: try! JSONEncoder().encode(strings), encoding: .utf8)!
                try await self.node.callFunction(
                    runtime: lightpanda,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("paste", {
                            detail: \#(jsonStrings),
                            bubbles: true
                        }));
                    }
                    """#
                )
            }
        }
        #endif
    }
}
