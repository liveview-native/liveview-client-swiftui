//
//  PhxButton.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import SwiftSoup

/// `<button>`, a tappable element.
public struct PhxButton<R: CustomRegistry>: View {
    private let element: Element
    private let context: LiveContext<R>
    private let clickEvent: String?
    // used internaly by PhxSubmitButton
    private let action: (() -> Void)?
    private let buttonStyle: PhxButtonStyle
    private let disabled: Bool
    
    init(element: Element, context: LiveContext<R>, action: (() -> Void)?) {
        self.element = element
        self.context = context
        self.clickEvent = element.attrIfPresent("phx-click")
        self.action = action
        self.disabled = element.hasAttr("disabled")
        if let s = element.attrIfPresent("button-style"),
           let style = PhxButtonStyle(rawValue: s) {
            self.buttonStyle = style
        } else {
            self.buttonStyle = .automatic
        }
    }
    
    public var body: some View {
        Button(action: self.handleClick) {
            context.buildChildren(of: element)
        }
        .phxButtonStyle(buttonStyle)
        .disabled(disabled)
    }
    
    private func handleClick() {
        if let action = action {
            action()
            return
        }
        guard let clickEvent = clickEvent else {
            return
        }
        Task {
            try await context.coordinator.pushEvent(type: "click", event: clickEvent, value: element.buildPhxValuePayload())
        }
    }
    
}

fileprivate enum PhxButtonStyle: String {
    case automatic
    case bordered
    case borderedProminent = "bordered-prominent"
    case borderless
    case plain
}

fileprivate extension View {
    @ViewBuilder
    func phxButtonStyle(_ style: PhxButtonStyle) -> some View {
        switch style {
        case .automatic:
            self.buttonStyle(.automatic)
        case .bordered:
            self.buttonStyle(.bordered)
        case .borderedProminent:
            self.buttonStyle(.borderedProminent)
        case .borderless:
            self.buttonStyle(.borderless)
        case .plain:
            self.buttonStyle(.plain)
        }
    }
}
