import SwiftParser
import SwiftSyntax
import Foundation

// MARK: - Model Types

struct MethodParameter {
    let label: String?
    let name: String
    let type: String
    let defaultValue: String?
    let isOptional: Bool
}

struct MethodSignature {
    let name: String
    let parameters: [MethodParameter]
    let returnType: String
    let availability: String?
}

struct ModifierDefinition {
    let baseName: String
    let signatures: [MethodSignature]
}

// MARK: - Interface Parser

class SwiftInterfaceParser {
    func parseModifiers(from fileContent: String) -> [ModifierDefinition] {
        let syntax = Parser.parse(source: fileContent)
        let visitor = ModifierExtractionVisitor(viewMode: .sourceAccurate)
        visitor.walk(syntax)
        
        // Group methods by base name
        var methodsByName: [String: [MethodSignature]] = [:]
        for method in visitor.methods {
            methodsByName[method.name, default: []].append(method)
        }
        
        return methodsByName.map { name, signatures in
            ModifierDefinition(baseName: name, signatures: signatures)
        }.sorted { $0.baseName < $1.baseName }
    }
}

class ModifierExtractionVisitor: SyntaxVisitor {
    var methods: [MethodSignature] = []
    private var currentAvailability: String?
    
    override func visit(_ node: AttributeSyntax) -> SyntaxVisitorContinueKind {
        if node.attributeName.trimmedDescription == "available" {
            currentAvailability = node.trimmedDescription
        }
        return .visitChildren
    }
    
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        let methodName = node.name.text
        
        // Parse parameters
        var parameters: [MethodParameter] = []
        for param in node.signature.parameterClause.parameters {
            let label = param.firstName.text == "_" ? nil : param.firstName.text
            let name = param.secondName?.text ?? param.firstName.text
            let type = param.type.trimmedDescription
            let defaultValue = param.defaultValue?.value.trimmedDescription
            let isOptional = type.hasSuffix("?")
            
            parameters.append(MethodParameter(
                label: label,
                name: name,
                type: type,
                defaultValue: defaultValue,
                isOptional: isOptional
            ))
        }
        
        let returnType = node.signature.returnClause?.type.trimmedDescription ?? "Void"
        
        methods.append(MethodSignature(
            name: methodName,
            parameters: parameters,
            returnType: returnType,
            availability: currentAvailability
        ))
        
        currentAvailability = nil
        return .skipChildren
    }
}

// MARK: - Code Generator

class ModifierCodeGenerator {
    func generateModifierEnum(for definition: ModifierDefinition) -> String {
        let enumName = definition.baseName.capitalized + "Modifier"
        var code = """
        enum \(enumName): ViewModifier {
        
        """
        
        // Generate cases
        for (index, signature) in definition.signatures.enumerated() {
            let caseName = generateCaseName(for: signature, index: index)
            let caseParams = signature.parameters.map { param in
                let baseType = param.type.replacingOccurrences(of: "?", with: "")
                return "\(baseType)\(param.isOptional ? "?" : "")"
            }.joined(separator: ", ")
            
            if caseParams.isEmpty {
                code += "    case \(caseName)\n"
            } else {
                code += "    case \(caseName)(\(caseParams))\n"
            }
        }
        
        code += "\n"
        
        // Generate init
        code += generateInit(for: definition)
        code += "\n"
        
        // Generate body
        code += generateBody(for: definition)
        
        code += "}\n"
        
        return code
    }
    
    private func generateCaseName(for signature: MethodSignature, index: Int) -> String {
        if signature.parameters.isEmpty {
            return "identity"
        }
        
        let paramNames = signature.parameters.map { param in
            param.label ?? param.name
        }
        
        return paramNames.joined(separator: "And")
    }
    
    private func generateInit(for definition: ModifierDefinition) -> String {
        var code = """
            init?(arguments: LabeledExprListSyntax) {
                switch arguments.count {
        
        """
        
        // Group signatures by parameter count
        var signaturesByCount: [Int: [MethodSignature]] = [:]
        for signature in definition.signatures {
            signaturesByCount[signature.parameters.count, default: []].append(signature)
        }
        
        for (count, signatures) in signaturesByCount.sorted(by: { $0.key < $1.key }) {
            code += "        case \(count):\n"
            
            if signatures.count == 1 {
                let signature = signatures[0]
                if signature.parameters.isEmpty {
                    code += "            self = .identity\n"
                } else {
                    code += generateParsingLogic(for: signature, paramCount: count)
                }
            } else {
                // Multiple signatures with same param count - need disambiguation
                code += "            // Multiple overloads with \(count) parameter(s)\n"
                for (index, signature) in signatures.enumerated() {
                    code += generateParsingLogic(for: signature, paramCount: count, disambiguate: true, isFirst: index == 0)
                }
            }
            code += "\n"
        }
        
        code += """
                default:
                    return nil
                }
            }
        
        """
        
        return code
    }
    
