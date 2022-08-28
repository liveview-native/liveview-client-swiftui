//
//  PhxSubmitButton.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 8/23/22.
//

import SwiftUI

/// `<phx-submit-button>`, special button that triggers submission of the form it's contained in when pressed.
public struct PhxSubmitButton<R: CustomRegistry>: View {
    private let element: Element
    private let context: LiveContext<R>
    private let formModel: FormModel
    private let disabled: Bool
    private let afterSubmit: AfterSubmitAction
    
    init(element: Element, context: LiveContext<R>) {
        self.element = element
        self.context = context
        self.disabled = element.hasAttr("disabled")
        if let formModel = context.formModel {
            self.formModel = formModel
        } else {
            preconditionFailure("<phx-submit-button> cannot be used outside of a <phx-form>")
        }
        if let s = element.attrIfPresent("after-submit"), let action = AfterSubmitAction(rawValue: s) {
            self.afterSubmit = action
        } else {
            self.afterSubmit = .none
        }
    }
    
    public var body: some View {
        Button {
            Task {
                do {
                    try await formModel.sendSubmitEvent()
                    doAfterSubmitAction()
                } catch {
                    // todo: error handling
                }
            }
        } label: {
            context.buildChildren(of: element)
        }
        .disabled(disabled)
    }
    
    private func doAfterSubmitAction() {
        switch afterSubmit {
        case .none:
            return
        case .clear:
            formModel.clear()
        }
    }
    
    enum AfterSubmitAction: String {
        case none
        case clear
    }
}
