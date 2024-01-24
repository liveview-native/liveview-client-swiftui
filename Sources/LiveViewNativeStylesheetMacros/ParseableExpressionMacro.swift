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
                        "var errors: [([String], ModifierParseError.ErrorType)]"
                        "errors = []"
                        for signature in signatures {
                            if let ifConfig = signature.ifConfig {
                                "#if \(ifConfig)"
                            }
                            if let availability = signature.availability {
                                "if #available(\(availability)) {"
                            }
                            "do {"
                            "   return try"
                            signatureParser(signature.0)
                            "   .parse(&input)"
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
                        """
                        if errors.count > 1 {
                            throw ModifierParseError(error: .multipleClauseErrors(Output.name, errors), metadata: context.metadata)
                        } else if let error = errors.first {
                            throw ModifierParseError(error: error.1, metadata: context.metadata)
                        } else {
                            throw ModifierParseError(error: .noMatchingClause(Output.name, \(ArrayExprSyntax(elementsBuilder: {
                                for signature in signatures {
                                    ArrayElementSyntax(expression: ArrayExprSyntax(elementsBuilder: {
                                        for argument in signature.0 {
                                            ArrayElementSyntax(expression: StringLiteralExprSyntax(content: argument.firstName.text))
                                        }
                                    }))
                                }
                            }))), metadata: context.metadata)
                        }
                        """
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
    
    static func signatureParser(_ signature: FunctionParameterListSyntax) -> ExprSyntax {
        let wildcardArguments = signature.filter {
            return $0.firstName.tokenKind == .wildcard && $0.secondName != nil
        }
        let labelledArguments = signature.filter {
            return $0.firstName.tokenKind != .wildcard
        }
        let wildcardType = switch wildcardArguments.count {
        case 0:
            TypeSyntax("Bool")
        case 1:
            wildcardArguments.first!.type
        default:
            TypeSyntax("(\(raw: wildcardArguments.map({ "\($0.secondName!.trimmed): \($0.type)" }).joined(separator: ",")))")
        }
        let labelledType = switch labelledArguments.count {
        case 0:
            TypeSyntax("Bool")
        case 1:
            TypeSyntax("\(labelledArguments.first!.type.unwrapped.trimmed)?")
        default:
            TypeSyntax("(\(raw: labelledArguments.map({ "\($0.firstName.trimmed): \($0.type.unwrapped.trimmed)?" }).joined(separator: ",")))")
        }
        
        return ExprSyntax(#"""
        _ThrowingParse({ (wildcard: \#(wildcardType), labelled: \#(labelledType)) -> Output in
            \#(raw: labelledArguments.filter({ !$0.type.is(OptionalTypeSyntax.self) && $0.defaultValue == nil }).map({
                if labelledArguments.count == 1 {
                    return """
                    guard let labelled
                    else { throw ModifierParseError(error: .missingRequiredArgument("\($0.firstName.trimmed)"), metadata: context.metadata) }
                    """
                } else {
                    return """
                    guard let `\($0.firstName.trimmed)` = labelled.\($0.firstName.trimmed)
                    else { throw ModifierParseError(error: .missingRequiredArgument("\($0.firstName.trimmed)"), metadata: context.metadata) }
                    """
                }
            }).joined(separator: "\n"))
            return Output.init(
                \#(raw: (
                    (
                        wildcardArguments.count == 1
                            ? ["wildcard"]
                            : wildcardArguments.map({
                                "wildcard.\($0.secondName!.trimmed)"
                            })
                    ) + (
                        labelledArguments.count == 1
                            ? [
                                (!labelledArguments.first!.type.is(OptionalTypeSyntax.self) && labelledArguments.first!.defaultValue == nil)
                                    ? "\(labelledArguments.first!.firstName.trimmed): labelled"
                                    : """
                                    \(labelledArguments.first!.firstName.trimmed): labelled\(
                                        labelledArguments.first!.defaultValue.flatMap({ " ?? \($0.value)" }) ?? ""
                                    )
                                    """
                            ]
                            : labelledArguments.map({
                                if !$0.type.is(OptionalTypeSyntax.self) && $0.defaultValue == nil {
                                    return """
                                    \($0.firstName): `\($0.firstName.trimmed)`
                                    """
                                } else {
                                    return """
                                    \($0.firstName): labelled.\($0.firstName.trimmed)\(
                                        $0.defaultValue.flatMap({ " ?? \($0.value)" }) ?? ""
                                    )
                                    """
                                }
                            })
                    )
                ).joined(separator: ","))
            )
        }) {
            // Parse the wildcard arguments
            \#(
                raw: wildcardArguments.isEmpty ? "Always(false)" : #"""
                Parse({ \#(wildcardArguments.map({ $0.secondName!.trimmed.text }).joined(separator: ",")) -> \#(wildcardType) in
                    (\#(wildcardArguments.count == 1
                        ? "\(wildcardArguments.first!.secondName!.trimmed)"
                        : wildcardArguments.map({
                        "\($0.secondName!): \($0.secondName!.trimmed)"
                            }).joined(separator: ",")
                    ))
                }) {
                    \#(wildcardArguments.enumerated().map({ (i, parameter) -> String in
                        let wildcardParser = """
                        Whitespace()
                        \(i > 0 ? #"",".utf8"# : "")
                        Whitespace()
                        \(parameter.type).parser(in: context)
                        Whitespace()
                        """
                        // allow argument to be omitted if default is available.
                        if let defaultValue = parameter.defaultValue {
                            return """
                            OneOf {
                                Parse {
                                    \(wildcardParser)
                                }
                                Always(\(defaultValue.value))
                            }
                            """
                        } else {
                            return wildcardParser
                        }
                    }).joined(separator: "\n"))
                }
                """#
            )
        
            // Parse the labelled arguments
            \#(
                raw: labelledArguments.isEmpty ? "Always(false)" : #"""
                OneOf {
                    Parse {
                        \#(!wildcardArguments.isEmpty
                            ? #"""
                            Whitespace()
                            ",".utf8
                            Whitespace()
                            """#
                            : ""
                        )
                        "[".utf8
                        Many(
                            into: (\#(labelledArguments.count == 1
                                ? "\(labelledArguments.first!.type.unwrapped.trimmed)?.none"
                                : labelledArguments.map({ "\($0.firstName.trimmed): \($0.type.unwrapped.trimmed)?.none" }).joined(separator: ",")
                            ))
                        ) { (result: inout \#(labelledType), argument: \#(labelledType)) in
                            result = (
                                \#(labelledArguments.count == 1
                                    ? "result ?? argument"
                                    : labelledArguments.map({ parameter in
                                        "result.\(parameter.firstName.trimmed) ?? argument.\(parameter.firstName.trimmed)"
                                    }).joined(separator: ",")
                                )
                            )
                        } element: {
                            Whitespace()
                            OneOf {
                                \#(labelledArguments.map({ parameter in
                                    """
                                    Parse({ value -> \(labelledType) in
                                        (\(labelledArguments.count == 1
                                            ? "value"
                                            : labelledArguments.map({ assignmentParameter in
                                                    if assignmentParameter.firstName.tokenKind == parameter.firstName.tokenKind {
                                                        return "\(assignmentParameter.firstName.trimmed): value"
                                                    } else {
                                                        return "\(assignmentParameter.firstName.trimmed): .none"
                                                    }
                                                }).joined(separator: ",")
                                        ))
                                    }) {
                                        "\(parameter.firstName.trimmed):".utf8
                                        Whitespace()
                                        OneOf(input: Substring.UTF8View.self, output: \(parameter.type.unwrapped.trimmed)?.self) {
                                            \(parameter.type.unwrapped.trimmed)?.parser(in: context)
                                            _AnyNodeParser.AnyArgument(context: context).map { value in
                                                errors.append(
                                                    (
                                                        \(ArrayElementSyntax(expression: ArrayExprSyntax(elementsBuilder: {
                                                            for argument in signature {
                                                                ArrayElementSyntax(expression: StringLiteralExprSyntax(content: argument.firstName.text))
                                                            }
                                                        }))),
                                                        .incorrectArgumentValue("\(parameter.firstName.trimmed)", value: value, expectedType: \(parameter.type.unwrapped.trimmed).self, replacement: \(valueReplacement(for: parameter.type)))
                                                    )
                                                )
                                                return nil
                                            }
                                        }
                                    }
                                    """
                                }).joined(separator: "\n"))
                                _ErrorParse {
                                    Identifier().map(ArgumentParseError.unknownArgument)
                                    ":".utf8
                                    Whitespace()
                                }
                            }
                            Whitespace()
                        } separator: {
                            ",".utf8
                        } terminator: {
                            "]".utf8
                        }
                    }
                    Always((\#(labelledArguments.count == 1
                            ? "\(labelledArguments.first!.type.unwrapped.trimmed)?.none"
                            : labelledArguments.map({ "\($0.firstName.trimmed): \($0.type.unwrapped.trimmed)?.none" }).joined(separator: ","))))
                }
                """#
            )
            Whitespace()
            "]".utf8
        }
        """#)
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
