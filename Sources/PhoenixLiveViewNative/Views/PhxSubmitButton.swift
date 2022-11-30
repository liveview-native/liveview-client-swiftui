//
//  PhxSubmitButton.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 8/23/22.
//

import SwiftUI

struct PhxSubmitButton<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    private let formModel: FormModel
    
    init(element: ElementNode, context: LiveContext<R>) {
        self._element = ObservedElement(element: element, context: context)
        self.context = context
        if let formModel = context.formModel {
            self.formModel = formModel
        } else {
            preconditionFailure("<phx-submit-button> cannot be used outside of a <phx-form>")
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
        switch element.attributeValue(for: "after-submit") {
        case "clear":
            formModel.clear()
        default:
            return
        }
    }
}
