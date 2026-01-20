import SwiftUI
import SwiftSyntax

extension Shader: SyntaxConvertible {
    /// Parses Shader syntax from ShaderLibrary member access.
    /// Examples:
    /// - `ShaderLibrary.myShader()`
    /// - `ShaderLibrary.myShader(.float(1.0), .color(.red))`
    /// - `ShaderLibrary.default.myShader()`
    public init?(syntax: some SyntaxProtocol) {
        // Shader is created via ShaderLibrary.shaderName(...args...)
        // The syntax is a function call on a member access of ShaderLibrary
        guard let functionCall = syntax.as(FunctionCallExprSyntax.self) else {
            return nil
        }

        // Get the shader function name and library reference
        // Can be ShaderLibrary.shaderName() or ShaderLibrary.default.shaderName()
        guard let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self) else {
            return nil
        }

        let shaderName = memberAccess.declName.baseName.text

        // Verify this is a ShaderLibrary call by checking the base
        var isShaderLibrary = false

        // Check for ShaderLibrary.shaderName
        if let baseRef = memberAccess.base?.as(DeclReferenceExprSyntax.self),
           baseRef.baseName.text == "ShaderLibrary" {
            isShaderLibrary = true
        }

        // Check for ShaderLibrary.default.shaderName
        if let baseMemberAccess = memberAccess.base?.as(MemberAccessExprSyntax.self),
           let baseRef = baseMemberAccess.base?.as(DeclReferenceExprSyntax.self),
           baseRef.baseName.text == "ShaderLibrary" {
            isShaderLibrary = true
        }

        guard isShaderLibrary else {
            return nil
        }

        // Parse arguments
        var arguments: [Shader.Argument] = []
        for arg in functionCall.arguments {
            if let argument = Shader.Argument(syntax: arg.expression) {
                arguments.append(argument)
            } else {
                // If we can't parse an argument, fail the whole shader
                return nil
            }
        }

        // Create the shader function and shader
        let function = ShaderFunction(library: .default, name: shaderName)
        self.init(function: function, arguments: arguments)
    }
}

extension Shader.Argument: SyntaxConvertible {
    /// Parses Shader.Argument from syntax.
    /// Examples:
    /// - `.float(1.0)`
    /// - `.float2(0.5, 0.5)`
    /// - `.color(.red)`
    /// - `.colorArray([.red, .blue])`
    /// - `.boundingRect`
    public init?(syntax: some SyntaxProtocol) {
        // Handle simple member access for properties like .boundingRect
        if let memberAccess = syntax.as(MemberAccessExprSyntax.self),
           memberAccess.base == nil {
            switch memberAccess.declName.baseName.text {
            case "boundingRect":
                self = .boundingRect
                return
            default:
                return nil
            }
        }

        // Handle function calls like .float(1.0), .color(.red)
        guard let functionCall = syntax.as(FunctionCallExprSyntax.self),
              let memberAccess = functionCall.calledExpression.as(MemberAccessExprSyntax.self),
              memberAccess.base == nil else {
            return nil
        }

        let methodName = memberAccess.declName.baseName.text
        let args = functionCall.arguments

        switch methodName {
        case "float":
            guard args.count == 1,
                  let value = Float(syntax: args[0].expression) else {
                return nil
            }
            self = .float(value)

        case "float2":
            guard args.count == 2,
                  let x = Float(syntax: args[0].expression),
                  let y = Float(syntax: args[1].expression) else {
                return nil
            }
            self = .float2(x, y)

        case "float3":
            guard args.count == 3,
                  let x = Float(syntax: args[0].expression),
                  let y = Float(syntax: args[1].expression),
                  let z = Float(syntax: args[2].expression) else {
                return nil
            }
            self = .float3(x, y, z)

        case "float4":
            guard args.count == 4,
                  let x = Float(syntax: args[0].expression),
                  let y = Float(syntax: args[1].expression),
                  let z = Float(syntax: args[2].expression),
                  let w = Float(syntax: args[3].expression) else {
                return nil
            }
            self = .float4(x, y, z, w)

        case "color":
            guard args.count == 1,
                  let color = Color(syntax: args[0].expression) else {
                return nil
            }
            self = .color(color)

        case "colorArray":
            guard args.count == 1,
                  let arrayExpr = args[0].expression.as(ArrayExprSyntax.self) else {
                return nil
            }
            var colors: [Color] = []
            for element in arrayExpr.elements {
                guard let color = Color(syntax: element.expression) else {
                    return nil
                }
                colors.append(color)
            }
            self = .colorArray(colors)

        case "data":
            // Data arguments cannot be parsed from syntax
            return nil

        case "image":
            // Image arguments require a SwiftUI.Image which can't easily be parsed from syntax
            return nil

        default:
            return nil
        }
    }
}

extension Float: SyntaxConvertible {
    public init?(syntax: some SyntaxProtocol) {
        guard let doubleValue = Double(syntax: syntax) else {
            return nil
        }
        self = Float(doubleValue)
    }
}
