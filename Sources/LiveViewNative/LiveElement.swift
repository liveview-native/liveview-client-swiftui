//
//  LiveElement.swift
//
//
//  Created by Carson Katri on 4/2/24.
//

import SwiftUI
import LiveViewNativeCore

@attached(member, names: named(_$element), named(_TrackedContent))
@attached(memberAttribute)
@attached(extension, conformances: View)
public macro LiveElement() = #externalMacro(module: "LiveViewNativeMacros", type: "LiveElementMacro")

@attached(accessor, names: named(get))
public macro LiveAttribute(_ name: AttributeName? = nil) = #externalMacro(module: "LiveViewNativeMacros", type: "LiveAttributeMacro")

@attached(accessor, names: named(willSet))
public macro LiveElementIgnored() = #externalMacro(module: "LiveViewNativeMacros", type: "LiveElementIgnoredMacro")

public protocol _LiveElementTrackedContent {
    init(from element: ElementNode) throws
}

@propertyWrapper public struct _LiveElementTracked<T: _LiveElementTrackedContent>: DynamicProperty {
    @ObservedElement public var element
    
    public var wrappedValue: T
    
    public var projectedValue: ElementNode {
        element
    }
    
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
    
    public init(wrappedValue: T, element: ElementNode) {
        self._element = .init(element: element)
        self.wrappedValue = wrappedValue
    }
    
    public mutating func update() {
        self.wrappedValue = try! T.init(from: element)
    }
}
