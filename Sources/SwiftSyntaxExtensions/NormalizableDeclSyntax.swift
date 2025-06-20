//
//  NormalizableDeclSyntax.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/29/25.
//

import SwiftSyntax

/// `FunctionDeclSyntax` or `InitializerDeclSyntax`.
///
/// This type must have the following parameters:
/// - `signature`
/// - `genericWhereClause`
/// - `genericParameterClause`
public protocol NormalizableDeclSyntax: DeclSyntaxProtocol {
    var signature: FunctionSignatureSyntax { get set }
    var attributes: AttributeListSyntax { get }
    var genericWhereClause: GenericWhereClauseSyntax? { get }
    var genericParameterClause: GenericParameterClauseSyntax? { get }
}

extension FunctionDeclSyntax: NormalizableDeclSyntax {}
extension InitializerDeclSyntax: NormalizableDeclSyntax {}

public extension NormalizableDeclSyntax {
    /// Check if the modifier decl has valid parameters.
    var isValidModifier: Bool {
        // deprecated/obsoleted symbols
        guard !attributes.isObsoleted
        else { return false }
        
        for parameter in signature.parameterClause.parameters {
            guard parameter.type.isValidModifierType else { return false }
            
            // only @ViewBuilder and () -> Void functions are allowed
            if let functionType: FunctionTypeSyntax = parameter.type.as(FunctionTypeSyntax.self)
                ?? parameter.type.as(AttributedTypeSyntax.self)?.baseType.as(FunctionTypeSyntax.self)
                ?? (parameter.type.as(AttributedTypeSyntax.self)?.baseType ?? parameter.type.as(OptionalTypeSyntax.self)?.wrappedType)?.as(TupleTypeSyntax.self)?.elements.first?.type.as(FunctionTypeSyntax.self)
            {
                guard functionType.returnClause.type.isVoid || parameter.isViewBuilder || parameter.isToolbarContentBuilder
                else { return false }
            }
               
        }
            
        return true
    }
    
