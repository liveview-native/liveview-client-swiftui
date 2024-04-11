//
//  LiveElement.swift
//
//
//  Created by Carson Katri on 4/2/24.
//

import SwiftUI
import LiveViewNativeCore

@attached(member, names: named(liveElement), named(_TrackedContent))
@attached(memberAttribute)
public macro LiveElement() = #externalMacro(module: "LiveViewNativeMacros", type: "LiveElementMacro")

@attached(accessor, names: named(get))
public macro LiveAttribute(_ name: AttributeName? = nil) = #externalMacro(module: "LiveViewNativeMacros", type: "LiveAttributeMacro")

@attached(accessor, names: named(willSet))
public macro LiveElementIgnored() = #externalMacro(module: "LiveViewNativeMacros", type: "LiveElementIgnoredMacro")

public protocol _LiveElementTrackedContent {
    init()
    init(from element: ElementNode) throws
}

@propertyWrapper public struct _LiveElementTracked<R: RootRegistry, T: _LiveElementTrackedContent>: DynamicProperty {
    @ObservedElement public var element
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
    func children(_ predicate: (Node) -> Bool = { node in
        !node.attributes.contains(where: { $0.name.namespace == nil && $0.name.name == "template" })
    }) -> some View {
        context.coordinator.builder.fromNodes(_element.children.filter(predicate), context: context.storage)
    }
    
    func children(in template: Template, default includeDefault: Bool = false) -> some View {
        children {
            $0.attributes.contains(where: {
                $0 == template
            }) || (includeDefault && !$0.attributes.contains(where: { $0.name.namespace == nil && $0.name.name == "template" }))
        }
    }
    
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
    
    var childNodes: [LiveViewNativeCore.Node] {
        _element.children
    }
}

public struct Template: RawRepresentable, ExpressibleByStringLiteral {
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
