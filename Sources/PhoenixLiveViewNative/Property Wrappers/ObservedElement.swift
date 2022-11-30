//
//  ObservedElement.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 11/30/22.
//

import SwiftUI
import LiveViewNativeCore
import Combine

@propertyWrapper
struct ObservedElement {
    private let ref: NodeRef
    private let document: Document
    @StateObject private var observer: Observer
    
    init(element: ElementNode, context: LiveContext<some CustomRegistry>) {
        let ref = element.node.id
        self.ref = ref
        guard let document = context.coordinator.document else {
            preconditionFailure("Coordinator must have document when creating @ObservedElement")
        }
        self.document = document
        self._observer = StateObject(wrappedValue: Observer(ref: ref, elementChanged: context.coordinator.elementChanged))
    }
    
    var wrappedValue: ElementNode {
        guard let element = document[ref].asElement() else {
            preconditionFailure("@ObservedElement ref turned into a non-element node, this should not be possible")
        }
        return element
    }
    
    class Observer: ObservableObject {
        private var cancellable: AnyCancellable?
        
        init(ref: NodeRef, elementChanged: PassthroughSubject<NodeRef, Never>) {
            cancellable = elementChanged
                .filter {
                    $0 == ref
                }
                .sink { [unowned self] _ in
                    self.objectWillChange.send()
                }
        }
    }
}

// we don't actually have anything to update, since everything is initialized when the Observer is constructed
// we just need to implement DynamicProperty, otherwise SwiftUI never "installs" this property wrapper in a view
// and never sets up the @StateObject
extension ObservedElement: DynamicProperty {
}
