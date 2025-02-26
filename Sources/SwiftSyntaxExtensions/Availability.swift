//
//  Availability.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/29/25.
//

import SwiftSyntax
import SwiftSyntaxBuilder

public extension AttributeListSyntax.Element {
    /// Checks if this attribute is `@availabile(...)`
    var isAvailability: Bool {
        guard case .attribute(let attributeSyntax) = self else {
            return false
        }
        return attributeSyntax.arguments?.is(AvailabilityArgumentListSyntax.self) ?? false
    }
    
    /// Checks if this attribute is `@available(platform 1.0, ..., *)`
    var isVersionAvailability: Bool {
        guard case .attribute(let attributeSyntax) = self
        else { return false }
        
        guard let availabilityArguments = attributeSyntax.arguments?.as(AvailabilityArgumentListSyntax.self)
        else { return false }
        
        return availabilityArguments.allSatisfy({
            switch $0.argument {
            case .availabilityVersionRestriction:
                return true
            case let .token(token):
                return token.tokenKind == .binaryOperator("*")
            default:
                return false
            }
        })
    }
}

public extension AttributeListSyntax {
    /// Checks if this symbol is marked `@MainActor`.
    var isActorIsolated: Bool {
        contains(where: {
            guard case let .attribute(attribute) = $0 else { return false }
            if let memberType = attribute.attributeName.as(MemberTypeSyntax.self),
               memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "_Concurrency",
               memberType.name.text == "MainActor"
            {
                return true
            } else if attribute.attributeName.as(IdentifierTypeSyntax.self)?.name.text == "MainActor" {
                return true
            } else {
                return false
            }
        })
    }
    
    /// Checks if this symbol is marked `@available(deprecated)` or `@available(obsoleted)`.
    var isDeprecated: Bool {
        contains(where: {
            guard case let .attribute(attribute) = $0 else { return false }
            return attribute.arguments?.as(AvailabilityArgumentListSyntax.self)?.contains(where: {
                switch $0.argument {
                case let .token(token):
                    return token.tokenKind == .keyword(.deprecated)
                        || token.tokenKind == .keyword(.obsoleted)
                case let .availabilityLabeledArgument(argument):
                    return argument.label.tokenKind == .keyword(.deprecated)
                        || argument.label.tokenKind == .keyword(.obsoleted)
                default:
                    return false
                }
            })
                ?? false
        })
    }
    
    /// Checks all `@available(...)` attributes to create a set of available platforms.
    private func supportedPlatforms() -> Set<String> {
        var platforms: Set<String> = ["iOS", "macOS", "tvOS", "watchOS", "visionOS"]

        for attribute in self {
            guard case let .attribute(attribute) = attribute,
                  let argumentList = attribute.arguments?.as(AvailabilityArgumentListSyntax.self)
            else { continue }
            if argumentList.count == 2,
               case .token(let platformToken) = argumentList.first!.argument,
               case .token(let unavailableToken) = argumentList.last!.argument,
               unavailableToken.tokenKind == .keyword(.unavailable)
            { // @available(platform, unavailable)
                // this platform is not supported
                platforms.remove(platformToken.text)
            } else {
                for element in argumentList {
                    switch element.argument {
                    case let .availabilityVersionRestriction(version): // @available(platform 1.0, ..., *)
                        // this platform is supported
                        platforms.insert(version.platform.text)
                    default:
                        break
                    }
                }
            }
        }
        
        return platforms
    }
    
    /// Create an `#if os()` check for the platforms specified in the `@available` attributes.
    func makeOSCheck(@MemberBlockItemListBuilder itemsBuilder: () -> MemberBlockItemListSyntax) -> MemberBlockItemListSyntax {
        let platforms = supportedPlatforms()
        
        guard !platforms.isEmpty
        else { return itemsBuilder() }
        
        return MemberBlockItemListSyntax {
            MemberBlockItemSyntax(decl: IfConfigDeclSyntax(clauses: IfConfigClauseListSyntax {
                IfConfigClauseSyntax(
                    poundKeyword: .poundIfToken(),
                    condition: ExprSyntax(stringLiteral: platforms.map({ "os(\($0))" }).sorted().joined(separator: " || ")),
                    elements: IfConfigClauseSyntax.Elements.decls(MemberBlockItemListSyntax(itemsBuilder: itemsBuilder))
                )
            }))
        }
    }
    
    /// Create an `#if os()` check for the platforms specified in the `@available` attributes.
    func makeOSCheck(@CodeBlockItemListBuilder itemsBuilder: () -> CodeBlockItemListSyntax) -> CodeBlockItemListSyntax {
        let platforms = supportedPlatforms()
        
        guard !platforms.isEmpty
        else { return itemsBuilder() }
        
        return CodeBlockItemListSyntax {
            CodeBlockItemSyntax(item: .decl(DeclSyntax(IfConfigDeclSyntax(clauses: IfConfigClauseListSyntax {
                IfConfigClauseSyntax(
                    poundKeyword: .poundIfToken(),
                    condition: ExprSyntax(stringLiteral: platforms.map({ "os(\($0))" }).sorted().joined(separator: " || ")),
                    elements: IfConfigClauseSyntax.Elements.statements(CodeBlockItemListSyntax(itemsBuilder: itemsBuilder))
                )
            }))))
        }
    }
    
    /// Create an `#if os()` check for the platforms specified in the `@available` attributes.
    func makeOSCheck(@SwitchCaseListBuilder itemsBuilder: () -> SwitchCaseListSyntax) -> SwitchCaseListSyntax {
        let platforms = supportedPlatforms()
        
        guard !platforms.isEmpty
        else { return itemsBuilder() }
        
        return SwitchCaseListSyntax {
            SwitchCaseListSyntax.Element.ifConfigDecl(IfConfigDeclSyntax(clauses: IfConfigClauseListSyntax {
                IfConfigClauseSyntax(
                    poundKeyword: .poundIfToken(),
                    condition: ExprSyntax(stringLiteral: platforms.map({ "os(\($0))" }).sorted().joined(separator: " || ")),
                    elements: IfConfigClauseSyntax.Elements.switchCases(SwitchCaseListSyntax(itemsBuilder: itemsBuilder))
                )
            }))
        }
    }
    
    /// Create an `if #available(...)` check for the versions specified in the `@available` attributes.
    func makeRuntimeOSCheck(
        @CodeBlockItemListBuilder itemsBuilder: () -> CodeBlockItemListSyntax,
        @CodeBlockItemListBuilder elseBody: () -> CodeBlockItemListSyntax
    ) -> CodeBlockItemListSyntax {
        if let availabilityCheck = self.lazy.filter(\.isVersionAvailability).reversed().compactMap({ (attribute) -> AvailabilityArgumentListSyntax? in
            guard case let .attribute(attribute) = attribute else { return nil }
            return attribute.arguments?.as(AvailabilityArgumentListSyntax.self)
        }).first {
            return CodeBlockItemListSyntax {
                CodeBlockItemSyntax(item: .expr(ExprSyntax(IfExprSyntax(
                    conditions: ConditionElementListSyntax {
                        ConditionElementSyntax(
                            condition: .availability(AvailabilityConditionSyntax(
                                availabilityKeyword: .poundAvailableToken(),
                                availabilityArguments: availabilityCheck
                            ))
                        )
                    },
                    elseKeyword: .keyword(.else),
                    elseBody: IfExprSyntax.ElseBody.codeBlock(CodeBlockSyntax(statements: CodeBlockItemListSyntax(itemsBuilder: elseBody)))
                ) {
                    itemsBuilder()
                })))
            }
        } else {
            return itemsBuilder()
        }
    }
}
