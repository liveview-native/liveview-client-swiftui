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
        let signatures = declaration.memberBlock.members
            .compactMap({ member -> FunctionParameterListSyntax? in
                guard let decl: InitializerDeclSyntax = member.decl.as(InitializerDeclSyntax.self),
                      diagnoseParameters(decl.signature.parameterClause.parameters, in: context)
                else { return nil }
                return decl.signature.parameterClause.parameters
            })
        return [
            try ExtensionDeclSyntax("extension \(type.trimmed): ParseableModifier") {
                try VariableDeclSyntax("static var arguments: some Parser<Substring.UTF8View, Self>") {
                    #""[".utf8"#
                    FunctionCallExprSyntax(calledExpression: DeclReferenceExprSyntax(baseName: .identifier("OneOf")), trailingClosure: ClosureExprSyntax(statementsBuilder: {
                        for signature in signatures {
                            signatureParser(signature)
                        }
                    })) {
                        
                    }
                    #""]".utf8"#
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
           
        // All labelled arguments must be optional.
        for labelledArgument in parameters where labelledArgument.firstName.tokenKind != .wildcard {
            guard labelledArgument.type.is(OptionalTypeSyntax.self) else {
                context.diagnose(Diagnostic(
                    node: Syntax(labelledArgument.type),
                    message: SignatureError.RequiredLabelledArgument(),
                    fixIt: .replace(
                        message: SignatureError.RequiredLabelledArgument.FixIt(),
                        oldNode: labelledArgument.type,
                        newNode: OptionalTypeSyntax(wrappedType: labelledArgument.type)
                    )
                ))
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
            labelledArguments.first!.type
        default:
            TypeSyntax("(\(raw: labelledArguments.map({ "\($0.firstName.trimmed): \($0.type)" }).joined(separator: ",")))")
        }
        
        return ExprSyntax(#"""
        Parse({ (wildcard: \#(wildcardType), labelled: \#(labelledType)) -> Self in
            Self.init(
                \#(raw: (
                    (
                        wildcardArguments.count == 1
                            ? ["wildcard"]
                            : wildcardArguments.map({
                                "wildcard.\($0.secondName!.trimmed)"
                            })
                    ) + (
                        labelledArguments.count == 1
                            ? ["\(labelledArguments.first!.firstName.trimmed): labelled"]
                            : labelledArguments.map({
                                "\($0.firstName): labelled.\($0.firstName.trimmed)"
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
                    \#(wildcardArguments.enumerated().map({ (i, parameter) in
                        """
                        Whitespace()
                        \(parameter.type.as(OptionalTypeSyntax.self)?.wrappedType ?? parameter.type).parser()
                        Whitespace()
                        \(i == wildcardArguments.count - 1 && labelledArguments.isEmpty ? "" : #"",".utf8"#)
                        Whitespace()
                        """
                    }).joined(separator: "\n"))
                }
                """#
            )
        
            // Parse the labelled arguments
            \#(
                raw: labelledArguments.isEmpty ? "Always(false)" : #"""
                "[".utf8
                Many(
                    into: (\#(labelledArguments.count == 1
                        ? "\(labelledArguments.first!.type).none"
                        : labelledArguments.map({ "\($0.firstName.trimmed): \($0.type).none" }).joined(separator: ",")
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
                                \(parameter.type.as(OptionalTypeSyntax.self)?.wrappedType ?? parameter.type).parser()
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
                """#
            )
        }
        """#)
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
