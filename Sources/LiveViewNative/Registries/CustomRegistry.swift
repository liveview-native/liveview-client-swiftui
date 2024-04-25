//
//  CustomRegistry.swift
// LiveViewNative
//
//  Created by Shadowfacts on 2/16/22.
//

import SwiftUI
import LiveViewNativeCore
import LiveViewNativeStylesheet

/// A container type for all `CustomRegistry` static members.
///
/// Use the ``Addon()`` macro to add an addon to this container type.
///
/// ```swift
/// public extension Addons {
///     @Addon
///     struct MyAddon<Root: RootRegistry> {}
/// }
/// ```
public enum Addons {}

/// Registers a new addon within the ``Addons`` container.
///
/// Use this macro to create an addon for LiveView Native.
/// Create a public extension on ``Addons``, and nest your addon struct within it.
///
/// ```swift
/// public extension Addons {
///     @Addon
///     struct MyAddon<Root: RootRegistry> {
///         // ...
///     }
/// }
/// ```
///
/// This will allow developers to reference your addon with a static member from ``LiveView(_:configuration:addons:connecting:disconnected:reconnecting:error:)-8xlc4``
///
/// ```swift
/// #LiveView(
///     .localhost,
///     addons: [.myAddon]
/// )
/// ```
///
/// Your addon type will be given a conformance to ``CustomRegistry``.
/// See ``CustomRegistry`` for more information on creating your addon.
@attached(peer, names: arbitrary)
@attached(extension, conformances: CustomRegistry)
public macro Addon() = #externalMacro(module: "LiveViewNativeMacros", type: "AddonMacro")

/// A custom registry allows clients to include custom view types in the LiveView DOM.
///
/// To add a custom element or attribute, define an enum for the type alias for the tag/attribute name and implement the appropriate method.
///
/// - Warning: You don't typically conform to this protocol yourself. The ``Addon()`` macro adds the conformance for you.
///
/// ## Topics
/// ### Custom Tags
/// - ``TagName``
/// - ``lookup(_:element:context:)-5bvqg``
/// - ``CustomView``
/// ### Custom View Modifiers
/// - ``CustomModifier``
/// - ``parseModifier(_:in:)-tj5n``
/// ### Composing Registries
/// - ``AggregateRegistry``
/// - ``RootRegistry``
/// - ``Root``
/// ### Supporting Types
/// - ``EmptyRegistry``
/// - ``ViewModifierBuilder``
public protocol CustomRegistry<Root> {
    /// The root custom registry type that the live view coordinator and context use.
    ///
    /// Conform you registry type to ``RootRegistry``, which sets this type to `Self` automatically, if you intend to use your registry directly.
    ///
    /// If you are composing multiple custom registries together or building a registry intended to incorporated into an aggregated registry, see ``AggregateRegistry``.
    associatedtype Root: RootRegistry
    
    /// A type representing the tag names that this registry type can provide views for.
    ///
    /// The tag name type must be `RawRepresentable` and its raw values must be strings.
    ///
    /// Generally, this is an enum which declares variants for the supported tags:
    /// ```swift
    /// @Addon
    /// struct MyAddon<Root: RootRegistry> {
    ///     enum TagName: String {
    ///         /// The `<foo>` element
    ///         case foo
    ///         /// The `<BarBaz>` element
    ///         case barBaz = "BarBaz"
    ///     }
    /// }
    /// ```
    ///
    /// This will default to the ``EmptyRegistry/None`` type if you don't support any custom tags.
    ///
    /// Implement the ``lookup(_:element:)-795ez`` function to render SwiftUI Views for your custom tags.
    associatedtype TagName: RawRepresentable = EmptyRegistry.None where TagName.RawValue == String
    /// The type of view this registry returns from the `lookup` method.
    ///
    /// - Warning: Generally, implementors will use an opaque return type on their ``lookup(_:element:)-795ez`` implementations and this will be inferred automatically.
    associatedtype CustomView: View = Never
    /// The type of view modifier this registry can parse.
    ///
    /// Use the ``LiveViewNativeStylesheet/ParseableExpression`` macro to generate a parser for a modifier from its `init` clauses.
    ///
    /// ```swift
    /// @ParseableExpression
    /// struct MyCustomModifier: ViewModifier {
    ///     static let name = "myCustomModifier"
    ///
    ///     let size: CGSize
    ///
    ///     // use as `myCustomModifier(5, 10)`
    ///     init(_ width: Double, _ height: Double) {
    ///         size = .init(width: width, height: height)
    ///     }
    ///
    ///     // use as `myCustomModifier(width: 5, height: 10)`
    ///     init(width: Double, height: Double) {
    ///         size = .init(width: width, height: height)
    ///     }
    ///
    ///     func body(content: Content) -> some View {
    ///         content.frame(width: size.width, height: size.height)
    ///     }
    /// }
    /// ```
    ///
    /// To support multiple modifiers in a registry, use an enum type with the `OneOf` parser.
    ///
    /// ```swift
    /// enum CustomModifier: ViewModifier, ParseableModifierValue {
    ///     case modifierA(MyModifierA)
    ///     case modifierB(MyModifierB)
    ///     case modifierC(MyModifierC)
    ///
    ///     static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
    ///         OneOf {
    ///             MyModifierA.parser(in: context).map(Self.modifierA)
    ///             MyModifierB.parser(in: context).map(Self.modifierB)
    ///             MyModifierC.parser(in: context).map(Self.modifierC)
    ///         }
    ///     }
    ///
    ///     func body(content: Content) -> some View {
    ///         switch content {
    ///         case let .modifierA(modifier):
    ///             content.modifier(modifier)
    ///         case let .modifierB(modifier):
    ///             content.modifier(modifier)
    ///         case let .modifierC(modifier):
    ///             content.modifier(modifier)
    ///         }
    ///     }
    /// }
    /// ```
    associatedtype CustomModifier: ViewModifier & ParseableModifierValue = EmptyModifier
    /// The type of view this registry produces for error views.
    ///
    /// - Warning: Generally, implementors will use an opaque return type on their ``errorView(for:)`` implementations and this will be inferred automatically.
    associatedtype ErrorView: View = Never
    
