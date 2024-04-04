//
//  LiveElementMacro.swift
//
//
//  Created by Carson Katri on 4/2/24.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public enum LiveElementMacro {
    static let moduleName = "LiveViewNative"
    
    static let elementMacroName = "LiveElement"
    static let attributeMacroName = "LiveAttribute"
    static let ignoredMacroName = "LiveElementIgnored"
    
    static let eventPropertyWrapperName = "Event"
    
    static let elementVariableName = "liveElement"
    
    static func elementVariable() -> DeclSyntax {
        return "@\(raw: ignoredMacroName) @_LiveElementTracked<Root, _TrackedContent> private var \(raw: elementVariableName) = _TrackedContent()"
    }
    
    static let elementNodeTypeName = "ElementNode"
    static var qualifiedElementNodeType: TypeSyntax {
        "\(raw: moduleName).\(raw: elementNodeTypeName)"
    }
    
    static let trackedContentStructName = "_TrackedContent"
    static let trackedContentProtocolName = "_LiveElementTrackedContent"
    static var qualifiedTrackedContentProtocol: TypeSyntax {
        "\(raw: moduleName).\(raw: trackedContentProtocolName)"
    }
    static func trackedContentStruct(_ members: MemberBlockItemListSyntax?) -> DeclSyntax {
        let properties: [VariableDeclSyntax] = members?.compactMap({ member in
            guard let property = member.decl.as(VariableDeclSyntax.self),
                  property.identifier != nil,
                  property.isValidForAttribute
            else { return nil }
            if property.hasMacroApplication(ignoredMacroName) ||
                property.hasMacroApplication(eventPropertyWrapperName)
            {
                return nil
            }
            return property
        }) ?? []
        
        let propertyCases = properties
            .reduce(into: ([String](), [String]())) { result, property in
                // check if the attribute name was customized.
                let attributeMacroCondition = property.attributes.lazy.compactMap({ (attribute) -> LabeledExprListSyntax? in
                    switch attribute {
                    case let .attribute(attribute):
                        guard attribute.attributeName.identifier == attributeMacroName,
                              case let .argumentList(arguments) = attribute.arguments
                        else { return nil }
                        return arguments
                    default:
                        return nil
                    }
                })
                    .first
                    .flatMap({ $0.first?.expression })
                let decodeStmt = #"""
                do {
                self.\#(property.identifier?.text ?? "") = try \#(property.type?.trimmedDescription ?? "").init(from: attribute, on: element)
                } catch {}
                """#
                if let attributeMacroCondition {
                    result.1.append(#"""
                    if attribute.name == \#(attributeMacroCondition) {
                    \#(decodeStmt)
                    continue
                    }
                    """#)
                } else {
                    result.0.append(#"""
                    case (nil, "\#(property.identifier?.text ?? "")"):
                    \#(decodeStmt)
                    continue
                    """#)
                }
            }
        
        return #"""
        private struct _TrackedContent: _LiveElementTrackedContent {
        \#(raw: properties.map({ property in
        #"""
        \#(property.with(\.bindingSpecifier, .keyword(.var, trailingTrivia: .space)).with(\.modifiers, []).with(\.attributes, []))
        """#
        }).joined(separator: "\n"))
        
        init() {}
        
        init(from element: ElementNode) throws {
        for attribute in element.attributes {
        switch (attribute.name.namespace, attribute.name.name) {
        \#(raw: propertyCases.0.joined(separator: "\n"))
        default:
        \#(raw: propertyCases.1.joined(separator: "\n"))
        continue
        }
        }
        }
        }
        """#
    }
}

extension LiveElementMacro: MemberAttributeMacro {
    public static func expansion(
      of node: AttributeSyntax,
      attachedTo declaration: some DeclGroupSyntax,
      providingAttributesFor member: some DeclSyntaxProtocol,
      in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        guard let property = member.as(VariableDeclSyntax.self),
              property.identifier != nil,
              property.isValidForAttribute
        else { return [] }
        
        if property.hasMacroApplication(ignoredMacroName) ||
            property.hasMacroApplication(attributeMacroName) ||
            property.hasMacroApplication(eventPropertyWrapperName)
        {
            return []
        }
        
        return [
            AttributeSyntax(attributeName: IdentifierTypeSyntax(name: .identifier(attributeMacroName)))
        ]
    }
}

