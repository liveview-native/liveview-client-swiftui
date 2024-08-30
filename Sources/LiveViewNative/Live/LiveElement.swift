//
//  LiveElement.swift
//
//
//  Created by Carson Katri on 4/2/24.
//

import SwiftUI
import LiveViewNativeCore

/// Describes a View that is used as an element in a LiveView Native template.
///
/// Any properties of the ``SwiftUI/View`` will be decoded from element attributes.
///
/// - Precondition: A generic argument named `Root` conforming to ``RootRegistry`` must be included on the struct.
/// - Precondition: All properties should have a default value, or be marked optional.
///
/// ```swift
/// @LiveElement
/// struct MyTag<Root: RootRegistry>: View {
///     private var label: String?
///     private var count: Int = 0
///
///     var body: some View {
///         Text(label ?? "")
///         Text("Value: \(count)")
///     }
/// }
/// ```
///
/// ```html
/// <MyTag label="Cookies" count="3" />
/// ```
///
/// By default, the property name is used verbatim as the attribute name.
/// Use the ``LiveAttribute(_:)`` macro to customize the name of an attribute.
///
/// Use the ``LiveElementIgnored()`` macro to disable decoding of a property.
/// This is useful when interfacing with SwiftUI property wrappers, such as ``SwiftUI/State`` and ``SwiftUI/Environment``.
@attached(member, names: named(liveElement), named(_TrackedContent))
@attached(memberAttribute)
public macro LiveElement() = #externalMacro(module: "LiveViewNativeMacros", type: "LiveElementMacro")

/// Marks a property as an attribute on a ``LiveElement()``.
///
/// By default, the property name is used verbatim as the attribute name.
/// Provide the `name` argument to customize the namespace/name of the attribute.
///
/// ```swift
/// @LiveAttribute(.init(namespace: "item", name: "count"))
/// private var count: Int = 0
/// ```
///
/// ```html
/// <MyTag item:count="3" />
/// ```
@attached(accessor, names: named(get))
public macro LiveAttribute(_ name: AttributeName? = nil) = #externalMacro(module: "LiveViewNativeMacros", type: "LiveAttributeMacro")

/// Disables attribute decoding for a property on a ``LiveElement()``.
///
/// By default, all properties are treated as attributes by ``LiveElement()``.
/// This macro disables attribute decoding for a property.
///
/// This can used with SwiftUI property wrappers, such as ``SwiftUI/State`` and ``SwiftUI/Environment``,
/// which should only be handled client-side.
///
/// ```swift
/// @LiveElementIgnored
/// @State private var isExpanded = false
/// ```
@attached(accessor, names: named(willSet))
public macro LiveElementIgnored() = #externalMacro(module: "LiveViewNativeMacros", type: "LiveElementIgnoredMacro")

public protocol _LiveElementTrackedContent {
    init()
    init(from element: ElementNode) throws
}

@propertyWrapper public struct _LiveElementTracked<R: RootRegistry, T: _LiveElementTrackedContent>: DynamicProperty {
    /// The ``ElementNode`` used to build a live element.
    @ObservedElement public var element
    /// The ``LiveContext`` for a live element.
    @LiveContext<R> public var context
    
    public var wrappedValue: T
    
    public var projectedValue: Self {
        self
    }
    
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
    
    public init(wrappedValue: T? = nil, element: ElementNode) {
        self._element = .init(element: element)
        self.wrappedValue = wrappedValue ?? (try? T.init(from: element)) ?? T.init()
    }
    
    public mutating func update() {
        self.wrappedValue = try! T.init(from: element)
    }
    
    var isConstant: Bool {
        _element.isConstant
    }
}

public extension _LiveElementTracked {
    /// Builds all child elements into a View hierarchy.
    ///
    /// By default, elements with a `template` are filtered out.
    /// You can provide a custom `predicate` to filter different elements.
    ///
    /// - Parameter predicate: The filter used to select child nodes for render.
    func children(_ predicate: (Node) -> Bool = { node in
        !node.attributes.contains(where: { $0.name.namespace == nil && $0.name.name == "template" })
    }) -> some View {
        context.coordinator.builder.fromNodes(_element.children.filter(predicate), context: context.storage)
    }
    
    /// Builds all children with a given `template` attribute.
    ///
    /// - Parameter template: The ``Template`` used to filter child elements. A String literal can be provided for simple template values.
    /// - Parameter includeDefault: Whether elements without a `template` attribute should be included in the filter. Defaults to `false`.
    func children(in template: Template, default includeDefault: Bool = false) -> some View {
        context.coordinator.builder.fromNodes(childNodes(in: template, default: includeDefault), context: context.storage)
    }
    
    /// Check whether one or more children have a matching `template` attribute.
    ///
    /// - Parameter template: The ``Template`` used to filter child elements. A String literal can be provided for simple template values.
    /// - Parameter includeDefault: Whether elements without a `template` attribute should be included in the filter. Defaults to `false`.
    func hasTemplate(_ template: Template, default includeDefault: Bool = false) -> Bool {
        _element.children.contains(where: {
            for attribute in $0.attributes {
                if attribute == template {
                    return true
                } else if includeDefault && attribute.name.namespace == nil && attribute.name.name == "template" {
                    return false
                }
            }
            return includeDefault
        })
    }
    
    func hasTemplate(_ name: String, value: String) -> Bool {
        hasTemplate(.init(name, value: value))
    }
    
    /// Array containing children of the ``ElementNode``.
    var childNodes: [LiveViewNativeCore.Node] {
        _element.children
    }
    
    var defaultChildren: [LiveViewNativeCore.Node] {
        _element.defaultChildren
    }
    
    var templateChildNodes: [Template:[LiveViewNativeCore.Node]] {
        _element.templateChildren
    }
    
    func childNodes(in template: Template, default includeDefault: Bool = false) -> [LiveViewNativeCore.Node] {
        if includeDefault {
            return defaultChildren + (_element.templateChildren[template] ?? [])
        } else {
            return _element.templateChildren[template] ?? []
        }
    }
}

/// A value passed to the `template` attribute, used for filtering children.
///
/// A string literal can be used to create a simple template.
///
/// ```swift
/// $liveElement.children(in: "label")
/// ```
///
/// ```html
/// <Element template="label" />
/// ```
///
/// When a `value` is passed, the `template` attribute should match the scheme `name.value`.
///
/// ```swift
/// $liveElement.children(in: Template("phase", value: "success"))
/// ```
///
/// ```html
/// <Element template="phase.success" />
/// ```
public struct Template: Hashable, RawRepresentable, ExpressibleByStringLiteral {
    let name: String
    let value: String?
    
    public init(_ name: String, value: String? = nil) {
        self.name = name
        self.value = value
    }
    
    public init(rawValue: String) {
        var components = rawValue.split(separator: "." as Character)
        self.name = String(components.removeFirst())
        self.value = components.isEmpty ? nil : components.joined(separator: ".")
    }
    
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
    
    public var rawValue: String {
        if let value {
            return "\(name).\(value)"
        } else {
            return name
        }
    }
    
    static func == (_ lhs: LiveViewNativeCore.Attribute, _ rhs: Self) -> Bool {
        lhs.name.namespace == nil
            && lhs.name.name == "template"
            && lhs.value == rhs.rawValue
    }
}
