//
//  ASTDecodableError.swift
//  JSONStylesheet
//
//  Created by Carson Katri on 9/24/24.
//

import SwiftDiagnostics

struct SimpleDiagnosticMessage: DiagnosticMessage {
    var message: String
    var diagnosticID: MessageID
    var severity: DiagnosticSeverity
}
