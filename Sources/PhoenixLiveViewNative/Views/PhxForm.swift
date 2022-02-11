//
//  PhxForm.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import SwiftSoup

struct PhxForm: View {
    private let element: Element
    private let coordinator: LiveViewCoordinator
    private let id: String
    
    @EnvironmentObject private var liveViewModel: LiveViewModel
    
    private var model: FormModel {
        liveViewModel.getForm(elementID: id)
    }
    
    init(element: Element, coordinator: LiveViewCoordinator) {
        precondition(element.hasAttr("id"), "<form> must have an id")
        self.element = element
        self.coordinator = coordinator
        self.id = try! element.attr("id")
    }
    
    var body: some View {
        ViewTreeBuilder.fromElements(element.children(), context: .init(coordinator: coordinator, formModel: model))
            .onChange(of: element, perform: { newValue in
                model.updateFromElement(newValue)
            })
            .onAppear {
                model.coordinator = coordinator
                model.changeEvent = element.attrIfPresent("phx-change")
                model.updateFromElement(element)
            }
    }
    
}
