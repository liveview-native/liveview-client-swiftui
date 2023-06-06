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

/// Implementation of the `#AggregateRegistry` macro, which takes an expression
/// of any type and produces a tuple containing the value of that expression
/// and the source code that produced the value. For example
///
///     struct MyAppRegistry: RootRegistry {
///         #Registries(
///             AVKitRegistry.self,
///             PhotoKitRegistry.self
///         )
///     }
///
///  will expand to
///
///     _MultiRegistry
public enum RegistriesMacro {}

extension RegistriesMacro: DeclarationMacro {
    public static func expansion<Node, Context>(
        of node: Node,
        in context: Context
    ) throws -> [DeclSyntax]
        where Node: FreestandingMacroExpansionSyntax, Context: MacroExpansionContext
    {
        guard let registries = node.genericArguments?.arguments
        else { throw RegistriesMacroError.missingArguments }
        
        switch registries.count {
        case 0:
            throw RegistriesMacroError.missingArguments
        case 1:
            return ["typealias Registries = \(registries.first!)"]
        default:
            func multiRegistry(_ registries: GenericArgumentListSyntax) -> SimpleTypeIdentifierSyntax {
                switch registries.count {
                case 2:
                    return SimpleTypeIdentifierSyntax(
                        name: "_MultiRegistry",
                        genericArgumentClause: .init(arguments: registries)
                    )
                default:
                    return SimpleTypeIdentifierSyntax(
                        name: "_MultiRegistry",
                        genericArgumentClause: .init(arguments: .init([
                            registries.first!,
                            .init(argumentType: multiRegistry(registries.removingFirst()))
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
