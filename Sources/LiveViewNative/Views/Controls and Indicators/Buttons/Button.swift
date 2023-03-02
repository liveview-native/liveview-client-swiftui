//
//  Button.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct Button<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    // used internaly by PhxSubmitButton
    private let action: (() -> Void)?
    
    @Event("phx-click", type: "click") private var click
    
    init(element: ElementNode, context: LiveContext<R>, action: (() -> Void)?) {
        self.context = context
        self.action = action
    }
    
    public var body: some View {
        SwiftUI.Button(action: self.handleClick) {
            context.buildChildren(of: element)
        }
        .applyButtonStyle(buttonStyle)
        .disabled(element.attributeValue(for: "disabled") != nil)
    }
    
    private var buttonStyle: ButtonStyle {
        if let s = element.attributeValue(for: "button-style"),
           let style = ButtonStyle(rawValue: s) {
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
        click(element.buildPhxValuePayload()) {}
    }
    
}

fileprivate enum ButtonStyle: String {
    case automatic
    case bordered
    case borderedProminent = "bordered-prominent"
    case borderless
    case plain
}

fileprivate extension View {
    @ViewBuilder
    func applyButtonStyle(_ style: ButtonStyle) -> some View {
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
