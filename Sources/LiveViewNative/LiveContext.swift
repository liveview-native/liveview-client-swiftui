//
//  LiveContext.swift
// LiveViewNative
//
//  Created by Shadowfacts on 9/12/22.
//

import SwiftUI
import LiveViewNativeCore

/// The context provides information at initialization-time to views in a LiveView.
public struct LiveContext<R: CustomRegistry> {
    /// The coordinator corresponding to the live view in which thie view is being constructed.
    public let coordinator: LiveViewCoordinator<R>
    
    /// The URL of the live view this context belongs to.
    public let url: URL
    
    // @EnvironmentObject is not suitable for FormModel because views that need the form model don't
    // necessarily want to re-render on every single change.
    /// The model of the nearest ancestor `<form>` element, or `nil` if there is no such element.
    public private(set) var formModel: FormModel?
    
    init(coordinator: LiveViewCoordinator<R>, url: URL, formModel: FormModel? = nil) {
        self.coordinator = coordinator
        self.url = url
        self.formModel = formModel
    }
    
    func with(formModel: FormModel) -> LiveContext<R> {
        var copy = self
        copy.formModel = formModel
        return copy
    }
    
    /// Builds a view representing the given element in the current context.
    ///
    /// - Note: If you're building a custom container view, make sure to use ``buildChildren(of:)``. Calling this will cause a stack overflow.
    public func buildElement(_ element: ElementNode) -> some View {
        // can't use coordinator.builder.fromElement here, as it causes an infinitely recursive type when used with custom attributes
        // so use ElementView to break the cycle
        return ElementView(element: element, context: self)
    }
    
    /// Builds a view representing the children of the current element in the current context.
    public func buildChildren(of element: ElementNode) -> some View {
        return coordinator.builder.fromNodes(element.children(), context: self)
    }
    
    private static func elementWithName(
        _ tagName: String,
        namespace: String?
    ) -> (NodeChildrenSequence.Element) -> Bool {
        { child in
            if case let .element(element) = child.data,
               element.namespace == namespace,
               element.tag == tagName
            {
                return true
            } else {
                return false
            }
        }
    }
    
    public func hasChild(
        of element: ElementNode,
        withTagName tagName: String,
        namespace: String? = nil
    ) -> Bool {
        element.children().contains(where: Self.elementWithName(tagName, namespace: namespace))
    }
    
    public func buildChildren(
        of element: ElementNode,
        withTagName tagName: String,
        namespace: String? = nil,
        includeDefaultSlot: Bool = false
    ) -> some View {
        let children = element.children()
        let namedSlotChildren = children.filter(Self.elementWithName(tagName, namespace: namespace))
        if namedSlotChildren.isEmpty && includeDefaultSlot {
            let defaultSlotChildren = children.filter({
                if case let .element(element) = $0.data {
                    return element.namespace != tagName
                } else {
                    return true
                }
            })
            return ForEach(defaultSlotChildren.map({ ($0.id, $0.children()) }), id: \.0) { subChildren in
                coordinator.builder.fromNodes(subChildren.1, context: self)
            }
        } else {
            return ForEach(namedSlotChildren.map({ ($0.id, $0.children()) }), id: \.0) { subChildren in
                coordinator.builder.fromNodes(subChildren.1, context: self)
            }
        }
    }
}
