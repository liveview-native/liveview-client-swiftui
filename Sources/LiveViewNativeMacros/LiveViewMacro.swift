//
//  LiveViewMacro.swift
//
//
//  Created by Carson Katri on 7/6/23.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum LiveViewMacro {}

extension LiveViewMacro: ExpressionMacro {
    public static func expansion<Node, Context>(
        of node: Node,
        in context: Context
    ) throws -> ExprSyntax where Node : FreestandingMacroExpansionSyntax, Context : MacroExpansionContext {
        let registryName = context.makeUniqueName("Registry")
        
        // CustomRegistries
        let addons = try node.argumentList.first(where: { $0.label?.text == "addons" })?
            .expression.as(ArrayExprSyntax.self)?
            .elements.map(transformAddon(_:))
        ?? []
        
        let registries: DeclSyntax
        switch addons.count {
        case 0:
            registries = "typealias Registries = _SpecializedEmptyRegistry<Self>"
        case 1:
            registries = "typealias Registries = \(addons.first!)"
        default:
            func multiRegistry(_ addons: some RandomAccessCollection<TypeSyntax>) -> IdentifierTypeSyntax {
                switch addons.count {
                case 2:
                    return IdentifierTypeSyntax(
                        name: "_MultiRegistry",
                        genericArgumentClause: .init(arguments: .init([
                            .init(argument: addons.first!, trailingComma: .commaToken()),
                            .init(argument: addons.last!)
                        ]))
                    )
                default:
                    return IdentifierTypeSyntax(
                        name: "_MultiRegistry",
                        genericArgumentClause: .init(arguments: .init([
                            .init(argument: addons.first!, trailingComma: .commaToken()),
                            .init(argument: multiRegistry(addons.dropFirst()))
                        ]))
                    )
                }
            }
            registries = "typealias Registries = \(multiRegistry(addons))"
        }
        
        // Other arguments
        var liveViewArguments = node.argumentList
        liveViewArguments = liveViewArguments.filter({
            switch $0.label?.text {
            case "addons":
                return false
            default:
                return true
            }
        })
        liveViewArguments = liveViewArguments.with(\.[liveViewArguments.index(before: liveViewArguments.endIndex)].trailingComma, nil)
        
        return """
        { () -> AnyView in
            enum \(registryName): AggregateRegistry {
                \(registries)
            }
        
            return AnyView(LiveView(registry: \(registryName).self, \(liveViewArguments))\(raw: node.trailingClosure?.description ?? "")\(node.additionalTrailingClosures))
        }()
        """
    }
    
    private static func transformAddon(_ element: ArrayElementSyntax) throws -> TypeSyntax {
        let genericArgumentClause = GenericArgumentClauseSyntax(arguments: .init([.init(argument: IdentifierTypeSyntax(name: .identifier("Self")))]))
        
        if let registry = element.expression.as(MemberAccessExprSyntax.self)?.base?.as(GenericSpecializationExprSyntax.self) {
            return TypeSyntax(#"\#(registry.expression)\#(genericArgumentClause)"#)
        } else if let member = element.expression.as(MemberAccessExprSyntax.self),
                  member.base == nil
        {
            let name = member.declName.baseName.text
            return TypeSyntax(MemberTypeSyntax(
                baseType: MemberTypeSyntax(baseType: IdentifierTypeSyntax(name: .identifier("LiveViewNative")), name: .identifier("Addons")),
                // transform camelCase name back to registry type name. See ``RegisterAddonMacro`` for the inverse transformation.
                name: .identifier(name.prefix(1).uppercased() + name.dropFirst()),
                genericArgumentClause: genericArgumentClause
            ))
        } else {
            throw LiveViewMacroError.invalidAddonElement
        }
    }
}

enum LiveViewMacroError: Error, CustomStringConvertible {
    case invalidAddonsSyntax
    case invalidAddonElement
    
    var description: String {
        switch self {
        case .invalidAddonsSyntax:
            return "Invalid value specified for 'addons'. Expected a static array literal."
        case .invalidAddonElement:
            return "Invalid addon provided. Expected a specialized registry type, such as 'AddonRegistry<Self>.self'"
        }
    }
}
