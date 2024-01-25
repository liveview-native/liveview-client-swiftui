import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics

public enum ParseableExpressionMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let accessLevel: DeclModifierListSyntax = declaration.modifiers.first(where: {
            $0.name.tokenKind == .keyword(.private)
            || $0.name.tokenKind == .keyword(.public)
            || $0.name.tokenKind == .keyword(.fileprivate)
            || $0.name.tokenKind == .keyword(.internal)
        }).flatMap({ [$0] }) ?? []
        let signatures = declaration.memberBlock.members
            .compactMap({ member -> (FunctionParameterListSyntax, availability: AvailabilityArgumentListSyntax?, ifConfig: ExprSyntax?)? in
                let ifConfig: IfConfigClauseSyntax? = member.decl.as(IfConfigDeclSyntax.self)?.clauses.first?.as(IfConfigClauseSyntax.self)
                guard let decl: InitializerDeclSyntax = member.decl.as(InitializerDeclSyntax.self)
                        ?? ifConfig?.elements?.as(MemberBlockItemListSyntax.self)?.first?.decl.as(InitializerDeclSyntax.self),
                      diagnoseParameters(decl.signature.parameterClause.parameters, in: context)
                else { return nil }
                return (
                    decl.signature.parameterClause.parameters,
                    availability: decl.attributes.compactMap({ $0.as(AttributeSyntax.self)?.arguments?.as(AvailabilityArgumentListSyntax.self) }).first,
                    ifConfig: ifConfig?.condition
                )
            })
        return [
            try ExtensionDeclSyntax.init("extension \(type.trimmed): ParseableExpressionProtocol") {
                try TypeAliasDeclSyntax("\(accessLevel) typealias _ParserType = StandardExpressionParser<Self>")
                try StructDeclSyntax("\(accessLevel) struct ExpressionArgumentsBody: Parser") {
                    VariableDeclSyntax(.let, name: "context", type: TypeAnnotationSyntax(type: TypeSyntax("ParseableModifierContext")))
                    try FunctionDeclSyntax("func parse(_ input: inout Substring.UTF8View) throws -> \(type.trimmed)") {
                        #"try "[".utf8.parse(&input)"#
                        #"try Whitespace().parse(&input)"#
                        "let copy = input"
                        "var clauseFailures = [([String], ModifierParseError.ErrorType)]()"
                        for signature in signatures {
                            if let ifConfig = signature.ifConfig {
                                "#if \(ifConfig)"
                            }
                            if let availability = signature.availability {
                                "if #available(\(availability)) {"
                            }
                            "do {"
                            try signatureParser(signature.0)
                            "} catch let error as ModifierParseError {"
                            """
                                clauseFailures.append((
                                    \(ArrayElementSyntax(expression: ArrayExprSyntax(elementsBuilder: {
                                        for argument in signature.0 {
                                            ArrayElementSyntax(expression: StringLiteralExprSyntax(content: argument.firstName.text))
                                        }
                                    }))),
                                    error.error
                                ))
                            """
                            "   input = copy"
                            "} catch {"
                            "   input = copy"
                            "}"
                            if signature.availability != nil {
                                "\n}"
                            }
                            if signature.ifConfig != nil {
                                "\n#endif"
                            }
                        }
                        try IfExprSyntax("if clauseFailures.isEmpty {") {
                            """
                            throw ModifierParseError(error: .noMatchingClause(Output.name, \(ArrayExprSyntax(elementsBuilder: {
                                for signature in signatures {
                                    ArrayElementSyntax(expression: ArrayExprSyntax(elementsBuilder: {
                                        for argument in signature.0 {
                                            ArrayElementSyntax(expression: StringLiteralExprSyntax(content: argument.firstName.text))
                                        }
                                    }))
                                }
                            }))), metadata: context.metadata)
                            """
                        } else: {
                            "throw ModifierParseError(error: .multipleClauseErrors(Output.name, clauseFailures), metadata: context.metadata)"
                        }
                    }
                }
                try FunctionDeclSyntax("\(accessLevel) static func arguments(in context: ParseableModifierContext) -> ExpressionArgumentsBody") {
                    "ExpressionArgumentsBody(context: context)"
                }
            }
        ]
    }
    
    static func diagnoseParameters(_ parameters: FunctionParameterListSyntax, in context: some MacroExpansionContext) -> Bool {
        // All labelled arguments must appear at the end.
        if let lastWildcard = parameters.lastIndex(where: { $0.firstName.tokenKind == .wildcard }),
           let firstLabelled = parameters.lastIndex(where: { $0.firstName.tokenKind != .wildcard })
        {
            guard lastWildcard < firstLabelled else {
                context.diagnose(
                    Diagnostic(
                        node: Syntax(parameters),
                        message: SignatureError.LabelledArgumentsAtEnd(),
                        fixIt: .replace(
                            message: SignatureError.LabelledArgumentsAtEnd.FixIt(),
                            oldNode: parameters,
                            newNode: FunctionParameterListSyntax(
                                parameters.sorted(by: { a, b in
                                    switch (a.firstName.tokenKind == .wildcard, b.firstName.tokenKind == .wildcard) {
                                    case (false, true):
                                        return false
                                    default:
                                        return true
                                    }
                                })
                                .enumerated()
                                .map({ (offset, element) in
                                    element.with(\.trailingComma, offset == parameters.count - 1 ? nil : .commaToken(trailingTrivia: .space))
                                })
                            )
                        )
                    )
                )
                return false
            }
        }
        return true
    }
    
    @CodeBlockItemListBuilder
    static func signatureParser(_ signature: FunctionParameterListSyntax) throws -> CodeBlockItemListSyntax {
        let wildcardArguments = signature.filter {
            return $0.firstName.tokenKind == .wildcard && $0.secondName != nil
        }
        let labelledArguments = signature.filter {
            return $0.firstName.tokenKind != .wildcard
        }
        
        // wildcard arguments
        for (i, argument) in wildcardArguments.enumerated() {
            let wildcardParser = """
            Whitespace()
            \(i > 0 ? #"",".utf8"# : "")
            Whitespace()
            \(argument.type).parser(in: context)
            Whitespace()
            """
            if let defaultValue = argument.defaultValue {
                // allow argument to be omitted if default is available.
                """
                let \(raw: argument.secondName!.text): \(argument.type) = try OneOf(input: Substring.UTF8View.self, output: \(argument.type.trimmed).self) {
                    Parse {
                        \(raw: wildcardParser)
                    }
                    Always(\(defaultValue.value))
                }.parse(&input)
                """
            } else {
                """
                let \(raw: argument.secondName!.text): \(argument.type) = try Parse(input: Substring.UTF8View.self) {
                    \(raw: wildcardParser)
                }
                .parse(&input)
                """
            }
        }
        
        // labelled arguments
        if !labelledArguments.isEmpty {
            // comma separate from wildcard if present
            if !wildcardArguments.isEmpty {
                "try Whitespace().parse(&input)"
                #"try ",".utf8.parse(&input)"#
                "try Whitespace().parse(&input)"
            }
            
            #"try "[".utf8.parse(&input)"#
            
            // collect errors and values
            "var failures = [ModifierParseError.ErrorType]()"
            for argument in labelledArguments {
                "var \(argument.secondName ?? argument.firstName): \(argument.type.unwrapped.trimmed)?"
            }
            
            try WhileStmtSyntax("while !input.isEmpty {") {
                // switch over the argument name to parse the correct type
                "try Whitespace().parse(&input)"
                "let name = try Identifier().parse(&input)"
                #"try ":".utf8.parse(&input)"#
                "try Whitespace().parse(&input)"
                SwitchExprSyntax(subject: ExprSyntax("name")) {
                    for argument in labelledArguments {
                        // if parsing fails, add to `failures` and continue.
                        SwitchCaseSyntax("case \(StringLiteralExprSyntax(content: argument.firstName.text)):") {
                            """
                            let labelledArgumentCopy = input
                            do {
                                \(raw: argument.secondName?.text ?? argument.firstName.text) = try \(argument.type.unwrapped.trimmed)?.parser(in: context).parse(&input)
                            } catch {
                                input = labelledArgumentCopy
                                let value = try _AnyNodeParser.AnyArgument(context: context).parse(&input)
                                failures.append(
                                    .incorrectArgumentValue("\(argument.firstName.trimmed)", value: value, expectedType: \(argument.type.unwrapped.trimmed).self, replacement: \(valueReplacement(for: argument.type)))
                                )
                            }
                            """
                        }
                    }
                    SwitchCaseSyntax("default:") {
                        """
                        _ = try _AnyNodeParser.AnyArgument(context: context).parse(&input)
                        failures.append(.unknownArgument(name))
                        """
                    }
                }
                "try Whitespace().parse(&input)"
                // continue parsing labelled arguments if a comma is found
                try GuardStmtSyntax(#"guard input.first == ",".utf8.first else {"#) {
                    BreakStmtSyntax()
                }
                #"try ",".utf8.parse(&input)"#
            }
            
            #"try "]".utf8.parse(&input)"#
            
            // if any failures occurred, throw them
            try GuardStmtSyntax("guard failures.isEmpty else {") {
                "throw ModifierParseError(error: .multipleErrors(failures), metadata: context.metadata)"
            }
        }
        
        #"try Whitespace().parse(&input)"#
        #"try "]".utf8.parse(&input)"#
        
        // require arguments that are not optional and have no default
        for argument in labelledArguments {
            if !argument.type.is(OptionalTypeSyntax.self) && argument.defaultValue == nil {
                try GuardStmtSyntax("guard let \(argument.secondName ?? argument.firstName) else {") {
                    """
                    throw ModifierParseError(
                        error: .missingRequiredArgument(\(StringLiteralExprSyntax(content: argument.firstName.text))),
                        metadata: context.metadata
                    )
                    """
                }
            }
        }
        
        // create and return `Output` using the parsed arguments.
        ReturnStmtSyntax(expression: FunctionCallExprSyntax.init(
            calledExpression: DeclReferenceExprSyntax(baseName: "Output"),
            leftParen: .leftParenToken(),
            arguments: LabeledExprListSyntax {
                for argument in wildcardArguments {
                    LabeledExprSyntax(label: nil, expression: DeclReferenceExprSyntax(baseName: argument.secondName!))
                }
                for argument in labelledArguments {
                    if let defaultValue = argument.defaultValue {
                        LabeledExprSyntax(
                            label: argument.firstName.text,
                            expression: InfixOperatorExprSyntax(
                                leftOperand: DeclReferenceExprSyntax(baseName: argument.secondName ?? argument.firstName).trimmed.with(\.trailingTrivia, .space),
                                operator: BinaryOperatorExprSyntax(operator: "??"),
                                rightOperand: defaultValue.value.trimmed.with(\.leadingTrivia, .space)
                            )
                        )
                    } else {
                        LabeledExprSyntax(
                            label: argument.firstName.text,
                            expression: DeclReferenceExprSyntax(baseName: argument.secondName ?? argument.firstName)
                        )
                    }
                }
            },
            rightParen: .rightParenToken()
        ))
    }
    
    /// Suggest a replacement for a given argument type.
    static func valueReplacement(for type: TypeSyntax) -> ExprSyntax {
        switch type.unwrapped.as(IdentifierTypeSyntax.self)?.name.trimmedDescription ?? type.unwrapped.trimmedDescription {
        case "ViewReference", "InlineViewReference", "TextReference", "ToolbarContentReference":
            return ".viewReference"
        case "ChangeTracked":
            return ".changeTracked"
        case "Event":
            return ".event"
        default:
            return "nil"
        }
    }
    
    enum SignatureError {
        static let domain = "ParseableExpression.SignatureError"
        
        struct RequiredLabelledArgument: DiagnosticMessage {
            let message = "Labelled arguments must be optional"
            
            let diagnosticID: MessageID = .init(domain: SignatureError.domain, id: "RequiredLabelledArgument")
            
            let severity: DiagnosticSeverity = .error
            
            struct FixIt: FixItMessage {
                let message: String = "Add '?'"
                
                let fixItID: MessageID = .init(domain: SignatureError.domain, id: "RequiredLabelledArgument.FixIt")
            }
        }
        
        struct LabelledArgumentsAtEnd: DiagnosticMessage {
            let message = "Labelled arguments must appear after wildcard arguments"
            
            let diagnosticID: MessageID = .init(domain: SignatureError.domain, id: "LabelledArgumentsAtEnd")
            
            let severity: DiagnosticSeverity = .error
            
            struct FixIt: FixItMessage {
                let message: String = "Reorder arguments"
                
                let fixItID: MessageID = .init(domain: SignatureError.domain, id: "LabelledArgumentsAtEnd.FixIt")
            }
        }
    }
}

private extension TypeSyntax {
    var unwrapped: TypeSyntax {
        self.as(OptionalTypeSyntax.self)?.wrappedType ?? self
    }
}
