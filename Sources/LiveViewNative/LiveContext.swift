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
    
    /// Checks whether the element has any children with the given tag.
    public func hasChild(
        of element: ElementNode,
        withTagName tagName: String,
        namespace: String? = nil
    ) -> Bool {
        element.children().contains(where: Self.elementWithName(tagName, namespace: namespace))
    }
    
    /// Builds a view representing only the children of the element which have the given tag name.
    ///
    /// This can be use to build views which have multiple types of children, such as how Menu takes content and a label:
    /// ```html
    /// <menu>
    ///     <menu:content>
    ///         <button phx-click="clicked">Hello</button>
    ///     </menu:content>
    ///     <menu:label>
    ///         My Menu
    ///     </menu:label>
    /// </menu>
    /// ```
    ///
    /// - Parameter element: The element whose children to consider.
    /// - Parameter withTagName: The name of the tag to build children from.
    /// - Parameter namespace: The namespace of the tag to build children from.
    /// - Parameter includeDefaultSlot: Whether to use all un-namespaced children if there are no children with the correct tag name and namespace.
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
                    return element.namespace != namespace
                } else {
                    return true
                }
            })
            return coordinator.builder.fromNodes(defaultSlotChildren, context: self)
        } else {
            return coordinator.builder.fromNodes(namedSlotChildren.flatMap { $0.children() }, context: self)
        }
    }
}
