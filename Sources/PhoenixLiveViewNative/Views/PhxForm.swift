//
//  PhxForm.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct PhxForm<R: CustomRegistry>: View {
    private let element: ElementNode
    private let context: LiveContext<R>
    private let id: String
    
    @EnvironmentObject private var liveViewModel: LiveViewModel<R>
    
    private var model: FormModel {
        liveViewModel.getForm(elementID: id)
    }
    
    init(element: ElementNode, context: LiveContext<R>) {
        guard let id = element.attributeValue(for: "id") else {
            preconditionFailure("<form> must have an id")
        }
        self.element = element
        self.context = context
        self.id = id
    }
    
    public var body: some View {
        context.with(formModel: model).buildChildren(of: element)
            .environment(\.formModel, model)
        // TODO: element is not equatable, so we can't use onChange, the FormModel itself should handle updating values when the document changes
//            .onChange(of: element, perform: { newValue in
//                model.updateFromElement(newValue)
//            })
            .onAppear {
                model.pushEventImpl = context.coordinator.pushEvent
                model.updateFromElement(element)
            }
    }
    
}
