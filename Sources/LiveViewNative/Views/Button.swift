//
//  Button.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct Button<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    // used internaly by PhxSubmitButton
    private let action: (() -> Void)?
    
    init(element: ElementNode, context: LiveContext<R>, action: (() -> Void)?) {
        self.context = context
        self.action = action
    }
    
    public var body: some View {
        SwiftUI.Button(action: self.handleClick) {
            context.buildChildren(of: element)
        }
        .phxButtonStyle(buttonStyle)
        .disabled(element.attributeValue(for: "disabled") != nil)
    }
    
    private var buttonStyle: PhxButtonStyle {
        if let s = element.attributeValue(for: "button-style"),
           let style = PhxButtonStyle(rawValue: s) {
            return style
        } else {
            return .automatic
        }
    }
    
    private func handleClick() {
        if let action = action {
            action()
            return
        }
        guard let clickEvent = element.attributeValue(for: "phx-click") else {
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
