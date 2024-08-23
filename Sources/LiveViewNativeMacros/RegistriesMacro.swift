//
//  RegistriesMacro.swift
//
//
//  Created by Carson Katri on 6/6/23.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Implementation of the `#Registries` macro, which creates the `Registries` typealias for an `AggregateRegistry`.
///
/// For example
///
///     #Registries<
///         MyAppRegistry,
///         AVKitRegistry<Self>,
///         PhotoKitRegistry<Self>
///     >
///
///  will expand to
///
///     _MultiRegistry<
///         MyAppRegistry,
///         _MultiRegistry<
///             AVKitRegistry<Self>,
///             PhotoKitRegistry<Self>
///         >
///     >
public enum RegistriesMacro {}

extension RegistriesMacro: DeclarationMacro {
    public static func expansion<Node, Context>(
        of node: Node,
        in context: Context
    ) throws -> [DeclSyntax]
        where Node: FreestandingMacroExpansionSyntax, Context: MacroExpansionContext
    {
        guard let registries = node.genericArgumentClause?.arguments
        else { throw RegistriesMacroError.missingArguments }
        
        switch registries.count {
        case 0:
            throw RegistriesMacroError.missingArguments
        case 1:
            return ["typealias Registries = \(registries.first!)"]
        default:
            func multiRegistry(_ registries: GenericArgumentListSyntax) -> IdentifierTypeSyntax {
                switch registries.count {
                case 2:
                    return IdentifierTypeSyntax(
                        name: "_MultiRegistry",
                        genericArgumentClause: .init(arguments: registries)
                    )
                default:
                    return IdentifierTypeSyntax(
                        name: "_MultiRegistry",
                        genericArgumentClause: .init(arguments: .init([
                            registries.first!,
                            .init(argument: multiRegistry(.init(registries.dropFirst())))
                        ]))
                    )
                }
            }
            
            return ["typealias Registries = \(multiRegistry(registries))"]
        }
    }
}

enum RegistriesMacroError: CustomStringConvertible, Error {
    case missingArguments
    
    var description: String {
        switch self {
        case .missingArguments:
            return "No registry types provided as generic arguments."
        }
    }
}