    private func generateParsingLogic(for signature: MethodSignature, paramCount: Int, disambiguate: Bool = false, isFirst: Bool = true) -> String {
        var code = ""
        let caseName = generateCaseName(for: signature, index: 0)
        
        if signature.parameters.isEmpty {
            return "            self = .\(caseName)\n"
        }
        
        // Generate parsing for each parameter
        var parsedVars: [String] = []
        for (index, param) in signature.parameters.enumerated() {
            let varName = "param\(index)"
            parsedVars.append(varName)
            
            let argAccess = if param.label == nil {
                "arguments[\(index)].expression"
            } else {
                "arguments.first(where: { $0.label?.text == \"\(param.label!)\" })?.expression"
            }
            
            let baseType = param.type.replacingOccurrences(of: "?", with: "")
            let simplifiedType = simplifyType(baseType)
            
            if disambiguate && index == 0 {
                let condition = isFirst ? "if" : "else if"
                code += "            \(condition) let expr = \(argAccess),\n"
                code += "               let \(varName) = \(simplifiedType)(expr) {\n"
            } else if param.isOptional {
                code += "            let \(varName) = \(argAccess).flatMap { \(simplifiedType)($0) }\n"
            } else {
                code += "            guard let expr\(index) = \(argAccess),\n"
                code += "                  let \(varName) = \(simplifiedType)(expr\(index)) else {\n"
                code += "                return nil\n"
                code += "            }\n"
            }
        }
        
        let caseArgs = parsedVars.joined(separator: ", ")
        if disambiguate && !signature.parameters.isEmpty {
            code += "                self = .\(caseName)(\(caseArgs))\n"
            code += "            }"
        } else {
            code += "            self = .\(caseName)(\(caseArgs))\n"
        }
        
        return code
    }
    
    private func generateBody(for definition: ModifierDefinition) -> String {
        var code = """
            func body(content: Content) -> some View {
                switch self {
        
        """
        
        for (index, signature) in definition.signatures.enumerated() {
            let caseName = generateCaseName(for: signature, index: index)
            
            if signature.parameters.isEmpty {
                code += "        case .\(caseName):\n"
                code += "            content.\(definition.baseName)()\n"
            } else {
                let caseBindings = signature.parameters.enumerated().map { idx, _ in
                    "param\(idx)"
                }.joined(separator: ", ")
                
                code += "        case .\(caseName)(let \(caseBindings)):\n"
                
                let methodArgs = signature.parameters.enumerated().map { idx, param -> String in
                    if let label = param.label {
                        return "\(label): param\(idx)"
                    }
                    return "param\(idx)"
                }.joined(separator: ", ")
                
                code += "            content.\(definition.baseName)(\(methodArgs))\n"
            }
        }
        
        code += """
                }
            }
        
        """
        
        return code
    }
    
    private func simplifyType(_ type: String) -> String {
        // Remove module prefixes
        let components = type.components(separatedBy: ".")
        return components.last ?? type
    }
}

// MARK: - Main Executable

@main
struct ModifierGenerator {
    static func main() {
        let arguments = CommandLine.arguments
        
        guard arguments.count == 2 else {
            fputs("Usage: modifier-generator <path-to-swiftinterface-file>\n", stderr)
            exit(1)
        }
        
        let filePath = arguments[1]
        
        guard FileManager.default.fileExists(atPath: filePath) else {
            fputs("Error: File not found at path: \(filePath)\n", stderr)
            exit(1)
        }
        
        guard let fileContent = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            fputs("Error: Could not read file at path: \(filePath)\n", stderr)
            exit(1)
        }
        
        let parser = SwiftInterfaceParser()
        let modifiers = parser.parseModifiers(from: fileContent)
        
        let generator = ModifierCodeGenerator()
        
        // Print header
        print("// Generated from: \(filePath)")
        print("// Date: \(Date())")
        print()
        print("import SwiftUI")
        print("import SwiftSyntax")
        print()
        print("// MARK: - Generated Modifiers")
        print()
        
        for modifier in modifiers {
            let code = generator.generateModifierEnum(for: modifier)
            print(code)
            print()
        }
    }
}