    /// This method is called by LiveView Native when it needs to construct a custom view.
    ///
    /// - Note: If your custom registry does not support any elements, you can set the `TagName` type alias to ``EmptyRegistry/None`` and omit this method.
    ///
    /// When using an enum for ``TagName``, switch over the `name` to provide a different View for each tag.
    ///
    /// ```swift
    /// func lookup(_ name: TagName, element: ElementNode) -> some View {
    ///     switch name {
    ///     case .foo:
    ///         FooView()
    ///     case .barBaz:
    ///         BarBazView()
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter name: The custom ``TagName`` that matched this element.
    /// - Parameter element: The element that a view should be created for.
    @ViewBuilder
    static func lookup(_ name: TagName, element: ElementNode) -> CustomView
    
    /// This method is called when it needs a view to display when an error occurs in the View hierarchy.
    ///
    /// If you do not implement this method, the framework provides a view which displays a simple text representation of the error.
    ///
    /// - Parameter error: The error of the view is reporting.
    @ViewBuilder
    static func errorView(for error: Error) -> ErrorView
    
    /// Parse the ``CustomModifier`` from ``input``.
    ///
    /// - Note: It is recommended to use the ``LiveViewNativeStylesheet/ParseableExpression`` macro to generate a parser.
    /// The generated parser can then be called inside this function.
    static func parseModifier(
        _ input: inout Substring.UTF8View,
        in context: ParseableModifierContext
    ) throws -> CustomModifier
}

extension CustomRegistry where ErrorView == Never {
    /// A default implementation that falls back to the default framework error view.
    public static func errorView(for error: Error) -> Never {
        fatalError()
    }
}

extension CustomRegistry {
    /// A default implementation that uses ``CustomModifier/parser(in:)``.
    public static func parseModifier(
        _ input: inout Substring.UTF8View,
        in context: ParseableModifierContext
    ) throws -> CustomModifier {
        try Self.CustomModifier.parser(in: context).parse(&input)
    }
}

/// The empty registry is the default ``CustomRegistry`` implementation that does not provide any views or modifiers.
public struct EmptyRegistry {
}
extension EmptyRegistry: RootRegistry {
    /// A type that can be used as ``CustomRegistry/TagName`` or ``CustomRegistry/ModifierType`` for registries which don't support any custom tags or attributes.
    public struct None: RawRepresentable {
        public typealias RawValue = String
        public var rawValue: String
        
        public init?(rawValue: String) {
            return nil
        }
    }
}
extension CustomRegistry where TagName == EmptyRegistry.None, CustomView == Never {
    /// A default implementation that does not provide any custom elements. If you omit the ``CustomRegistry/TagName`` type alias, this implementation will be used.
    public static func lookup(_ name: TagName, element: ElementNode) -> Never {
        fatalError()
    }
}

/// A root registry is a ``CustomRegistry`` type that can be used directly as the registry for a ``LiveSessionCoordinator``.
public protocol RootRegistry: CustomRegistry where Root == Self {
}

public struct CustomModifierGroupParser<Output, P: Parser>: Parser where P.Input == Substring.UTF8View, P.Output == Output {
    public let parser: P
    
    @inlinable
    public init(
        output outputType: Output.Type = Output.self,
        @CustomModifierGroupParserBuilder<Substring.UTF8View, Output> _ build: () -> P
    ) {
        self.parser = build()
    }
    
    public func parse(_ input: inout Substring.UTF8View) throws -> P.Output {
        var copy = input
        let (modifierName, metadata) = try Parse {
            "{".utf8
            Whitespace()
            AtomLiteral()
            Whitespace()
            ",".utf8
            Whitespace()
            Metadata.parser()
        }.parse(&copy)
        
        do {
            return try parser.parse(&input)
        } catch let error as ModifierParseError {
            throw error
        } catch {
            throw ModifierParseError(error: .unknownModifier(modifierName), metadata: metadata)
        }
    }
}

@resultBuilder
public struct CustomModifierGroupParserBuilder<Input, Output> {
    public static func buildPartialBlock(first: some Parser<Input, Output>) -> some Parser<Input, Output> {
        first
    }
    public static func buildPartialBlock(accumulated: some Parser<Input, Output>, next: some Parser<Input, Output>) -> some Parser<Input, Output> {
        Accumulator(accumulated: accumulated, next: next)
    }
    
    struct Accumulator<A: Parser, B: Parser>: Parser where A.Input == Input, B.Input == Input, A.Output == Output, B.Output == Output {
        let accumulated: A
        let next: B
        
        func parse(_ input: inout Input) throws -> Output {
            let copy = input
            let firstError: ModifierParseError?
            do {
                return try accumulated.parse(&input)
            } catch let error as ModifierParseError {
                firstError = error
            } catch {
                firstError = nil
            }
            input = copy
            do {
                return try next.parse(&input)
            } catch let error as ModifierParseError {
                throw error
            } catch {
                if let firstError {
                    throw firstError
                } else {
                    throw error
                }
            }
        }
    }
}