extension LiveElementMacro: MemberMacro {
    public static func expansion(
      of node: AttributeSyntax,
      providingMembersOf declaration: some DeclGroupSyntax,
      in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let identified = declaration.asProtocol(NamedDeclSyntax.self) else {
            return []
        }
        
        let elementType = identified.name.trimmed
        
        guard declaration.isStruct else {
            // enumerations cannot store properties
            throw DiagnosticsError(syntax: node, message: "'@LiveElement' cannot be applied to non-struct type '\(elementType.text)'", id: .invalidApplication)
        }
        
        var declarations = [DeclSyntax]()
        
        declaration.addIfNeeded(elementVariable(), to: &declarations)
        
        declaration.addIfNeeded(trackedContentStruct(identified.as(StructDeclSyntax.self)?.memberBlock.members), to: &declarations)
        
        return declarations
    }
}

extension LiveElementMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        // This method can be called twice - first with an empty `protocols` when
        // no conformance is needed, and second with a `MissingTypeSyntax` instance.
        if protocols.isEmpty {
            return []
        }
        
        let decl: DeclSyntax = "extension \(raw: type.trimmedDescription): SwiftUI.View {}"
        let ext = decl.cast(ExtensionDeclSyntax.self)
        
        if let availability = declaration.attributes.availability {
            return [ext.with(\.attributes, availability)]
        } else {
            return [ext]
        }
    }
}

public struct LiveAttributeMacro: AccessorMacro {
    public static func expansion<
        Context: MacroExpansionContext,
        Declaration: DeclSyntaxProtocol
    >(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: Declaration,
        in context: Context
    ) throws -> [AccessorDeclSyntax] {
        guard let property = declaration.as(VariableDeclSyntax.self),
              property.isValidForAttribute,
              let identifier = property.identifier?.trimmed else {
            return []
        }
        
        if property.hasMacroApplication(LiveElementMacro.ignoredMacroName) {
            return []
        }
        
        let getAccessor: AccessorDeclSyntax =
            """
            get {
                return \(raw: LiveElementMacro.elementVariableName).\(identifier)
            }
            """
        
        return [getAccessor]
    }
}

public struct LiveElementIgnoredMacro: AccessorMacro {
    public static func expansion<
        Context: MacroExpansionContext,
        Declaration: DeclSyntaxProtocol
    >(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: Declaration,
        in context: Context
    ) throws -> [AccessorDeclSyntax] {
        return []
    }
}

extension VariableDeclSyntax {
    var isValidForAttribute: Bool {
        !isComputed && isInstance && !isImmutable && identifier != nil
    }
}

struct LiveElementDiagnostic: DiagnosticMessage {
    enum ID: String {
        case invalidApplication = "invalid type"
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
    init<S: SyntaxProtocol>(syntax: S, message: String, domain: String = "LiveElement", id: LiveElementDiagnostic.ID, severity: SwiftDiagnostics.DiagnosticSeverity = .error) {
        self.init(diagnostics: [
            Diagnostic(node: Syntax(syntax), message: LiveElementDiagnostic(message: message, domain: domain, id: id, severity: severity))
        ])
    }
}

// MARK: Helpers

extension VariableDeclSyntax {
  var identifierPattern: IdentifierPatternSyntax? {
    bindings.first?.pattern.as(IdentifierPatternSyntax.self)
  }
  
  var isInstance: Bool {
    for modifier in modifiers {
      for token in modifier.tokens(viewMode: .all) {
        if token.tokenKind == .keyword(.static) || token.tokenKind == .keyword(.class) {
          return false
        }
      }
    }
    return true
  }
  
  var identifier: TokenSyntax? {
    identifierPattern?.identifier
  }
  
  var type: TypeSyntax? {
    bindings.first?.typeAnnotation?.type
  }

  func accessorsMatching(_ predicate: (TokenKind) -> Bool) -> [AccessorDeclSyntax] {
    let accessors: [AccessorDeclListSyntax.Element] = bindings.compactMap { patternBinding in
      switch patternBinding.accessorBlock?.accessors {
      case .accessors(let accessors):
        return accessors
      default:
        return nil
      }
    }.flatMap { $0 }
    return accessors.compactMap { accessor in
      if predicate(accessor.accessorSpecifier.tokenKind) {
        return accessor
      } else {
        return nil
      }
    }
  }
  
