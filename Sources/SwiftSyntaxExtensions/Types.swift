//
//  Types.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/29/25.
//

import SwiftSyntax

public extension TypeSyntaxProtocol {
    /// Validates if this type can be used in a decodable modifier.
    var isValidModifierType: Bool {
        // closures with parameters are not supported
        if let functionType = self.as(FunctionTypeSyntax.self) {
            guard functionType.parameters.isEmpty
            else { return false }
        }
        if let attributedType = self.as(AttributedTypeSyntax.self),
           let functionType = attributedType.baseType.as(FunctionTypeSyntax.self)
        {
            guard functionType.parameters.isEmpty
            else { return false }
        }
        if let attributedType = self.as(AttributedTypeSyntax.self),
           let tupleType = attributedType.baseType.as(TupleTypeSyntax.self),
           tupleType.elements.count == 1,
           let functionType = tupleType.elements.first!.type.as(FunctionTypeSyntax.self)
        {
            guard functionType.parameters.isEmpty
            else { return false }
        }
        
        // Tuple types can't be encoded/decoded automatically.
        if self.is(TupleTypeSyntax.self) {
            return false
        }
        
        // metatype parameters (T.Type, (some Decodable).Type)
        if self.is(MetatypeTypeSyntax.self) {
            return false
        }
        
        // generic arguments must be valid (A<B, C>)
        if let identifierType = self.as(IdentifierTypeSyntax.self),
           !(identifierType.genericArgumentClause?.arguments.allSatisfy(\.argument.isValidModifierType) ?? true)
        {
            return false
        }
        if let memberType = self.as(MemberTypeSyntax.self),
           !(memberType.genericArgumentClause?.arguments.allSatisfy(\.argument.isValidModifierType) ?? true)
        {
            return false
        }
        
        // underscored types are not allowed
        if let identifierType = self.as(IdentifierTypeSyntax.self),
           identifierType.name.text.starts(with: "_")
        {
            return false
        }
        if let memberType = self.as(MemberTypeSyntax.self),
           memberType.name.text.starts(with: "_")
        {
            return false
        }
        
        // SwiftUICore.Binding is not allowed
        if let memberType = self.as(MemberTypeSyntax.self),
           memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "SwiftUICore",
           memberType.name.text == "Binding"
        {
            return false
        }
        
        // SwiftUI.FocusState<T>.Binding is not allowed
        if let memberType = self.as(MemberTypeSyntax.self),
           memberType.baseType.as(MemberTypeSyntax.self)?.name.text == "FocusState",
           memberType.name.text == "Binding"
        {
            return false
        }
        
        // SwiftUI.AccessibilityFocusState<T>.Binding is not allowed
        if let memberType = self.as(MemberTypeSyntax.self),
           memberType.baseType.as(MemberTypeSyntax.self)?.name.text == "AccessibilityFocusState",
           memberType.name.text == "Binding"
        {
            return false
        }
        
        // Swift.Optional<() -> ()> with a function wrapped type is not allowed
        if let memberType = self.as(MemberTypeSyntax.self),
           memberType.baseType.as(MemberTypeSyntax.self)?.name.text == "Swift",
           memberType.name.text == "Optional",
           memberType.genericArgumentClause?.arguments.first?.argument.as(FunctionDeclSyntax.self) != nil
        {
            return false
        }
        
        // Decoder is not allowed
        if let memberType = self.as(MemberTypeSyntax.self),
           memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "Swift",
           memberType.name.text == "Decoder"
        {
            return false
        }
        
        // StaticString is not allowed
        if let memberType = self.as(MemberTypeSyntax.self),
           memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "Swift",
           memberType.name.text == "StaticString"
        {
            return false
        }
        
        // Swift.String.Index is not allowed
        if let memberType = self.as(MemberTypeSyntax.self),
           memberType.baseType.as(MemberTypeSyntax.self)?.name.text == "String",
           memberType.name.text == "Index"
        {
            return false
        }
        
        // Swift.KeyPath is not allowed
        if let memberType = self.as(MemberTypeSyntax.self),
           memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "Swift",
           memberType.name.text == "KeyPath"
        {
            return false
        }
        
        // Swift.Range is not allowed
        if let memberType = self.as(MemberTypeSyntax.self),
           memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "Swift",
           memberType.name.text == "Range"
        {
            return false
        }
        
        // SwiftUICore.UnitPoint3D is not allowed
        if let memberType = self.as(MemberTypeSyntax.self),
           memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "SwiftUICore",
           memberType.name.text == "UnitPoint3D"
        {
            return false
        }
        
        // member type base must be valid (A.B)
        if let memberType = self.as(MemberTypeSyntax.self),
           !memberType.baseType.isValidModifierType
        {
            return false
        }
        
        // some/any constraint must be valid (some T)
        if let someOrAnyType = self.as(SomeOrAnyTypeSyntax.self),
           !someOrAnyType.constraint.isValidModifierType
        {
            return false
        }
        
        // composition types (A & B) cannot be erased trivially.
        if self.is(CompositionTypeSyntax.self) {
            return false
        }
        
        // optional wrapped type must be valid
        if let optionalType = self.as(OptionalTypeSyntax.self),
           !optionalType.wrappedType.isValidModifierType
        {
            return false
        }
        
        // array element type must be valid
        if let arrayType = self.as(ArrayTypeSyntax.self),
           !arrayType.element.isValidModifierType
        {
            return false
        }
        
        return true
    }
    
