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

        let platformAvailability = availability.isEmpty
            ? ""
            : """
            #if \(
                availability
                    .compactMap({ $0.argument.as(PlatformVersionSyntax.self)?.platform.text })
                    .filter({ !unavailable.contains($0) })
                    .map({ $0 == "macCatalyst" ? "targetEnvironment(macCatalyst)" : "os(\($0))" })
                    .joined(separator: " || "))
            """

        self.`init` = #"""
            \#(platformAvailability)
            \#(availability.isEmpty ? "" : "@available(\(availability), *)")
            init(\#(FunctionParameterListSyntax(parameters).description)) {
                \#(boundParameters.isEmpty ? "self.value = ._\(offset)" : #"self.value = ._\#(offset)\#(boundParameters.isEmpty ? "" : "(")\#(boundParameters.map({ "\($0.firstName.trimmed): \($0.firstName.trimmed)" }).joined(separator: ", "))\#(caseParameters.isEmpty ? "" : ")")"#)
                \#((changeTracked + events)
                    .map({
                        #"self.__\#(offset)_\#(($0.secondName ?? $0.firstName).trimmed.description) = \#($0.secondName ?? $0.firstName)"#
                    })
                    .joined(separator: "\n")
                )
            }
            \#(platformAvailability.isEmpty ? "" : "#endif")
        """#

        self.`case` = #"""
                \#(platformAvailability)
                case _\#(offset)\#(boundParameters.isEmpty ? "" : "(")\#(FunctionParameterListSyntax(boundParameters.map({
                    if availability.isEmpty {
                        return $0
                    } else {
                        return $0
                            .with(\.type, $0.type.is(OptionalTypeSyntax.self) ? TypeSyntax("Any?") : TypeSyntax("Any"))
                            .with(\.defaultValue, nil)
                    }
                })).description)\#(boundParameters.isEmpty ? "" : ")")
                \#(platformAvailability.isEmpty ? "" : "#endif")
        """#

        self.content = #"""
                \#(platformAvailability)
                \#(boundParameters.isEmpty ? "case ._\(offset)" : "case let ._\(offset)(\(boundParameters.map(\.firstName.trimmed.description).joined(separator: ", ")))"):
                    \#(availability.isEmpty ? "" : "if #available(\(availability), *) {")
                    \#(
                        availability.isEmpty
                            ? ""
                            : boundParameters
                            .map({
                                "let \($0.firstName.trimmed.description) = \($0.firstName.trimmed.description) as\($0.type.is(OptionalTypeSyntax.self) ? "?" : "!") \($0.type.as(OptionalTypeSyntax.self)?.wrappedType ?? $0.type)"
                            })
                            .joined(separator: "\n")
                    )
                    __content
                        .\#(decl.name.trimmed.text)(\#(parameters.map({
                            switch $0.type.as(IdentifierTypeSyntax.self)?.name.text {
                            case "ViewReference", "ToolbarContentReference", "CustomizableToolbarContentReference":
                                return $0.firstName.tokenKind == .wildcard ? "{ \($0.secondName!.text).resolve(on: element, in: context) }" : "\($0.firstName.text): { \(($0.secondName ?? $0.firstName).text).resolve(on: element, in: context) }"
                            case "InlineViewReference":
                                return $0.firstName.tokenKind == .wildcard ? "\($0.secondName!.text).resolve(on: element, in: context)" : "\($0.firstName.text): \(($0.secondName ?? $0.firstName).text).resolve(on: element, in: context)"
                            case "TextReference":
                                return $0.firstName.tokenKind == .wildcard ? "\($0.secondName!.text).resolve(on: element, in: context)" : "\($0.firstName.text): \(($0.secondName ?? $0.firstName).text).resolve(on: element, in: context)"
                            case "ChangeTracked":
                                // These are registered on the View so they get proper DynamicProperty treatment.
                                return $0.firstName.tokenKind == .wildcard ? "__\(offset)_\($0.secondName!.text).projectedValue" : "\($0.firstName.text): __\(offset)_\(($0.secondName ?? $0.firstName).text).projectedValue"
                            case "Event":
                                // the parameter count is encoded in the `secondName`.
                                let parameterCount = Int($0.secondName!.text.split(separator: "__").last ?? "0") ?? 0
                                switch parameterCount {
                                case 0:
                                    return $0.firstName.tokenKind == .wildcard ? "{ __\(offset)_\($0.secondName!.text).wrappedValue() }" : "\($0.firstName.text): { __\(offset)_\(($0.secondName ?? $0.firstName).text).wrappedValue() }"
                                case 1:
                                    return $0.firstName.tokenKind == .wildcard ? "{ __\(offset)_\($0.secondName!.text).wrappedValue(value: $0) }" : "\($0.firstName.text): { __\(offset)_\(($0.secondName ?? $0.firstName).text).wrappedValue(value: $0) }"
                                default:
                                    let arguments = (0..<parameterCount).map({ "$\($0)" }).joined(separator: ", ")
                                    return $0.firstName.tokenKind == .wildcard ? "{ __\(offset)_\($0.secondName!.text).wrappedValue(value: [\(arguments)]) }" : "\($0.firstName.text): { __\(offset)_\(($0.secondName ?? $0.firstName).text).wrappedValue(value: [\(arguments)]) }"
                                }
                            case "AttributeReference":
                                return $0.firstName.tokenKind == .wildcard ? "\($0.secondName!.text).resolve(on: element, in: context)" : "\($0.firstName.text): \(($0.secondName ?? $0.firstName).text).resolve(on: element, in: context)"
                            default:
                                if let optionalType = $0.type.as(OptionalTypeSyntax.self)?.wrappedType.as(IdentifierTypeSyntax.self)?.name.text {
                                    switch optionalType {
                                    case "AttributeReference":
                                        return $0.firstName.tokenKind == .wildcard ? "\($0.secondName!.text)?.resolve(on: element, in: context)" : "\($0.firstName.text): \(($0.secondName ?? $0.firstName).text)?.resolve(on: element, in: context)"
                                    case "TextReference":
                                        return $0.firstName.tokenKind == .wildcard ? "\($0.secondName!.text)?.resolve(on: element, in: context)" : "\($0.firstName.text): \(($0.secondName ?? $0.firstName).text)?.resolve(on: element, in: context)"
                                    default:
                                        break
                                    }
                                }
                                return $0.firstName.tokenKind == .wildcard ? $0.secondName!.text : "\($0.firstName.text): \(($0.secondName ?? $0.firstName).text)"
                            }
                        }).joined(separator: ", ")))
                    \#(availability.isEmpty ? "" : "} else { __content }")
                \#(platformAvailability.isEmpty ? "" : "#endif")
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