    /// Converts all generic types into erased types (`some ShapeStyle` -> `AnyShapeStyle`, `T: Hashable` -> `AnyHashable`, `Value` -> `String`)
    ///
    /// 1. `some` types become a type-eraser: `some ShapeStyle` -> `AnyShapeStyle`
    /// 2. same-type requirements become the right type (`T where T == String` -> `String`)
    /// 3. conformance requirements become a type-eraser (`T: Hashable` -> `AnyHashable`)
    /// 4. unconstrained types become `String` (`Value` -> `String`)
    func normalizedParameterTypes() -> Self {
        return self.with(
            \.signature.parameterClause.parameters, FunctionParameterListSyntax(
                signature.parameterClause.parameters
                .map { parameter in
                    if parameter.ellipsis != nil { // variadics -> single element
                        return parameter.with(\.ellipsis, nil)
                    } else {
                        return parameter
                    }
                }
                .map { (parameter: FunctionParameterSyntax) -> FunctionParameterSyntax in
                    if let identifierType = parameter.type.as(IdentifierTypeSyntax.self) {
                        if let genericType = genericWhereClause?.requirements.lazy.compactMap({ requirement -> TypeSyntax? in
                            switch requirement.requirement {
                            case let .sameTypeRequirement(sameType):
                                guard sameType.leftType.as(IdentifierTypeSyntax.self)?.name.text == identifierType.name.text,
                                      case let .type(rightType) = sameType.rightType
                                else { return nil }
                                return rightType
                            case let .conformanceRequirement(conformance):
                                guard conformance.leftType.as(IdentifierTypeSyntax.self)?.name.text == identifierType.name.text
                                else { return nil }
                                return conformance.rightType.erasedType()
                            default:
                                return nil
                            }
                        }).first {
                            return parameter
                                .with(\.type, genericType)
                                .makeAttributeReference()
                        } else if let genericType = genericParameterClause?.parameters.lazy.compactMap({ genericParameter -> TypeSyntax? in
                            guard genericParameter.name.text == identifierType.name.text
                            else { return nil }
                            return genericParameter.inheritedType ?? TypeSyntax(IdentifierTypeSyntax(name: .identifier("String"))) // if there is no type constraint, use a string
                        }).first {
                            return parameter
                                .with(\.type, genericType.erasedType())
                                .makeAttributeReference()
                        }
                    }
                    if let optionalType = parameter.type.as(OptionalTypeSyntax.self),
                       let identifierType = optionalType.wrappedType.as(IdentifierTypeSyntax.self)
                    {
                        if let genericType = genericWhereClause?.requirements.lazy.compactMap({ requirement -> TypeSyntax? in
                            switch requirement.requirement {
                            case let .sameTypeRequirement(sameType):
                                guard sameType.leftType.as(IdentifierTypeSyntax.self)?.name.text == identifierType.name.text,
                                      case let .type(rightType) = sameType.rightType
                                else { return nil }
                                return rightType
                            case let .conformanceRequirement(conformance):
                                guard conformance.leftType.as(IdentifierTypeSyntax.self)?.name.text == identifierType.name.text
                                else { return nil }
                                return conformance.rightType.erasedType()
                            default:
                                return nil
                            }
                        }).first {
                            return parameter
                                .with(\.type, TypeSyntax(OptionalTypeSyntax(wrappedType: genericType)))
                                .makeAttributeReference()
                        } else if let genericType = genericParameterClause?.parameters.lazy.compactMap({ genericParameter -> TypeSyntax? in
                            guard genericParameter.name.text == identifierType.name.text
                            else { return nil }
                            return genericParameter.inheritedType
                        }).first {
                            return parameter
                                .with(\.type, TypeSyntax(OptionalTypeSyntax(wrappedType: genericType.erasedType())))
                                .makeAttributeReference()
                        }
                    }
                    if let memberType = parameter.type.as(MemberTypeSyntax.self),
                       let identifierType = memberType.baseType.as(IdentifierTypeSyntax.self) {
                        if let genericType = genericWhereClause?.requirements.lazy.compactMap({ requirement -> TypeSyntax? in
                            switch requirement.requirement {
                            case let .sameTypeRequirement(sameType):
                                guard sameType.leftType.as(IdentifierTypeSyntax.self)?.name.text == identifierType.name.text,
                                      case let .type(rightType) = sameType.rightType
                                else { return nil }
                                return rightType
                            case let .conformanceRequirement(conformance):
                                guard conformance.leftType.as(IdentifierTypeSyntax.self)?.name.text == identifierType.name.text
                                else { return nil }
                                return conformance.rightType.erasedType()
                            default:
                                return nil
                            }
                        }).first {
                            return parameter
                                .with(\.type, TypeSyntax(memberType.with(\.baseType, genericType)))
                                .makeAttributeReference()
                        } else if let genericType = genericParameterClause?.parameters.lazy.compactMap({ genericParameter -> TypeSyntax? in
                            guard genericParameter.name.text == identifierType.name.text
                            else { return nil }
                            return genericParameter.inheritedType ?? TypeSyntax(IdentifierTypeSyntax(name: .identifier("String"))) // if there is no type constraint, use a string
                        }).first {
                            return parameter
                                .with(\.type, TypeSyntax(memberType.with(\.baseType, genericType.erasedType())))
                                .makeAttributeReference()
                        }
                    }
                    if let optionalType = parameter.type.as(OptionalTypeSyntax.self),
                       let memberType = optionalType.wrappedType.as(MemberTypeSyntax.self),
                       let identifierType = memberType.baseType.as(IdentifierTypeSyntax.self) {
                        if let genericType = genericWhereClause?.requirements.lazy.compactMap({ requirement -> TypeSyntax? in
                            switch requirement.requirement {
                            case let .sameTypeRequirement(sameType):
                                guard sameType.leftType.as(IdentifierTypeSyntax.self)?.name.text == identifierType.name.text,
                                      case let .type(rightType) = sameType.rightType
                                else { return nil }
                                return rightType
                            case let .conformanceRequirement(conformance):
                                guard conformance.leftType.as(IdentifierTypeSyntax.self)?.name.text == identifierType.name.text
                                else { return nil }
                                return conformance.rightType.erasedType()
                            default:
                                return nil
                            }
                        }).first {
                            return parameter
                                .with(\.type, TypeSyntax(optionalType.with(\.wrappedType, TypeSyntax(memberType.with(\.baseType, genericType)))))
                                .makeAttributeReference()
                        } else if let genericType = genericParameterClause?.parameters.lazy.compactMap({ genericParameter -> TypeSyntax? in
                            guard genericParameter.name.text == identifierType.name.text
                            else { return nil }
                            return genericParameter.inheritedType ?? TypeSyntax(IdentifierTypeSyntax(name: .identifier("String"))) // if there is no type constraint, use a string
                        }).first {
                            return parameter
                                .with(\.type, TypeSyntax(optionalType.with(\.wrappedType, TypeSyntax(memberType.with(\.baseType, genericType.erasedType())))))
                                .makeAttributeReference()
                        }
                    }
                    if let someType = parameter.type.as(SomeOrAnyTypeSyntax.self)?.constraint {
                        return parameter
                            .with(\.type, someType.erasedType())
                            .makeAttributeReference()
                    }
                    if parameter.isViewBuilder {
                        return parameter
                            .with(\.attributes, AttributeListSyntax())
                            .with(\.type, TypeSyntax(IdentifierTypeSyntax(name: .identifier("ViewReference"))))
                            .makeAttributeReference()
                    }
                    if parameter.isToolbarContentBuilder {
                        if let returnType = parameter.type.as(FunctionTypeSyntax.self)?.returnClause.type.as(IdentifierTypeSyntax.self),
                           let genericType  = genericWhereClause?.requirements.lazy.compactMap({ requirement -> TypeSyntax? in
                               switch requirement.requirement {
                               case let .conformanceRequirement(conformance):
                                   guard conformance.leftType.as(IdentifierTypeSyntax.self)?.name.text == returnType.name.text
                                   else { return nil }
                                   return conformance.rightType
                               default:
                                   return nil
                               }
                           }).first,
                           genericType.as(MemberTypeSyntax.self)?.name.text == "CustomizableToolbarContent"
                        {
                            return parameter
                                .with(\.attributes, AttributeListSyntax())
                                .with(\.type, TypeSyntax(IdentifierTypeSyntax(name: .identifier("CustomizableToolbarContentReference"))))
                                .makeAttributeReference()
                        } else {
                            return parameter
                                .with(\.attributes, AttributeListSyntax())
                                .with(\.type, TypeSyntax(IdentifierTypeSyntax(name: .identifier("ToolbarContentReference"))))
                                .makeAttributeReference()
                        }
                    }
                    if let functionType = parameter.type.as(FunctionTypeSyntax.self) {
                        // closures that return values other than `Void` are not supported.
                        // we *might* be able to support those if the closure is `async`.
                        guard functionType.returnClause.type.isVoid
                        else { fatalError("Unsupported parameter '\(functionType)'. Function parameters must have a 'Void' return value.") }
                        return parameter
                            .with(\.type, TypeSyntax(IdentifierTypeSyntax(name: .identifier("Event"))))
                            .with(\.defaultValue, nil)
                    }
                    if let optionalType = parameter.type.as(OptionalTypeSyntax.self),
                       let tupleType = optionalType.wrappedType.as(TupleTypeSyntax.self),
                       tupleType.elements.count == 1,
                       let functionType = tupleType.elements.first!.type.as(FunctionTypeSyntax.self)
                    {
                        // closures that return values other than `Void` are not supported.
                        // we *might* be able to support those if the closure is `async`.
                        guard functionType.returnClause.type.isVoid
                        else { fatalError("Unsupported parameter '\(functionType)'. Function parameters must have a 'Void' return value.") }
                        return parameter
                            .with(\.type, TypeSyntax(IdentifierTypeSyntax(name: .identifier("Event"))))
                            .with(\.defaultValue, nil)
                    }
                    if let attributedType = parameter.type.as(AttributedTypeSyntax.self),
                       let functionType = attributedType.baseType.as(FunctionTypeSyntax.self)
                    {
                        // closures that return values other than `Void` are not supported.
                        // we *might* be able to support those if the closure is `async`.
                        guard functionType.returnClause.type.isVoid
                        else { fatalError("Unsupported parameter '\(functionType)'. Function parameters must have a 'Void' return value.") }
                        return parameter
                            .with(\.type, TypeSyntax(IdentifierTypeSyntax(name: .identifier("Event"))))
                            .with(\.defaultValue, nil)
                    }
                    if let attributedType = parameter.type.as(AttributedTypeSyntax.self),
                       let tupleType = attributedType.baseType.as(TupleTypeSyntax.self),
                       tupleType.elements.count == 1,
                       let functionType = tupleType.elements.first!.type.as(FunctionTypeSyntax.self)
                    {
                        // closures that return values other than `Void` are not supported.
                        // we *might* be able to support those if the closure is `async`.
                        guard functionType.returnClause.type.isVoid
                        else { fatalError("Unsupported parameter '\(functionType)'. Function parameters must have a 'Void' return value.") }
                        return parameter
                            .with(\.type, TypeSyntax(IdentifierTypeSyntax(name: .identifier("Event"))))
                            .with(\.defaultValue, nil)
                    }
                    // [S] where S == String -> [String]
                    // [S] where S: Protocol -> [StylesheetResolvableProtocol]
                    if let arrayType = parameter.type.as(ArrayTypeSyntax.self),
                       let identifierType = arrayType.element.as(IdentifierTypeSyntax.self)
                    {
                        if let genericType = genericWhereClause?.requirements.lazy.compactMap({ requirement -> TypeSyntax? in
                            switch requirement.requirement {
                            case let .sameTypeRequirement(sameType):
                                guard sameType.leftType.as(IdentifierTypeSyntax.self)?.name.text == identifierType.name.text,
                                      case let .type(rightType) = sameType.rightType
                                else { return nil }
                                return rightType
                            case let .conformanceRequirement(conformance):
                                guard conformance.leftType.as(IdentifierTypeSyntax.self)?.name.text == identifierType.name.text
                                else { return nil }
                                return conformance.rightType.erasedType()
                            default:
                                return nil
                            }
                        }).first {
                            return parameter
                                .with(\.type, TypeSyntax(arrayType.with(\.element, genericType)))
                                .makeAttributeReference()
                        } else if let genericType = genericParameterClause?.parameters.lazy.compactMap({ genericParameter -> TypeSyntax? in
                            guard genericParameter.name.text == identifierType.name.text
                            else { return nil }
                            return genericParameter.inheritedType ?? TypeSyntax(IdentifierTypeSyntax(name: .identifier("String"))) // if there is no type constraint, use a string
                        }).first {
                            return parameter
                                .with(\.type, TypeSyntax(arrayType.with(\.element, genericType.erasedType())))
                                .makeAttributeReference()
                        }
                    }
                    // Binding -> ChangeTracked<_>.Resolved
                    if let memberType: MemberTypeSyntax = parameter.type.as(MemberTypeSyntax.self) ?? parameter.type.as(OptionalTypeSyntax.self)?.wrappedType.as(MemberTypeSyntax.self),
                       memberType.name.text == "Binding"
                    {
                        return parameter
                            .with(\.type, TypeSyntax(MemberTypeSyntax(
                                baseType: IdentifierTypeSyntax(name: .identifier("ChangeTracked"), genericArgumentClause: GenericArgumentClauseSyntax {
                                    let type = memberType.genericArgumentClause!.arguments.first!.argument
                                    if let identifierType = type.as(IdentifierTypeSyntax.self),
                                       let genericType = genericWhereClause?.requirements.lazy.compactMap({ requirement -> TypeSyntax? in
                                           switch requirement.requirement {
                                           case let .sameTypeRequirement(sameType):
                                               guard sameType.leftType.as(IdentifierTypeSyntax.self)?.name.text == identifierType.name.text,
                                                     case let .type(rightType) = sameType.rightType
                                               else { return nil }
                                               return rightType
                                           case let .conformanceRequirement(conformance):
                                               guard conformance.leftType.as(IdentifierTypeSyntax.self)?.name.text == identifierType.name.text
                                               else { return nil }
                                               return conformance.rightType.erasedType()
                                           default:
                                               return nil
                                           }
                                       }).first {
                                        GenericArgumentSyntax(argument: genericType)
                                    } else if let identifierType = type.as(IdentifierTypeSyntax.self),
                                              let genericType = genericParameterClause?.parameters.lazy.compactMap({ genericParameter -> TypeSyntax? in
                                                  guard genericParameter.name.text == identifierType.name.text
                                                  else { return nil }
                                                  return genericParameter.inheritedType ?? TypeSyntax(IdentifierTypeSyntax(name: .identifier("String"))) // if there is no type constraint, use a string
                                              }).first {
                                        GenericArgumentSyntax(argument: genericType)
                                    } else {
                                        GenericArgumentSyntax(argument: type)
                                    }
                                }),
                                name: .identifier("Resolvable")
                            )))
                    } else if let identifierType: IdentifierTypeSyntax = parameter.type.as(IdentifierTypeSyntax.self) ?? parameter.type.as(OptionalTypeSyntax.self)?.wrappedType.as(IdentifierTypeSyntax.self),
                              identifierType.name.text == "Binding"
                    {
                        return parameter
                            .with(\.type, TypeSyntax(MemberTypeSyntax(
                                baseType: IdentifierTypeSyntax(name: .identifier("ChangeTracked"), genericArgumentClause: GenericArgumentClauseSyntax {
                                    let type = identifierType.genericArgumentClause!.arguments.first!.argument
                                    if let identifierType = type.as(IdentifierTypeSyntax.self),
                                       let genericType = genericWhereClause?.requirements.lazy.compactMap({ requirement -> TypeSyntax? in
                                           switch requirement.requirement {
                                           case let .sameTypeRequirement(sameType):
                                               guard sameType.leftType.as(IdentifierTypeSyntax.self)?.name.text == identifierType.name.text,
                                                     case let .type(rightType) = sameType.rightType
                                               else { return nil }
                                               return rightType
                                           case let .conformanceRequirement(conformance):
                                               guard conformance.leftType.as(IdentifierTypeSyntax.self)?.name.text == identifierType.name.text
                                               else { return nil }
                                               return conformance.rightType.erasedType()
                                           default:
                                               return nil
                                           }
                                       }).first {
                                        GenericArgumentSyntax(argument: genericType)
                                    } else if let identifierType = type.as(IdentifierTypeSyntax.self),
                                              let genericType = genericParameterClause?.parameters.lazy.compactMap({ genericParameter -> TypeSyntax? in
                                                  guard genericParameter.name.text == identifierType.name.text
                                                  else { return nil }
                                                  return genericParameter.inheritedType ?? TypeSyntax(IdentifierTypeSyntax(name: .identifier("String"))) // if there is no type constraint, use a string
                                              }).first {
                                        GenericArgumentSyntax(argument: genericType)
                                    } else {
                                        GenericArgumentSyntax(argument: type)
                                    }
                                }),
                                name: .identifier("Resolvable")
                            )))
                    }
                    
                    if parameter.type.isPrimitiveDecodable { // AttributeReference<T>
                        return parameter
                            .makeAttributeReference()
                    } else { // T.Resolvable
                        if let arrayType = parameter.type.as(ArrayTypeSyntax.self) { // [T] -> [T.Resolvable]
                            // [SwiftUICore.Text] -> [TextReference]
                            if let memberType = arrayType.element.as(MemberTypeSyntax.self),
                               memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "SwiftUICore",
                               memberType.name.text == "Text"
                            {
                                return parameter
                                    .with(\.type, TypeSyntax(
                                        arrayType.with(\.element, TypeSyntax(IdentifierTypeSyntax(name: .identifier("TextReference"))))
                                    ))
                                    .with(\.defaultValue, nil)
                            } else {
                                return parameter
                                    .with(\.type, TypeSyntax(
                                        arrayType.with(\.element, TypeSyntax(MemberTypeSyntax(baseType: arrayType.element, name: .identifier("Resolvable"))))
                                    ))
                                    .with(\.defaultValue, nil)
                            }
                        } else if let memberType = parameter.type.as(MemberTypeSyntax.self),
                                  memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "Swift",
                                  memberType.name.text == "Set",
                                  case let .type(elementType) = memberType.genericArgumentClause?.arguments.first?.argument
                        { // Swift.Set<T> -> AttributeReference<StylesheetResolvableSet<T.Resolvable>>
                            return parameter
                                .with(\.type, TypeSyntax(IdentifierTypeSyntax(name: .identifier("StylesheetResolvableSet"), genericArgumentClause: GenericArgumentClauseSyntax {
                                    GenericArgumentSyntax(argument: MemberTypeSyntax(baseType: elementType, name: .identifier("Resolvable")))
                                })))
                                .with(\.defaultValue, parameter.defaultValue.flatMap({ defaultValue in
                                    defaultValue.with(\.value, ExprSyntax(
                                        FunctionCallExprSyntax(
                                            calledExpression: MemberAccessExprSyntax(name: .identifier("constant")),
                                            leftParen: .leftParenToken(),
                                            rightParen: .rightParenToken()
                                        ) {
                                            LabeledExprSyntax(expression: defaultValue.value)
                                        }
                                    ))
                                }))
                                .makeAttributeReference()
                        } else if let memberType = parameter.type.as(MemberTypeSyntax.self),
                                  memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "SwiftUICore",
                                  memberType.name.text == "Text"
                        { // SwiftUICore.Text -> TextReference
                            return parameter
                                .with(\.type, TypeSyntax(IdentifierTypeSyntax(name: .identifier("TextReference"))))
                                .with(\.defaultValue, parameter.defaultValue.flatMap({ defaultValue in
                                    defaultValue.with(\.value, ExprSyntax(
                                        FunctionCallExprSyntax(
                                            calledExpression: MemberAccessExprSyntax(name: .identifier("constant")),
                                            leftParen: .leftParenToken(),
                                            rightParen: .rightParenToken()
                                        ) {
                                            LabeledExprSyntax(expression: defaultValue.value)
                                        }
                                    ))
                                }))
                                .makeAttributeReference()
                        } else if let optionalType = parameter.type.as(OptionalTypeSyntax.self) { // T? -> T.Resolvable?
                            // [T]? -> [T.Resolvable]?
                            if let arrayType = optionalType.wrappedType.as(ArrayTypeSyntax.self) {
                                return parameter
                                    .with(\.type, TypeSyntax(
                                        optionalType.with(\.wrappedType, TypeSyntax(
                                            arrayType.with(\.element, TypeSyntax(MemberTypeSyntax(baseType: arrayType.element, name: .identifier("Resolvable"))))
                                        ))
                                    ))
                            }
                            // Text? -> TextReference?
                            else if let memberType = optionalType.wrappedType.as(MemberTypeSyntax.self),
                               memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "SwiftUICore",
                               memberType.name.text == "Text"
                            {
                                return parameter
                                    .with(\.type, TypeSyntax(
                                        optionalType.with(\.wrappedType, TypeSyntax(IdentifierTypeSyntax(name: .identifier("TextReference"))))
                                    ))
                            } else {
                                return parameter
                                    .with(\.type, TypeSyntax(
                                        optionalType.with(\.wrappedType, TypeSyntax(MemberTypeSyntax(baseType: optionalType.wrappedType, name: .identifier("Resolvable"))))
                                    ))
                            }
                        } else { // T -> T.Resolvable
                            return parameter
                                .with(\.type, TypeSyntax(MemberTypeSyntax(baseType: parameter.type, name: .identifier("Resolvable"))))
                                .with(\.defaultValue, parameter.defaultValue.flatMap({ defaultValue in
                                    defaultValue.with(\.value, ExprSyntax(
                                        FunctionCallExprSyntax(
                                            calledExpression: MemberAccessExprSyntax(name: .identifier("__constant")),
                                            leftParen: .leftParenToken(),
                                            rightParen: .rightParenToken()
                                        ) {
                                            LabeledExprSyntax(expression: defaultValue.value)
                                        }
                                    ))
                                }))
                        }
                    }
                }
            )
        )
    }
}

