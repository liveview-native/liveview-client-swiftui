//
//  ObservedElement.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 11/30/22.
//

import SwiftUI
import LiveViewNativeCore
import Combine

/// A property wrapper that observes changes to an element in the coordinator's document.
///
/// When an element is changed as a result of a LiveView update, the coordinator will notify all changed elements.
/// Any SwiftUI views using `@ObservedElement` will be updated automatically when the observed element changes.
///
/// The following changes are observed:
/// 1. Changes to the element's attributes.
/// 2. Changes to text nodes that are immediate children of the element.
/// 3. Additions and removals of immediate child elements.
///
/// Note that, in order to keep SwiftUI view updates minimal, an element is _not_ notified of changes to nested elements.
///
/// ## Example
/// ```swift
/// struct MyView: View {
///     @ObservedElemenet private var element: ElementNode
///
///     init(element: ElementNode, context: LiveContext<some CustomRegistry>) {
///         self._element = ObservedElement(element: element, context: context)
///     }
///
///     var body: some View {
///         Text("Value: \(element.attributeValue(for: "my-attr") ?? "<none>")")
///     }
/// }
@propertyWrapper
public struct ObservedElement {
    private let ref: NodeRef
    private let document: Document
    @StateObject private var observer: Observer
    
    /// Creates an `ObservedElement` that observes changes to the given element.
    public init(element: ElementNode, context: LiveContext<some CustomRegistry>) {
        let ref = element.node.id
        self.ref = ref
        guard let document = context.coordinator.document else {
            preconditionFailure("Coordinator must have document when creating @ObservedElement")
        }
        self.document = document
        self._observer = StateObject(wrappedValue: Observer(ref: ref, elementChanged: context.coordinator.elementChanged))
    }
    
    /// The observed element in the document, with all current data.
    public var wrappedValue: ElementNode {
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
