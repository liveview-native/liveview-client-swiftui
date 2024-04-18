//
//  AddonMacro.swift
//
//
//  Created by Carson Katri on 4/18/24.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

enum RegisterAddonMacro {
    static let suffix = "Registry"
}

extension RegisterAddonMacro: DeclarationMacro {
    static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let baseName = node.argumentList.first?
            .expression.as(MemberAccessExprSyntax.self)?
            .base?.as(GenericSpecializationExprSyntax.self)?
            .expression.as(DeclReferenceExprSyntax.self)?
            .baseName.text
        else { throw DiagnosticsError(syntax: node, message: "Missing or invalid `CustomRegistry` type. Pass a registry in the form `MyCustomRegistry<_>.self`.", id: .missingRegistry) }
        
        guard baseName.hasSuffix(suffix)
        else { throw DiagnosticsError(syntax: node, message: "Registry type name must have the 'Registry' suffix.", id: .invalidRegistryName) }
        
        guard baseName.first?.isUppercase == true
        else { throw DiagnosticsError(syntax: node, message: "Registry type name must start with an uppercase letter.", id: .invalidRegistryName) }
        
        var name = baseName
        
        // Remove `*Registry` suffix.
        if name != suffix {
          name = String(name.prefix(upTo: name.index(name.endIndex, offsetBy: -suffix.count)))
        }

        // Lowercase the first character for camelCase.
        name = name.prefix(1).lowercased() + name.dropFirst()
        
        return [
            DeclSyntax(#"static var \#(raw: name): LiveViewNative.AddonRegistry { fatalError("Registered addons cannot be accessed outside of the #LiveView macro.") }"#)
        ]
    }
}

struct RegisterAddonDiagnostic: DiagnosticMessage {
    enum ID: String {
        case missingRegistry = "missing registry argument"
        case invalidRegistryName = "invalid registry name"
    }
    
    var message: String
    var diagnosticID: MessageID
    var severity: DiagnosticSeverity
    
    init(message: String, diagnosticID: SwiftDiagnostics.MessageID, severity: SwiftDiagnostics.DiagnosticSeverity = .error) {
        self.message = message
        self.diagnosticID = diagnosticID
        self.severity = severity
    }
    
    init(message: String, domain: String, id: ID, severity: SwiftDiagnostics.DiagnosticSeverity = .error) {
        self.message = message
        self.diagnosticID = MessageID(domain: domain, id: id.rawValue)
        self.severity = severity
    }
}

extension DiagnosticsError {
    init<S: SyntaxProtocol>(syntax: S, message: String, domain: String = "RegisterAddon", id: RegisterAddonDiagnostic.ID, severity: SwiftDiagnostics.DiagnosticSeverity = .error) {
        self.init(diagnostics: [
            Diagnostic(node: Syntax(syntax), message: RegisterAddonDiagnostic(message: message, domain: domain, id: id, severity: severity))
        ])
    }
}