public extension TypeSyntax {
    /// Erase a type by giving it a `StylesheetResolvable*` prefix
    /// (we can choose to either typealias this to an existing eraser, or implement our own)
    ///
    /// The following protocols will be converted to a single concrete type:
    /// - `BinaryFloatingPoint` -> `Double`
    /// - `BinaryInteger` -> `Int`
    /// - `Equatable` -> `String`
    /// - `Hashable` -> `String`
    /// - `Identifiable` -> `String`
    /// - `StringProtocol` -> `String`
    /// - `View` -> `InlineViewReference` (this is a `View` argument that isn't a function argument with `@ViewBuilder`)
    /// - `Binding` -> `ChangeTracked`
    ///
    /// Other protocols will be converted to `StylesheetResolvable*` erasers.
    func erasedType() -> TypeSyntax {
        if let identifierType = self.as(IdentifierTypeSyntax.self) {
            if identifierType.name.text == "BinaryFloatingPoint" {
                return TypeSyntax(IdentifierTypeSyntax(name: .identifier("Double")))
            } else if identifierType.name.text == "BinaryInteger" {
                return TypeSyntax(IdentifierTypeSyntax(name: .identifier("Int")))
            } else if identifierType.name.text == "Equatable" {
                return TypeSyntax(IdentifierTypeSyntax(name: .identifier("String")))
            } else if identifierType.name.text == "Hashable" {
                return TypeSyntax(IdentifierTypeSyntax(name: .identifier("String")))
            } else if identifierType.name.text == "Identifiable" {
                return TypeSyntax(IdentifierTypeSyntax(name: .identifier("String")))
            } else if identifierType.name.text == "StringProtocol" {
                return TypeSyntax(IdentifierTypeSyntax(name: .identifier("String")))
            } else if identifierType.name.text == "View" {
                return TypeSyntax(IdentifierTypeSyntax(name: .identifier("InlineViewReference")))
            } else {
                return TypeSyntax(IdentifierTypeSyntax(name: .identifier("StylesheetResolvable\(identifierType.name.text)")))
            }
        } else if let memberType = self.as(MemberTypeSyntax.self) {
            if memberType.name.text == "BinaryFloatingPoint" {
                return TypeSyntax(IdentifierTypeSyntax(name: .identifier("Double")))
            } else if memberType.name.text == "BinaryInteger" {
                return TypeSyntax(IdentifierTypeSyntax(name: .identifier("Int")))
            } else if memberType.name.text == "Equatable" {
                return TypeSyntax(IdentifierTypeSyntax(name: .identifier("String")))
            } else if memberType.name.text == "Hashable" {
                return TypeSyntax(IdentifierTypeSyntax(name: .identifier("String")))
            } else if memberType.name.text == "Identifiable" {
                return TypeSyntax(IdentifierTypeSyntax(name: .identifier("String")))
            } else if memberType.name.text == "StringProtocol" {
                return TypeSyntax(IdentifierTypeSyntax(name: .identifier("String")))
            } else if memberType.name.text == "View" {
                return TypeSyntax(IdentifierTypeSyntax(name: .identifier("InlineViewReference")))
            } else if memberType.name.text == "Binding" {
                return TypeSyntax(IdentifierTypeSyntax(name: .identifier("ChangeTracked"), genericArgumentClause: memberType.genericArgumentClause))
            } else {
                return TypeSyntax(IdentifierTypeSyntax(name: .identifier("StylesheetResolvable\(memberType.name.text)")))
            }
        } else if let optionalType = self.as(OptionalTypeSyntax.self) {
            return TypeSyntax(OptionalTypeSyntax(wrappedType: TypeSyntax(optionalType).erasedType()))
        } else if let arrayType = self.as(ArrayTypeSyntax.self) {
            return TypeSyntax(arrayType.with(\.element, arrayType.element.erasedType()))
        } else if let someType = self.as(SomeOrAnyTypeSyntax.self) {
            return someType.constraint.erasedType()
        } else {
            fatalError("type '\(self)' cannot erased")
        }
    }
    
