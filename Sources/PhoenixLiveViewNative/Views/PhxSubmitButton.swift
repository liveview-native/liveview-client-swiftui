//
//  PhxSubmitButton.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 8/23/22.
//

import SwiftUI

struct PhxSubmitButton<R: CustomRegistry>: View {
    private let element: Element
    private let context: LiveContext<R>
    private let formModel: FormModel
    private let afterSubmit: AfterSubmitAction
    
    init(element: Element, context: LiveContext<R>) {
        self.element = element
        self.context = context
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
        PhxButton(element: element, context: context) {
            Task {
                do {
                    try await formModel.sendSubmitEvent()
                    doAfterSubmitAction()
                } catch {
                    // todo: error handling
                }
            }
        }
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
