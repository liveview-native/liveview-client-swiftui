//
//  LiveContext.swift
// LiveViewNative
//
//  Created by Shadowfacts on 9/12/22.
//

import SwiftUI
import LiveViewNativeCore

/// The context provides additional information to elements within a live view.
///
/// This property wrapper uses the SwiftUI environment to provide the context information, so you do not initialize it yourself.
///
/// ```swift
/// struct MyElement<R: RootRegistry>: View {
///     @LiveContext<R> var context
///     var body: some View {
///         Text("My URL is \(context.url)")
///     }
/// }
/// ```
@propertyWrapper
public struct LiveContext<R: RootRegistry>: DynamicProperty {
    @Environment(\.anyLiveContextStorage) private var anyStorage
    var storage: LiveContextStorage<R> {
        anyStorage as! LiveContextStorage<R>
    }
    
    /// The coordinator corresponding to the live view in which thie view is being constructed.
    public var coordinator: LiveViewCoordinator<R> {
        storage.coordinator
    }
    
    /// The URL of the live view this context belongs to.
    public var url: URL {
        storage.url
    }
    
    public var wrappedValue: Self {
        self
    }
    
    public init() {
    }
    
    /// Builds a view representing the given element in the current context.
    ///
    /// - Note: If you're building a custom container view, make sure to use ``buildChildren(of:)``. Calling this will cause a stack overflow.
    public func buildElement(_ element: ElementNode) -> some View {
        // can't use coordinator.builder.fromElement here, as it causes an infinitely recursive type when used with custom attributes
        // so use ElementView to break the cycle
        return ElementView(element: element, context: storage)
    }
    
    /// Builds a view representing the children of the current element in the current context.
    public func buildChildren(of element: ElementNode) -> some View {
        return coordinator.builder.fromNodes(element.children(), context: storage)
    }
    
    private static func elementWithName(
        _ tagName: String,
        id: String
    ) -> (NodeChildrenSequence.Element) -> Bool {
        { child in
            if case let .element(element) = child.data,
               element.attributes.first(where: { $0.name == "id" })?.value == id,
               element.tag == tagName
            {
                return true
            } else {
                return false
            }
        }
    }
    
    /// Checks whether the element has any children with the given tag.
    public func hasTemplate(
        of element: ElementNode,
        withID id: String
    ) -> Bool {
        element.children().contains(where: Self.elementWithName("template", id: id))
    }
    
    /// Builds a view representing only the children of the element which have the given tag name.
    ///
    /// This can be use to build views which have multiple types of children, such as how Menu takes content and a label:
    /// ```html
    /// <menu>
    ///     <template id={:content}>
    ///         <button phx-click="clicked">Hello</button>
    ///     </template>
    ///     <template id={:label}>
    ///         My Menu
    ///     </template>
    /// </menu>
    /// ```
    ///
    /// - Parameter element: The element whose children to consider.
    /// - Parameter id: The ID of the `<template>` containing the children.
    /// - Parameter includeDefaultSlot: Whether to use all other children if there is no `<template>` with the correct id.
    public func buildChildren(
        of element: ElementNode,
        withID id: String,
        includeDefaultSlot: Bool = false
    ) -> some View {
        let children = element.children()
        let namedSlotChildren = children.filter(Self.elementWithName("template", id: id))
        if namedSlotChildren.isEmpty && includeDefaultSlot {
            let defaultSlotChildren = children.filter({
                if case let .element(element) = $0.data {
                    return element.tag != "template"
                } else {
                    return true
                }
            })
            return coordinator.builder.fromNodes(defaultSlotChildren, context: storage)
        } else {
            return coordinator.builder.fromNodes(namedSlotChildren.flatMap { $0.children() }, context: storage)
        }
    }
    
    func children(
        of element: ElementNode,
        withTagName tagName: String,
        namespace: String? = nil
    ) -> [Node] {
        element.children().filter(Self.elementWithName(tagName, namespace: namespace))
    }
}

struct LiveContextStorage<R: RootRegistry> {
    let coordinator: LiveViewCoordinator<R>
    let url: URL
}
