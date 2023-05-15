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
    ///
    /// Ignores any children with a `template` attribute.
    public func buildChildren(of element: ElementNode) -> some View {
        return coordinator.builder.fromNodes(element.children().filter({
            if case let .element(element) = $0.data {
                return !element.attributes.contains(where: { $0.name == "template" })
            } else {
                return true
            }
        }), context: storage)
    }
    
    private static func isTemplateElement(
        _ template: String
    ) -> (NodeChildrenSequence.Element) -> Bool {
        { child in
            if case let .element(element) = child.data,
               element.attributes.first(where: { $0.name == "template" })?.value == template
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
        withName name: String
    ) -> Bool {
        element.children().contains(where: Self.isTemplateElement(name))
    }
    
    /// Builds a view representing only the children of the element which have the given template attribute.
    ///
    /// This can be use to build views which have multiple types of children, such as how ``Menu`` takes content and a label:
    /// ```html
    /// <Menu>
    ///     <Group template={:label}>
    ///         My Menu
    ///     </Group>
    ///     <Button template={:content} phx-click="clicked">Hello</Button>
    /// </Menu>
    /// ```
    ///
    /// - Parameter element: The element whose children to consider.
    /// - Parameter template: The name of the attribute to access.
    /// - Parameter includeDefaultSlot: Whether to use all other children if there are no elements with the correct template.
    public func buildChildren(
        of element: ElementNode,
        forTemplate template: String,
        includeDefaultSlot: Bool = false
    ) -> some View {
        let children = element.children()
        let namedSlotChildren = children.filter(Self.isTemplateElement(template))
        if namedSlotChildren.isEmpty && includeDefaultSlot {
            let defaultSlotChildren = children.filter({
                if case let .element(element) = $0.data {
                    return !element.attributes.contains(where: {
                        $0.name.rawValue == "template"
                    })
                } else {
                    return true
                }
            })
            return coordinator.builder.fromNodes(defaultSlotChildren, context: storage)
        } else {
            return coordinator.builder.fromNodes(namedSlotChildren, context: storage)
        }
    }
    
    /// Get the children of an element with the correct template attribute.
    func children(
        of element: ElementNode,
        forTemplate template: String
    ) -> [NodeChildrenSequence.Element] {
        element.children().filter(Self.isTemplateElement(template))
    }
}

struct LiveContextStorage<R: RootRegistry> {
    let coordinator: LiveViewCoordinator<R>
    let url: URL
}
