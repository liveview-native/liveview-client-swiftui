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

enum AddonMacro {}

extension AddonMacro: PeerMacro {
    static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let baseName = declaration.as(StructDeclSyntax.self)?.name.text
        else { throw DiagnosticsError(syntax: node, message: "'@Addon' can only be applied to 'struct' types.", id: .missingRegistry) }
        
        guard baseName.first?.isUppercase == true
        else { throw DiagnosticsError(syntax: node, message: "Registry type name must start with an uppercase letter.", id: .invalidRegistryName) }
        
        var name = baseName

        // Lowercase the first character for camelCase.
        name = name.prefix(1).lowercased() + name.dropFirst()
        
        return [
            DeclSyntax(#"static var \#(raw: name): LiveViewNative.Addons { fatalError("Registered addons cannot be accessed outside of the #LiveView macro.") }"#)
        ]
    }
}

extension AddonMacro: ExtensionMacro {
    static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        [
            try ExtensionDeclSyntax(#"extension \#(type): LiveViewNative.CustomRegistry"#) {}
        ]
    }
}

struct AddonDiagnostic: DiagnosticMessage {
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
    init<S: SyntaxProtocol>(syntax: S, message: String, domain: String = "Addon", id: AddonDiagnostic.ID, severity: SwiftDiagnostics.DiagnosticSeverity = .error) {
        self.init(diagnostics: [
            Diagnostic(node: Syntax(syntax), message: AddonDiagnostic(message: message, domain: domain, id: id, severity: severity))
        ])
    }
}