    /// Checks if this type has an existing conformance to `Decodable`.
    var isPrimitiveDecodable: Bool {
        if let arrayType = self.as(ArrayTypeSyntax.self) {
            return arrayType.element.isPrimitiveDecodable
        }
        if let dictionaryType = self.as(DictionaryTypeSyntax.self) {
            return dictionaryType.key.isPrimitiveDecodable && dictionaryType.value.isPrimitiveDecodable
        }
        if let optionalType = self.as(OptionalTypeSyntax.self) {
            return optionalType.wrappedType.isPrimitiveDecodable
        }
        if let memberType = self.as(MemberTypeSyntax.self),
           memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "Swift"
        {
            switch memberType.name.text {
            case "Bool", "Double", "Duration", "Float", "Float16", "Int", "Int128", "Int16", "Int32", "Int64", "Int8", "LocalTestingActorID", "Never", "ObservationRegistrar", "SIMD16", "SIMD2", "SIMD3", "SIMD32", "SIMD4", "SIMD64", "SIMD8", "SIMDMask", "String", "TaskPriority", "UInt", "UInt128", "UInt16", "UInt32", "UInt64", "UInt8":
                return true
            case "ClosedRange", "CollectionDifference", "ContiguousArray", "Optional", "PartialRangeFrom", "PartialRangeThrough", "PartialRangeUpTo", "Range", "Set", "Dictionary":
                return memberType.genericArgumentClause?.arguments.allSatisfy({ $0.argument.isPrimitiveDecodable }) ?? true
            default:
                return false
            }
        }
        if let memberType = self.as(MemberTypeSyntax.self),
           memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "CoreFoundation" || memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "CoreGraphics"
        {
            switch memberType.name.text {
            case "CGFloat":
                return true
            default:
                return false
            }
        }
        if let memberType = self.as(MemberTypeSyntax.self),
           memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "Foundation"
        {
            switch memberType.name.text {
            case "TimeInterval", "Date", "URL", "Data":
                return true
            default:
                return false
            }
        }
        if let identifierType = self.as(IdentifierTypeSyntax.self) {
            switch identifierType.name.text {
            case "Bool", "Double", "Duration", "Float", "Float16", "Int", "Int128", "Int16", "Int32", "Int64", "Int8", "LocalTestingActorID", "Never", "ObservationRegistrar", "SIMD16", "SIMD2", "SIMD3", "SIMD32", "SIMD4", "SIMD64", "SIMD8", "SIMDMask", "String", "TaskPriority", "UInt", "UInt128", "UInt16", "UInt32", "UInt64", "UInt8":
                return true
            case "ClosedRange", "CollectionDifference", "ContiguousArray", "Optional", "PartialRangeFrom", "PartialRangeThrough", "PartialRangeUpTo", "Range", "Set", "Dictionary":
                return identifierType.genericArgumentClause?.arguments.allSatisfy({ $0.argument.isPrimitiveDecodable }) ?? true
            case "CGFloat":
                return true
            case "TimeInterval", "Date", "URL", "Data":
                return true
            default:
                return false
            }
        }
        return false
    }
    
    /// Checks if this type is a `StylesheetResolvable` child of a parent type `T.Resolvable`.
    var isResolvableType: Bool {
        if let resolvableType = self.as(MemberTypeSyntax.self),
           resolvableType.name.text == "Resolvable"
        { // T.Resolvable
            return true
        } else if let optionalType = self.as(OptionalTypeSyntax.self) { // (some StylesheetResolvable)?
            return optionalType.wrappedType.isResolvableType
        } else if let arrayType = self.as(ArrayTypeSyntax.self) { // [some StylesheetResolvable]
            return arrayType.element.isResolvableType
        } else if self.as(IdentifierTypeSyntax.self)?.name.text == "TextReference" { // `TextReference`
            return true
        } else {
            return false
        }
    }
}