extension TypeSyntax {
    func resolveGenericType() -> TypeSyntax {
        // Some generic types are replaced with concrete types
        if ["StringProtocol", "Equatable", "Hashable", "Identifiable"].contains(
            self.as(IdentifierTypeSyntax.self)?.name.text
                ?? self.as(MemberTypeSyntax.self)?.name.text
        ) {
            // use `String`
            return TypeSyntax("String")
        } else if ["BinaryInteger"].contains(self.as(IdentifierTypeSyntax.self)?.name.text) {
            // use `Int`
            return TypeSyntax("Int")
        } else if ["ParseableRangeExpression"].contains(self.as(IdentifierTypeSyntax.self)?.name.text) {
            // use the unmodified type name
            return self
        } else if self.as(IdentifierTypeSyntax.self)?.name.text == "Gesture" {
            return TypeSyntax("AnyGesture<Any>")
        } else if self.as(IdentifierTypeSyntax.self)?.name.text == "View" {
            return TypeSyntax("InlineViewReference")
        } else {
            // add `Any*` prefix to erase
            return TypeSyntax("Any\(self)")
        }
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
        } else if let someType = parameter.type.as(SomeOrAnyTypeSyntax.self)?.constraint
                                    ?? parameter.type.as(OptionalTypeSyntax.self)?.wrappedType.as(TupleTypeSyntax.self)?.elements.first?.type.as(SomeOrAnyTypeSyntax.self)?.constraint
        {
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
        } else if parameter.isToolbarContentBuilder {
            // nested ToolbarContent is replaced with a `ToolbarContentReference` or a `CustomizableToolbarContentReference`.
            if let function = parameter.type.as(FunctionTypeSyntax.self),
               let returnType = function.returnClause.type.as(IdentifierTypeSyntax.self)?.name.text,
               let genericType = generics[returnType]?.as(MemberTypeSyntax.self)?.name.text,
               genericType == "CustomizableToolbarContent"
            {
                self = parameter
                    .with(\.type, TypeSyntax("CustomizableToolbarContentReference"))
                    .with(\.attributes, AttributeListSyntax([]))
                    .with(\.defaultValue, InitializerClauseSyntax(value: ExprSyntax(#"CustomizableToolbarContentReference(value: [])"#)))
            } else {
                self = parameter
                    .with(\.type, TypeSyntax("ToolbarContentReference"))
                    .with(\.attributes, AttributeListSyntax([]))
                    .with(\.defaultValue, InitializerClauseSyntax(value: ExprSyntax(#"ToolbarContentReference(value: [])"#)))
            }
        } else if let functionType = parameter.functionType,
                  functionType.returnClause.type.as(MemberTypeSyntax.self)?.name.text == "Void"
        {
            // Closures are replaced with `Event`
            self = parameter
                .with(\.type, TypeSyntax("Event"))
                .with(\.defaultValue, parameter.type.is(OptionalTypeSyntax.self) ? InitializerClauseSyntax(value: ExprSyntax("Event()")) : nil)
                .with(\.firstName.trailingTrivia, .space)
                .with(\.secondName, "\(raw: parameter.secondName?.text ?? parameter.firstName.text)__\(raw: String(functionType.parameters.count))") // encode the number of parameters into the `secondName`.
        } else if let genericBaseType {
            self = parameter.with(\.type, genericBaseType.resolveGenericType())
        } else if let memberType = parameter.type.as(MemberTypeSyntax.self) ?? parameter.type.as(OptionalTypeSyntax.self)?.wrappedType.as(MemberTypeSyntax.self),
                  memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "SwiftUI"
                    && memberType.name.text == "Text"
        {
            // nested Text is replaced with a `TextReference`
            self = parameter.with(\.type, TypeSyntax("TextReference\(raw: parameter.type.is(OptionalTypeSyntax.self) ? "? " : "")"))
        } else if let memberType = parameter.type.as(MemberTypeSyntax.self),
                  memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "SwiftUI"
                    && memberType.name.text == "Binding"
        {
            let bindingConstraint = memberType.genericArgumentClause?.arguments.first?.argument
            if let someType = bindingConstraint?.as(OptionalTypeSyntax.self)?.wrappedType.as(TupleTypeSyntax.self)?.elements.first?.type.as(SomeOrAnyTypeSyntax.self)?.constraint {
                self = parameter.with(\.type, TypeSyntax("ChangeTracked<\(raw: someType.resolveGenericType())?>"))
            } else if let bindingConstraint,
                      let genericWrappedType = generics[bindingConstraint.description]
            {
                self = parameter.with(\.type, TypeSyntax("ChangeTracked<\(raw: genericWrappedType.resolveGenericType())>"))
            } else {
                // SwiftUI Bindings are replaced with a `ChangeTracked` value
                self = parameter.with(\.type, TypeSyntax("ChangeTracked\(raw: memberType.genericArgumentClause?.description ?? "")"))
            }
        } else if parameter.ellipsis != nil {
            // variadic parameters become a single parameter
            self = parameter
                .with(\.ellipsis, nil)
        } else {
            self = parameter
        }

        // Types that support `attr` should be wrapped in an `AttributeReference`.
        if let typeName = (self.type.as(MemberTypeSyntax.self)?.name
            ?? self.type.as(OptionalTypeSyntax.self)?.wrappedType.as(IdentifierTypeSyntax.self)?.name
            ?? self.type.as(OptionalTypeSyntax.self)?.wrappedType.as(MemberTypeSyntax.self)?.name
            ?? self.type.as(IdentifierTypeSyntax.self)?.name)?.text,
            [
                // Primitives
                "String",
                "Bool",
                "Double",
                "Int",
                "Date",
                "CGFloat",
                // SwiftUI types
                "Alignment",
                "Angle",
                "Color",
                "ColorScheme",
                "HorizontalAlignment",
                "RoundedCornerStyle",
                "UnitPoint",
                "VerticalAlignment",
                "Visibility",
            ].contains(typeName)
        {
            self = self
                .with(\.type, TypeSyntax("AttributeReference<\(self.type.trimmed)>\(raw: self.type.is(OptionalTypeSyntax.self) ? "?" : "")"))
                .with(\.defaultValue, self.defaultValue?.as(InitializerClauseSyntax.self).flatMap({ InitializerClauseSyntax.init(equal: .equalToken(leadingTrivia: .space, trailingTrivia: .space), value: ExprSyntax(".init(storage: .constant(\($0.value)))")) }))
        }

        self = self
            .with(\.leadingTrivia, parameter.type.leadingTrivia)
            .with(\.trailingTrivia, parameter.type.trailingTrivia)
    }
}