  var willSetAccessors: [AccessorDeclSyntax] {
    accessorsMatching { $0 == .keyword(.willSet) }
  }
  var didSetAccessors: [AccessorDeclSyntax] {
    accessorsMatching { $0 == .keyword(.didSet) }
  }
  
  var isComputed: Bool {
    if accessorsMatching({ $0 == .keyword(.get) }).count > 0 {
      return true
    } else {
      return bindings.contains { binding in
        if case .getter = binding.accessorBlock?.accessors {
          return true
        } else {
          return false
        }
      }
    }
  }
  
  
  var isImmutable: Bool {
    return bindingSpecifier.tokenKind == .keyword(.let)
  }
  
  func isEquivalent(to other: VariableDeclSyntax) -> Bool {
    if isInstance != other.isInstance {
      return false
    }
    return identifier?.text == other.identifier?.text
  }
  
  var initializer: InitializerClauseSyntax? {
    bindings.first?.initializer
  }
  
  func hasMacroApplication(_ name: String) -> Bool {
    for attribute in attributes {
      switch attribute {
      case .attribute(let attr):
        if attr.attributeName.tokens(viewMode: .all).map({ $0.tokenKind }) == [.identifier(name)] {
          return true
        }
      default:
        break
      }
    }
    return false
  }
}

extension TypeSyntax {
  var identifier: String? {
    for token in tokens(viewMode: .all) {
      switch token.tokenKind {
      case .identifier(let identifier):
        return identifier
      default:
        break
      }
    }
    return nil
  }
  
  func genericSubstitution(_ parameters: GenericParameterListSyntax?) -> String? {
    var genericParameters = [String : TypeSyntax?]()
    if let parameters {
      for parameter in parameters {
        genericParameters[parameter.name.text] = parameter.inheritedType
      }
    }
    var iterator = self.asProtocol(TypeSyntaxProtocol.self).tokens(viewMode: .sourceAccurate).makeIterator()
    guard let base = iterator.next() else {
      return nil
    }
    
    if let genericBase = genericParameters[base.text] {
      if let text = genericBase?.identifier {
        return "some " + text
      } else {
        return nil
      }
    }
    var substituted = base.text
    
    while let token = iterator.next() {
      switch token.tokenKind {
      case .leftAngle:
        substituted += "<"
      case .rightAngle:
        substituted += ">"
      case .comma:
        substituted += ","
      case .identifier(let identifier):
        let type: TypeSyntax = "\(raw: identifier)"
        guard let substituedType = type.genericSubstitution(parameters) else {
          return nil
        }
        substituted += substituedType
        break
      default:
        // ignore?
        break
      }
    }
    
    return substituted
  }
}

extension FunctionDeclSyntax {
  var isInstance: Bool {
    for modifier in modifiers {
      for token in modifier.tokens(viewMode: .all) {
        if token.tokenKind == .keyword(.static) || token.tokenKind == .keyword(.class) {
          return false
        }
      }
    }
    return true
  }
  
  struct SignatureStandin: Equatable {
    var isInstance: Bool
    var identifier: String
    var parameters: [String]
    var returnType: String
  }
  
  var signatureStandin: SignatureStandin {
    var parameters = [String]()
    for parameter in signature.parameterClause.parameters {
      parameters.append(parameter.firstName.text + ":" + (parameter.type.genericSubstitution(genericParameterClause?.parameters) ?? "" ))
    }
    let returnType = signature.returnClause?.type.genericSubstitution(genericParameterClause?.parameters) ?? "Void"
    return SignatureStandin(isInstance: isInstance, identifier: name.text, parameters: parameters, returnType: returnType)
  }
  
  func isEquivalent(to other: FunctionDeclSyntax) -> Bool {
    return signatureStandin == other.signatureStandin
  }
}

extension StructDeclSyntax {
    func isEquivalent(to other: StructDeclSyntax) -> Bool {
        return name.text == other.name.text
    }
}

extension DeclGroupSyntax {
  var memberFunctionStandins: [FunctionDeclSyntax.SignatureStandin] {
    var standins = [FunctionDeclSyntax.SignatureStandin]()
    for member in memberBlock.members {
      if let function = member.decl.as(FunctionDeclSyntax.self) {
        standins.append(function.signatureStandin)
      }
    }
    return standins
  }
  
