//
//  AttributeReference.swift
//
//
//  Created by Carson Katri on 10/24/23.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

/// An `attr("...")` reference in a stylesheet, or a concrete value.
///
/// The value associated with the specified attribute will be passed to the modifier.
///
/// ```elixir
/// attr("my-attr-value")
/// ```
///
/// ```html
/// <Element my-attr-value="..." />
/// ```
///
/// The attribute will be automatically decoded to the correct type using the conformance to ``AttributeDecodable``.
public struct AttributeReference<Value: ParseableModifierValue & AttributeDecodable>: ParseableModifierValue {
    enum Storage {
        case constant(Value)
        case reference(AttributeName)
        case gestureState(
            String,
            GestureStateReference.PropertyReference,
            defaultValue: Value?,
            min: CGFloat?,
            max: CGFloat?,
            scale: CGFloat,
            offset: CGFloat
        )
    }
    
    let storage: Storage
    
    public init(_ constant: Value) {
        self.storage = .constant(constant)
    }
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            Value.parser(in: context).map(Storage.constant)
            AttributeName.parser(in: context).map(Storage.reference)
            GestureStateReference.parser(in: context).map(\.value)
        }
        .map(Self.init)
    }
    
    public func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Value {
        switch storage {
        case .constant(let value):
            return value
        case .reference(let name):
            return try! element.attributeValue(Value.self, for: name)
        case let .gestureState(name, body, defaultValue, minValue, maxValue, scale, offset):
            let castValue = { (value: CGFloat) -> Value in
                var value = (value + offset) * scale
                if let minValue {
                    value = max(minValue, value)
                }
                if let maxValue {
                    value = min(maxValue, value)
                }
                switch Value.self {
                case is String.Type:
                    return String(describing: value) as! Value
                case is Double.Type:
                    return Double(value) as! Value
                default:
                    return value as! Value
                }
            }
            let defaultValue: Value = defaultValue ?? castValue(0.0)
            
            guard let value = context.gestureState.wrappedValue[name]
            else { return defaultValue }
            
            switch body.base {
            case .translation:
                guard let value = value as? DragGesture.Value,
                      let member = body.member
                else { return defaultValue }
                switch member {
                case .width:
                    return castValue(value.translation.width)
                case .height:
                    return castValue(value.translation.height)
                default:
                    return defaultValue
                }
            case .magnification:
                #if os(iOS) || os(macOS)
                if #available(iOS 17.0, macOS 14.0, *) {
                    guard let value = value as? MagnifyGesture.Value else { return defaultValue }
                    return castValue(value.magnification)
                } else {
                    return defaultValue
                }
                #else
                return defaultValue
                #endif
            case .rotation:
                #if os(iOS) || os(macOS)
                if #available(iOS 17.0, macOS 14.0, *) {
                    guard let value = value as? RotateGesture.Value else { return defaultValue }
                    switch body.member {
                    case .radians:
                        return castValue(CGFloat(value.rotation.radians))
                    case .degrees:
                        return castValue(CGFloat(value.rotation.degrees))
                    default:
                        var rotation = value.rotation
                        if let minValue {
                            rotation = .degrees(max(minValue, value.rotation.degrees))
                        }
                        if let maxValue {
                            rotation = .degrees(min(maxValue, value.rotation.degrees))
                        }
                        return rotation as! Value
                    }
                } else {
                    return defaultValue
                }
                #else
                return defaultValue
                #endif
            case .startAnchor:
                #if os(iOS) || os(macOS)
                if #available(iOS 17.0, macOS 14.0, *) {
                    if let value = value as? MagnifyGesture.Value {
                        return value.startAnchor as! Value
                    } else if let value = value as? RotateGesture.Value {
                        return value.startAnchor as! Value
                    } else {
                        return defaultValue
                    }
                } else {
                    return defaultValue
                }
                #else
                return defaultValue
                #endif
            }
        }
    }
    
    @ParseableExpression
    struct GestureStateReference {
        static var name: String { "__gesture_state__" }
        
        let value: Storage
        
        struct PropertyReference: ParseableModifierValue {
            let base: Base
            let member: Member?
            
            enum Base: String, CaseIterable {
                case translation
                
                case magnification
                
                case rotation
                
                case startAnchor
            }
            enum Member: String, CaseIterable {
                case width
                case height
                
                case radians
                case degrees
            }
            
            static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
                MemberExpression {
                    NilLiteral()
                } member: {
                    OneOf {
                        MemberExpression {
                            EnumParser<Base>()
                        } member: {
                            EnumParser<Member>()
                        }
                        .map { (base, member) in
                            Self.init(base: base, member: member)
                        }
                        EnumParser<Base>()
                            .map({ Self.init(base: $0, member: nil) })
                    }
                }
                .map(\.member)
            }
        }
        
        init(
            _ name: String,
            _ body: PropertyReference,
            defaultValue: Value? = nil,
            min: CGFloat? = nil,
            max: CGFloat? = nil,
            scale: CGFloat = 1,
            offset: CGFloat = 0
        ) {
            self.value = .gestureState(name, body, defaultValue: defaultValue, min: min, max: max, scale: scale, offset: offset)
        }
    }
    
    public func constant(default: Value) -> Value {
        switch storage {
        case .constant(let value):
            return value
        case .reference:
            return `default`
        case let .gestureState(
            _,
            _,
            defaultValue,
            _,
            _,
            _,
            _
        ):
            return defaultValue ?? `default`
        }
    }
}

extension AttributeName: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ASTNode("__attr__", in: context) {
            String.parser(in: context)
        }
        .map({ Self.init(rawValue: $1)! })
    }
}
