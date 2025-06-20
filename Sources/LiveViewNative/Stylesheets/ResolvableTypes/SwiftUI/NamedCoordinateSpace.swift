//
//  NamedCoordinateSpace.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
extension NamedCoordinateSpace {
    @ASTDecodable("NamedCoordinateSpace")
    public enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(NamedCoordinateSpace)
        
        case named(AttributeReference<String>)
        case scrollView
        
        case _scrollView(axis: AttributeReference<Axis.Resolvable>)
        static func scrollView(axis: AttributeReference<Axis.Resolvable>) -> Self {
            ._scrollView(axis: axis)
        }
    }
}

extension Axis.Resolvable: @preconcurrency AttributeDecodable {
    public init(from attribute: Attribute?, on element: ElementNode) throws {
        self = .__constant(try Axis(from: attribute, on: element))
    }
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
public extension NamedCoordinateSpace.Resolvable {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> NamedCoordinateSpace {
        switch self {
        case let .__constant(value):
            return value
        case let .named(name):
            return .named(name.resolve(on: element, in: context))
        case .scrollView:
            return .scrollView
        case let ._scrollView(axis):
            return .scrollView(axis: axis.resolve(on: element, in: context).resolve(on: element, in: context))
        }
    }
}

enum StylesheetResolvableCoordinateSpaceProtocol: StylesheetResolvable, AttributeDecodable, @preconcurrency Decodable {
    case local
    
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> CoordinateSpace {
        switch self {
        case .local:
            return .local
        }
    }
}
