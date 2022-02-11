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
    private let coordinator: LiveViewCoordinator
    private let clickEvent: String?
    private let disabled: Bool
    
    init(element: Element, coordinator: LiveViewCoordinator) {
        self.element = element
        self.coordinator = coordinator
        self.clickEvent = element.attrIfPresent("phx-click")
        self.disabled = element.hasAttr("disabled")
    }
    
    var body: some View {
        Button(action: self.handleClick) {
            ViewTreeBuilder.fromElements(element.children(), coordinator: coordinator)
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
        coordinator.pushWithReply(event: "event", payload: payload)
    }
    
}
