//
//  ResolvableDeclSyntaxProtocol.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/29/25.
//

import SwiftSyntax

/// A type that can generate a nested `Resolvable` type.
public protocol ResolvableDeclSyntaxProtocol {
    var attributes: AttributeListSyntax { get }
    var name: TokenSyntax { get }
    var memberBlock: MemberBlockSyntax { get }
    
    var genericParameterClause: GenericParameterClauseSyntax? { get }
    var genericWhereClause: GenericWhereClauseSyntax? { get }
    
    var parent: Syntax? { get }
}

extension EnumDeclSyntax: ResolvableDeclSyntaxProtocol {}
extension StructDeclSyntax: ResolvableDeclSyntaxProtocol {}

public extension ResolvableDeclSyntaxProtocol {
    /// The name of this decl resolved based on its parent types/extensions.
    ///
    /// Resolving the type of `B` would result in `A.B`
    /// ```swift
    /// extension A {
    ///     struct B {}
    /// }
    /// ```
    var fullyResolvedType: TypeSyntax {
        guard let parentDecl = parent?.as(MemberBlockItemSyntax.self)?.parent?.as(MemberBlockItemListSyntax.self)?.parent?.as(MemberBlockSyntax.self)?.parent
        else { return TypeSyntax(IdentifierTypeSyntax(name: name.trimmed)) }
        
        if let structDecl = parentDecl.as(StructDeclSyntax.self) {
            return TypeSyntax(MemberTypeSyntax(baseType: structDecl.fullyResolvedType, name: name))
        }
        if let enumDecl = parentDecl.as(EnumDeclSyntax.self) {
            return TypeSyntax(MemberTypeSyntax(baseType: enumDecl.fullyResolvedType, name: name))
        }
        if let extensionDecl = parentDecl.as(ExtensionDeclSyntax.self) {
            return TypeSyntax(MemberTypeSyntax(baseType: extensionDecl.extendedType.trimmed, name: name))
        }
        
        return TypeSyntax(IdentifierTypeSyntax(name: name.trimmed))
    }
    
    /// The availability attributes of this decl resolved based on its parent types/extensions.
    ///
    /// Resolving the availability attributes of `B` would result in `@available(iOS 16, *)`.
    /// Resolving the availability attributes of `C` would result in `@available(iOS 18, *)`.
    ///
    /// ```swift
    /// @available(iOS 16, *)
    /// extension A {
    ///     struct B {}
    ///
    ///     @available(iOS 18, *)
    ///     struct C {}
    /// }
    /// ```
    var fullyResolvedAvailabilityAttributes: AttributeListSyntax {
        let selfAvailability = Array(attributes).filter(\.isAvailability)
        
        if !selfAvailability.isEmpty {
            return AttributeListSyntax(selfAvailability)
        }
        
        guard let parentDecl = parent?.as(MemberBlockItemSyntax.self)?.parent?.as(MemberBlockItemListSyntax.self)?.parent?.as(MemberBlockSyntax.self)?.parent
        else { return AttributeListSyntax(selfAvailability) }
        
        if let structAvailability = parentDecl.as(StructDeclSyntax.self)?.fullyResolvedAvailabilityAttributes {
            return structAvailability
        }
        if let enumAvailability = parentDecl.as(EnumDeclSyntax.self)?.fullyResolvedAvailabilityAttributes {
            return enumAvailability
        }
        if let extensionDecl = parentDecl.as(ExtensionDeclSyntax.self) {
            return extensionDecl.attributes.filter(\.isAvailability)
        }
        
        return AttributeListSyntax(selfAvailability)
    }
}
