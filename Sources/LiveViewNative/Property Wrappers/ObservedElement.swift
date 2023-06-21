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
/// The element that is observed is the nearest parent from the view in which this property wrapper is used.
/// So, if an element `<outer>` maps to a view `Outer` which contains another view `Inner` that uses this property wrapper, the observed element will be the `<outer>`.
///
/// When an element is changed as a result of a LiveView update, the coordinator will notify all relevant views.
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
///     @ObservedElement private var element: ElementNode
///
///     var body: some View {
///         Text("Value: \(element.attributeValue(for: "my-attr") ?? "<none>")")
///     }
/// }
/// ```
///
/// ## Handling Arbitrary Changes
/// If you need to run code, rather than only triggering a SwiftUI view update, whenever an element changes (subject to the restrictions above), use SwiftUI's `onReceive` view modifier in conjunction with the projected value of this property wrapper:
/// ```swift
/// struct MyView: View {
///     @ObservedElement private var element: ElementNode
///
///     var body: some View {
///         Text("Hello")
///             .onReceive($element) {
///                 print("Element changed!")
///             }
///     }
/// }
/// ```
@propertyWrapper
public struct ObservedElement {
    @Environment(\.element.nodeRef) private var nodeRef: NodeRef?
    @Environment(\.coordinatorEnvironment) private var coordinator: CoordinatorEnvironment?
    @StateObject private var observer: Observer
    
    private let overrideElement: ElementNode?
    
    /// Creates an `ObservedElement` that observes changes to the view's element.
    public init(observeChildren: Bool = false) {
        self.overrideElement = nil
        self._observer = .init(wrappedValue: .init(observeChildren: observeChildren))
    }
    
    public init(element: ElementNode, observeChildren: Bool = false) {
        self.overrideElement = element
        self._observer = .init(wrappedValue: .init(observeChildren: observeChildren))
    }
    
    public init() {
        self.overrideElement = nil
        self._observer = .init(wrappedValue: .init(observeChildren: false))
    }
    
    /// The observed element in the document, with all current data.
    public var wrappedValue: ElementNode {
        if let overrideElement {
            return overrideElement
        }
        
        guard let nodeRef,
              let coordinator else {
            fatalError("Cannot use @ObservedElement on view that does not have an element and coordinator in the environment")
        }
        guard let element = coordinator.document[nodeRef].asElement() else {
            preconditionFailure("@ObservedElement ref turned into a non-element node, this should not be possible")
        }
        return element
    }
    
    /// A publisher that publishes when the observed element changes.
    public var projectedValue: some Publisher<Void, Never> {
        observer.objectWillChange
    }
}

extension ObservedElement: DynamicProperty {
    public func update() {
        guard let nodeRef,
              let coordinator else {
            fatalError("Cannot use @ObservedElement on view that does not have an element and coordinator in the environment")
        }
        self.observer.update(ref: nodeRef, children: coordinator.document[nodeRef].children().map(\.id), elementChanged: coordinator.elementChanged)
    }
}

extension ObservedElement {
    private class Observer: ObservableObject {
        private var cancellable: AnyCancellable?
        private var observeChildren = false
        
        init(observeChildren: Bool) {
            self.observeChildren = observeChildren
        }
        
        fileprivate func update(ref: NodeRef, children: [NodeRef], elementChanged: AnyPublisher<NodeRef, Never>) {
            if cancellable == nil {
                cancellable = elementChanged
                    .filter { [weak self] in
                        if $0 == ref {
                            return true
                        } else if self?.observeChildren == true {
                            return children.contains($0)
                        } else {
                            return false
                        }
                    }
                    .sink { [unowned self] _ in
                        self.objectWillChange.send()
                    }
            }
        }
    }
}

private extension Optional where Wrapped == ElementNode {
    var nodeRef: NodeRef? {
        self?.node.id
    }
}
