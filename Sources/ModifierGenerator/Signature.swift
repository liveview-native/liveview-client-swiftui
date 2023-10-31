import SwiftSyntax

struct Signature {
    let parameters: [FunctionParameterSyntax]
    let `init`: String
    let `case`: String
    let content: String
    let properties: String?

    init(_ offset: Int, _ declarationSyntax: (FunctionDeclSyntax, availability: (AvailabilityArgumentListSyntax, Set<String>))) {
        let (decl, (availability, unavailable)) = declarationSyntax

        let generics = Dictionary(uniqueKeysWithValues: decl.genericParameterClause?.parameters.compactMap { (generic) -> (String, TypeSyntax)? in
            guard let rightType = decl.genericWhereClause?.requirements.first(where: {
                $0.requirement.as(ConformanceRequirementSyntax.self)?.leftType.as(IdentifierTypeSyntax.self)?.name.text == generic.name.text
            })?.requirement.as(ConformanceRequirementSyntax.self)?.rightType
            else { return nil }
            if rightType.as(MemberTypeSyntax.self)?.name.text == "RangeExpression",
                let bound = decl.genericWhereClause?.requirements.first(where: {
                    $0.requirement.as(SameTypeRequirementSyntax.self)?.leftType.as(MemberTypeSyntax.self)?.name.text == "Bound"
                })?.requirement.as(SameTypeRequirementSyntax.self)
            {
                return (
                    generic.name.text,
                    TypeSyntax("ParseableRangeExpression<\(bound.rightType)>")
                )
            } else {
                return (
                    generic.name.text,
                    rightType
                )
            }
        } ?? [])
        self.parameters = decl.signature.parameterClause.parameters.map({ FunctionParameterSyntax($0, generics: generics) })
        let caseParameters = parameters
            .map({ $0.secondName != nil ? $0.with(\.firstName, $0.secondName!).with(\.secondName, nil) : $0 })
        // Filter out `ChangeTracked` and `Event` arguments.
        let changeTracked = caseParameters.filter({ $0.type.as(IdentifierTypeSyntax.self)?.name.text == "ChangeTracked" })
        let events = caseParameters.filter({ $0.type.as(IdentifierTypeSyntax.self)?.name.text == "Event" })
        var boundParameters = caseParameters.filter({ !["ChangeTracked", "Event"].contains($0.type.as(IdentifierTypeSyntax.self)?.name.text) })
        if !boundParameters.isEmpty {
            boundParameters[boundParameters.count - 1] = boundParameters.last!.with(\.trailingComma, nil)
        }

        // Construct signature

        self.`init` = #"""
            init(\#(FunctionParameterListSyntax(parameters).description)) {
                \#(boundParameters.isEmpty ? "self.value = ._\(offset)" : #"self.value = ._\#(offset)\#(boundParameters.isEmpty ? "" : "(")\#(boundParameters.map({ "\($0.firstName.trimmed): \($0.firstName.trimmed)" }).joined(separator: ", "))\#(caseParameters.isEmpty ? "" : ")")"#)
                \#((changeTracked + events)
                    .map({
                        #"self.__\#(offset)_\#(($0.secondName ?? $0.firstName).trimmed.description) = \#($0.secondName ?? $0.firstName)"#
                    })
                    .joined(separator: "\n")
                )
            }
        """#

        self.`case` = #"""
                case _\#(offset)\#(boundParameters.isEmpty ? "" : "(")\#(FunctionParameterListSyntax(boundParameters).description)\#(boundParameters.isEmpty ? "" : ")")
        """#

        self.content = #"""
                \#(boundParameters.isEmpty ? "case ._\(offset)" : "case let ._\(offset)(\(boundParameters.map(\.firstName.trimmed.description).joined(separator: ", ")))"):
                    \#(availability.isEmpty ? "" : "if #available(\(availability), *) {")
                    __content
                        \#(
                            availability.isEmpty
                            ? ""
                            : """
                            #if \(
                                availability
                                    .compactMap({ $0.argument.as(PlatformVersionSyntax.self)?.platform.text })
                                    .filter({ !unavailable.contains($0) })
                                    .map({ $0 == "macCatalyst" ? "targetEnvironment(macCatalyst)" : "os(\($0))" })
                                    .joined(separator: " || "))
                            """
                        )
                        .\#(decl.name.trimmed.text)(\#(parameters.map({
                            switch $0.type.as(IdentifierTypeSyntax.self)?.name.text {
                            case "ViewReference":
                                return $0.firstName.tokenKind == .wildcard ? "{ \($0.secondName!.text).resolve(on: element, in: context) }" : "\($0.firstName.text): { \(($0.secondName ?? $0.firstName).text).resolve(on: element, in: context) }"
                            case "TextReference":
                                return $0.firstName.tokenKind == .wildcard ? "\($0.secondName!.text).resolve(on: element, in: context)" : "\($0.firstName.text): \(($0.secondName ?? $0.firstName).text).resolve(on: element, in: context)"
                            case "ChangeTracked":
                                // These are registered on the View so they get proper DynamicProperty treatment.
                                return $0.firstName.tokenKind == .wildcard ? "__\(offset)_\($0.secondName!.text).projectedValue" : "\($0.firstName.text): __\(offset)_\(($0.secondName ?? $0.firstName).text).projectedValue"
                            case "Event":
                                return $0.firstName.tokenKind == .wildcard ? "{ __\(offset)_\($0.secondName!.text).wrappedValue() }" : "\($0.firstName.text): { __\(offset)_\(($0.secondName ?? $0.firstName).text).wrappedValue() }"
                            case "AttributeReference":
                                return $0.firstName.tokenKind == .wildcard ? "\($0.secondName!.text).resolve(on: element, in: context)" : "\($0.firstName.text): \(($0.secondName ?? $0.firstName).text).resolve(on: element, in: context)"
                            default:
                                if $0.type.as(OptionalTypeSyntax.self)?.wrappedType.as(IdentifierTypeSyntax.self)?.name.text == "AttributeReference" {
                                    return $0.firstName.tokenKind == .wildcard ? "\($0.secondName!.text)?.resolve(on: element, in: context)" : "\($0.firstName.text): \(($0.secondName ?? $0.firstName).text)?.resolve(on: element, in: context)"
                                }
                                return $0.firstName.tokenKind == .wildcard ? $0.secondName!.text : "\($0.firstName.text): \(($0.secondName ?? $0.firstName).text)"
                            }
                        }).joined(separator: ", ")))
                        \#(availability.isEmpty ? "" : "#endif")
                    \#(availability.isEmpty ? "" : "} else { __content }")
        """#

        self.properties = #"""
        \#(changeTracked
            .map({
                #"@ChangeTracked private var _\#(offset)_\#(($0.secondName ?? $0.firstName).trimmed.description): \#($0.type.as(IdentifierTypeSyntax.self)!.genericArgumentClause!.arguments.description)"#
            })
            .joined(separator: "\n")
        )
        \#(events
            .map({
                #"@Event private var _\#(offset)_\#(($0.secondName ?? $0.firstName).trimmed.description): Event.EventHandler"#
            })
            .joined(separator: "\n")
        )
        """#
    }
}

extension FunctionParameterSyntax {
    /// Validate/convert the types of a parameter to be compatible with the parser.
    init(_ parameter: FunctionParameterSyntax, generics: [String:TypeSyntax]) {
        // generic types are replaced with `Any*` erasers
        let genericBaseType: TypeSyntax?
        if let identifierType = parameter.type.as(IdentifierTypeSyntax.self) ?? parameter.type.as(OptionalTypeSyntax.self)?.wrappedType.as(IdentifierTypeSyntax.self),
           let baseType = generics[identifierType.name.text]
        {
            if let member = baseType.as(MemberTypeSyntax.self) {
                genericBaseType = TypeSyntax("\(raw: member.name.text)")
            } else {
                genericBaseType = baseType
            }
        } else if let someType = parameter.type.as(SomeOrAnyTypeSyntax.self)?.constraint {
            if let member = someType.as(MemberTypeSyntax.self) {
                genericBaseType = TypeSyntax("\(raw: member.name.text)")
            } else {
                genericBaseType = someType
            }
        } else {
            genericBaseType = nil
        }

        if parameter.isViewBuilder {
            // nested View content is replaced with a `ViewReference`
            self = parameter
                .with(\.type, TypeSyntax("ViewReference"))
                .with(\.attributes, AttributeListSyntax([]))
                .with(\.defaultValue, InitializerClauseSyntax(value: ExprSyntax(#"ViewReference(value: [])"#)))
        } else if let functionType = parameter.type.as(FunctionTypeSyntax.self)
                                            ?? parameter.type.as(AttributedTypeSyntax.self)?.baseType.as(FunctionTypeSyntax.self)
                                            ?? parameter.type.as(OptionalTypeSyntax.self)?.wrappedType.as(TupleTypeSyntax.self)?.elements.first?.type.as(FunctionTypeSyntax.self),
                  functionType.parameters.count == 0
                    && functionType.returnClause.type.as(MemberTypeSyntax.self)?.name.text == "Void"
        {
            // Closures are replaced with `Event`
            self = parameter
                .with(\.type, TypeSyntax("Event"))
                .with(\.defaultValue, parameter.type.is(OptionalTypeSyntax.self) ? InitializerClauseSyntax(value: ExprSyntax("Event()")) : nil)
        } else if let genericBaseType {
            // Some generic types are replaced with concrete types
            if ["StringProtocol", "Equatable"].contains(genericBaseType.as(IdentifierTypeSyntax.self)?.name.text) {
                // use `String`
                self = parameter.with(\.type, TypeSyntax("String"))
            } else if ["BinaryInteger"].contains(genericBaseType.as(IdentifierTypeSyntax.self)?.name.text) {
                // use `Int`
                self = parameter.with(\.type, TypeSyntax("\(parameter.type.leadingTrivia)Int\(parameter.type.trailingTrivia)"))
            } else if ["ParseableRangeExpression"].contains(genericBaseType.as(IdentifierTypeSyntax.self)?.name.text) {
                // use the unmodified type name
                self = parameter.with(\.type, genericBaseType)
            } else {
                // add `Any*` prefix to erase
                self = parameter.with(\.type, TypeSyntax("\(parameter.type.leadingTrivia)Any\(genericBaseType)\(parameter.type.trailingTrivia)")) // erase the generic
            }
        } else if let memberType = parameter.type.as(MemberTypeSyntax.self),
                  memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "SwiftUI"
                    && memberType.name.text == "Text"
        {
            // nested Text is replaced with a `TextReference`
            self = parameter.with(\.type, TypeSyntax("TextReference"))
        } else if let memberType = parameter.type.as(MemberTypeSyntax.self),
                  memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "SwiftUI"
                    && memberType.name.text == "Binding"
        {
            // SwiftUI Bindings are replaced with a `ChangeTracked` value
            self = parameter.with(\.type, TypeSyntax("ChangeTracked\(raw: memberType.genericArgumentClause?.description ?? "")"))
        } else {
            self = parameter
        }

        // Types that support `attr` should be wrapped in an `AttributeReference`.
        if let typeName = (self.type.as(MemberTypeSyntax.self)?.name
            ?? self.type.as(OptionalTypeSyntax.self)?.wrappedType.as(IdentifierTypeSyntax.self)?.name
            ?? self.type.as(OptionalTypeSyntax.self)?.wrappedType.as(MemberTypeSyntax.self)?.name
            ?? self.type.as(IdentifierTypeSyntax.self)?.name)?.text,
            [
                "String",
                "Bool",
                "Double",
                "Int",
                "Date",
                "Color",
                "CGFloat",
            ].contains(typeName)
        {
            self = self
                .with(\.type, TypeSyntax("AttributeReference<\(self.type.trimmed)>\(raw: self.type.is(OptionalTypeSyntax.self) ? "?" : "")"))
                .with(\.defaultValue, self.defaultValue != nil ? InitializerClauseSyntax(ExprSyntax(".init(storage: .constant(\(self.defaultValue!)))")) : nil)
        }
    }
}