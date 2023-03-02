//
//  PasteButton.swift
//  
//
//  Created by Carson Katri on 3/2/23.
//
#if os(iOS) || os(macOS)
import SwiftUI

struct PasteButton<R: RootRegistry>: View {
    @ObservedElement private var element
    private let context: LiveContext<R>
    
    init(context: LiveContext<R>) {
        self.context = context
    }
    
    var body: some View {
        SwiftUI.PasteButton(payloadType: String.self) { strings in
            guard let clickEvent = element.attributeValue(for: "phx-click")
            else { return }
            Task {
                try await context.coordinator.pushEvent(type: "click", event: clickEvent, value: ["value": strings])
            }
        }
    }
}
#endif
