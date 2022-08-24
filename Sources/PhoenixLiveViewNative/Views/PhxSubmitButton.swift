//
//  PhxSubmitButton.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 8/23/22.
//

import SwiftUI

public struct PhxSubmitButton<R: CustomRegistry>: View {
    private let element: Element
    private let context: LiveContext<R>
    private let formModel: FormModel
    private let disabled: Bool
    
    init(element: Element, context: LiveContext<R>) {
        self.element = element
        self.context = context
        self.disabled = element.hasAttr("disabled")
        if let formModel = context.formModel {
            self.formModel = formModel
        } else {
            preconditionFailure("<phx-submit-button> cannot be used outside of a <phx-form>")
        }
    }
    
    public var body: some View {
        Button {
            Task {
                try? await formModel.sendSubmitEvent()
            }
        } label: {
            context.buildChildren(of: element)
        }
        .disabled(disabled)
    }
}
