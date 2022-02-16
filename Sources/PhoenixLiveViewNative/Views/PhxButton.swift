//
//  PhxButton.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import SwiftSoup

struct PhxButton: View {
    private let element: Element
    private let context: LiveContext
    private let clickEvent: String?
    private let disabled: Bool
    
    init(element: Element, context: LiveContext) {
        self.element = element
        self.context = context
        self.clickEvent = element.attrIfPresent("phx-click")
        self.disabled = element.hasAttr("disabled")
    }
    
    var body: some View {
        Button(action: self.handleClick) {
            context.buildChildren(of: element)
        }
        .buttonStyle(.plain)
        .disabled(disabled)
    }
    
    private func handleClick() {
        guard let clickEvent = clickEvent else {
            return
        }
        let payload: Payload = [
            "type": "click",
            "event": clickEvent,
            "value": element.buildPhxValuePayload(),
        ]
        context.coordinator.pushEvent("event", payload: payload)
    }
    
}
