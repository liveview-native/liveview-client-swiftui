//
//  ObservedElement.swift
// LiveViewNative
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
///     var body: some View {
///         Text("Value: \(element.attributeValue(for: "my-attr") ?? "<none>")")
///     }
/// }
@propertyWrapper
public struct ObservedElement {
    @Environment(\.element) private var element: ElementNode?
    @Environment(\.coordinatorEnvironment) private var coordinator: CoordinatorEnvironment?
    @StateObject private var observer = Observer()
    
    /// Creates an `ObservedElement` that observes changes to the view's element..
    public init() {
    }
    
    /// The observed element in the document, with all current data.
    public var wrappedValue: ElementNode {
        guard let element,
              let coordinator else {
            fatalError("Cannot use @ObservedElement on view that does not have an element and coordinator in the environment")
        }
        guard let element = coordinator.document[element.node.id].asElement() else {
            preconditionFailure("@ObservedElement ref turned into a non-element node, this should not be possible")
        }
        return element
    }
}

extension ObservedElement: DynamicProperty {
    public func update() {
        guard let element,
              let coordinator else {
            fatalError("Cannot use @ObservedElement on view that does not have an element and coordinator in the environment")
        }
        self.observer.update(ref: element.node.id, elementChanged: coordinator.elementChanged)
    }
}

extension ObservedElement {
    private class Observer: ObservableObject {
        private var cancellable: AnyCancellable?
        
        fileprivate func update(ref: NodeRef, elementChanged: AnyPublisher<NodeRef, Never>) {
            if cancellable == nil {
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
}