    /// Checks if a type represents `Swift.Void`.
    var isVoid: Bool {
        if let tuple = self.as(TupleTypeSyntax.self),
           tuple.elements.isEmpty
        {
            return true
        } else if let memberType = self.as(MemberTypeSyntax.self),
                  memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "Swift",
                  memberType.name.text == "Void"
        {
            return true
        } else if let identifierType = self.as(IdentifierTypeSyntax.self),
                  identifierType.name.text == "Void"
        {
            return true
        } else {
            return false
        }
    }
    
    func resolvedType() -> TypeSyntax {
        // T.Resolvable
        if let arrayType = self.as(ArrayTypeSyntax.self) { // [T] -> [T.Resolvable]
            // [SwiftUICore.Text] -> [TextReference]
            if let memberType = arrayType.element.as(MemberTypeSyntax.self),
               memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "SwiftUICore",
               memberType.name.text == "Text"
            {
                return TypeSyntax(
                    arrayType.with(\.element, TypeSyntax(IdentifierTypeSyntax(name: .identifier("TextReference"))))
                )
            } else {
                return TypeSyntax(
                    arrayType.with(\.element, TypeSyntax(MemberTypeSyntax(baseType: arrayType.element, name: .identifier("Resolvable"))))
                )
            }
        } else if let memberType = self.as(MemberTypeSyntax.self),
                  memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "Swift",
                  memberType.name.text == "Set",
                  case let .type(elementType) = memberType.genericArgumentClause?.arguments.first?.argument
        { // Swift.Set<T> -> StylesheetResolvableSet<T.Resolvable>
            return TypeSyntax(IdentifierTypeSyntax(name: .identifier("StylesheetResolvableSet"), genericArgumentClause: GenericArgumentClauseSyntax {
                GenericArgumentSyntax(argument: .type(TypeSyntax(MemberTypeSyntax(baseType: elementType, name: .identifier("Resolvable")))))
            }))
        } else if let memberType = self.as(MemberTypeSyntax.self),
                  memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "SwiftUICore",
                  memberType.name.text == "Text"
        { // SwiftUICore.Text -> TextReference
            return TypeSyntax(IdentifierTypeSyntax(name: .identifier("TextReference")))
        } else if let optionalType = self.as(OptionalTypeSyntax.self) { // T? -> T.Resolvable?
            // Text? -> TextReference?
            if let memberType = optionalType.wrappedType.as(MemberTypeSyntax.self),
               memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "SwiftUICore",
               memberType.name.text == "Text"
            {
                return TypeSyntax(
                    optionalType.with(\.wrappedType, TypeSyntax(IdentifierTypeSyntax(name: .identifier("TextReference"))))
                )
            } else {
                return TypeSyntax(
                    optionalType.with(\.wrappedType, TypeSyntax(MemberTypeSyntax(baseType: optionalType.wrappedType, name: .identifier("Resolvable"))))
                )
            }
        } else { // T -> T.Resolvable
            return TypeSyntax(MemberTypeSyntax(baseType: self, name: .identifier("Resolvable")))
        }
    }
}
