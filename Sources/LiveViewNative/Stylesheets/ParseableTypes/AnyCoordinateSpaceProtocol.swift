//
//  AnyCoordinateSpaceProtocol.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension AnyCoordinateSpaceProtocol: CoordinateSpaceProtocol {}

struct AnyCoordinateSpaceProtocol: ParseableModifierValue {
    let coordinateSpace: CoordinateSpace
    
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    init(_ space: some CoordinateSpaceProtocol) {
        self.coordinateSpace = space.coordinateSpace
    }
    
    init(coordinateSpace: CoordinateSpace) {
        self.coordinateSpace = coordinateSpace
    }
    
    static let local = Self.init(coordinateSpace: .local)
    static let global = Self.init(coordinateSpace: .global)
    
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            return ImplicitStaticMember {
                OneOf {
                    "scrollView".utf8.map({ Self.init(.scrollView) })
                    ScrollView.parser(in: context).map({ Self.init(.scrollView(axis: $0.axis)) })
                    Named.parser(in: context).map({ Self.init(.named($0.name)) })
                    "local".utf8.map({ Self.init(.local) })
                    "global".utf8.map({ Self.init(.global) })
                }
            }.eraseToAnyParser()
        } else {
            return ImplicitStaticMember {
                OneOf {
                    Named.parser(in: context).map({ Self.init(coordinateSpace: .named(AnyHashable($0.name))) })
                    "local".utf8.map({ Self.init(coordinateSpace: .local) })
                    "global".utf8.map({ Self.init(coordinateSpace: .global) })
                }
            }.eraseToAnyParser()
        }
    }
    
    @ParseableExpression
    struct ScrollView {
        static let name = "scrollView"
        
        let axis: Axis
        
        init(axis: Axis) {
            self.axis = axis
        }
    }
    
    @ParseableExpression
    struct Named {
        static let name = "named"
        
        let name: String
        
        init(_ name: String) {
            self.name = name
        }
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension NamedCoordinateSpace: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            AnyCoordinateSpaceProtocol.Named.parser(in: context).map({ Self.named($0.name) })
        }
    }
}