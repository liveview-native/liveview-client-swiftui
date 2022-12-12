//
//  PhxForm.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct PhxForm<R: CustomRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    @EnvironmentObject private var liveViewModel: LiveViewModel<R>
    
    private var model: FormModel {
        guard let id = element.attributeValue(for: "id") else {
            preconditionFailure("<form> must have an id")
        }
        return liveViewModel.getForm(elementID: id)
    }
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        context.with(formModel: model).buildChildren(of: element)
            .environment(\.formModel, model)
        // TODO: element is not equatable, so we can't use onChange, the FormModel itself should handle updating values when the document changes
        // actually now the element is observed by this view, but not changes to its children
        // really the children should use @FormState and handle updating their own values, either backed by the FormModel or stored by the view
//            .onChange(of: element, perform: { newValue in
//                model.updateFromElement(newValue)
//            })
            .onAppear {
                model.pushEventImpl = context.coordinator.pushEvent
                model.updateFromElement(element)
            }
    }
    
}