  func hasMemberFunction(equvalentTo other: FunctionDeclSyntax) -> Bool {
    for member in memberBlock.members {
      if let function = member.decl.as(FunctionDeclSyntax.self) {
        if function.isEquivalent(to: other) {
          return true
        }
      }
    }
    return false
  }
  
  func hasMemberProperty(equivalentTo other: VariableDeclSyntax) -> Bool {
    for member in memberBlock.members {
      if let variable = member.decl.as(VariableDeclSyntax.self) {
        if variable.isEquivalent(to: other) {
          return true
        }
      }
    }
    return false
  }
  
  func hasMemberStruct(equivalentTo other: StructDeclSyntax) -> Bool {
    for member in memberBlock.members {
      if let variable = member.decl.as(StructDeclSyntax.self) {
        if variable.isEquivalent(to: other) {
          return true
        }
      }
    }
    return false
  }
  
  var definedVariables: [VariableDeclSyntax] {
    memberBlock.members.compactMap { member in
      if let variableDecl = member.decl.as(VariableDeclSyntax.self) {
        return variableDecl
      }
      return nil
    }
  }
  
  func addIfNeeded(_ decl: DeclSyntax?, to declarations: inout [DeclSyntax]) {
    guard let decl else { return }
    if let fn = decl.as(FunctionDeclSyntax.self) {
      if !hasMemberFunction(equvalentTo: fn) {
        declarations.append(decl)
      }
    } else if let property = decl.as(VariableDeclSyntax.self) {
      if !hasMemberProperty(equivalentTo: property) {
        declarations.append(decl)
      }
    } else if let st = decl.as(StructDeclSyntax.self) {
        if !hasMemberStruct(equivalentTo: st) {
            declarations.append(decl)
        }
    }
  }
  
  var isClass: Bool {
    return self.is(ClassDeclSyntax.self)
  }
  
  var isActor: Bool {
    return self.is(ActorDeclSyntax.self)
  }
  
  var isEnum: Bool {
    return self.is(EnumDeclSyntax.self)
  }
  
  var isStruct: Bool {
    return self.is(StructDeclSyntax.self)
  }
}

extension AttributeSyntax {
  var availability: AttributeSyntax? {
    if attributeName.identifier == "available" {
      return self
    } else {
      return nil
    }
  }
}

extension IfConfigClauseSyntax.Elements {
  var availability: IfConfigClauseSyntax.Elements? {
    switch self {
    case .attributes(let attributes):
      if let availability = attributes.availability {
        return .attributes(availability)
      } else {
        return nil
      }
    default:
      return nil
    }
  }
}

extension IfConfigClauseSyntax {
  var availability: IfConfigClauseSyntax? {
    if let availability = elements?.availability {
      return with(\.elements, availability)
    } else {
      return nil
    }
  }
  
  var clonedAsIf: IfConfigClauseSyntax {
    detached.with(\.poundKeyword, .poundIfToken())
  }
}

extension IfConfigDeclSyntax {
  var availability: IfConfigDeclSyntax? {
    var elements = [IfConfigClauseListSyntax.Element]()
    for clause in clauses {
      if let availability = clause.availability {
        if elements.isEmpty {
          elements.append(availability.clonedAsIf)
        } else {
          elements.append(availability)
        }
      }
    }
    if elements.isEmpty {
      return nil
    } else {
      return with(\.clauses, IfConfigClauseListSyntax(elements))
    }
    
  }
}

extension AttributeListSyntax.Element {
  var availability: AttributeListSyntax.Element? {
    switch self {
    case .attribute(let attribute):
      if let availability = attribute.availability {
        return .attribute(availability)
      }
    case .ifConfigDecl(let ifConfig):
      if let availability = ifConfig.availability {
        return .ifConfigDecl(availability)
      }
    default:
      break
    }
    return nil
  }
}

extension AttributeListSyntax {
  var availability: AttributeListSyntax? {
    var elements = [AttributeListSyntax.Element]()
    for element in self {
      if let availability = element.availability {
        elements.append(availability)
      }
    }
    if elements.isEmpty {
      return nil
    }
    return AttributeListSyntax(elements)
  }
}
