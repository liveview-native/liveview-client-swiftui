//
//  ContentBuilder.swift
//
//
//  Created by Carson Katri on 6/15/23.
//

import SwiftUI
import LiveViewNativeCore
import LiveViewNativeStylesheet

/// A protocol add-on libraries conform to support custom DSLs.
///
/// Some Apple frameworks that will be supported with add-on libraries have custom DSLs besides SwiftUI's DSL.
/// For example, Swift Charts and MapKit provide their own SwiftUI-like DSL for building charts and maps.
///
/// The following types are conceptually equivalent.
///
/// | SwiftUI | `ViewBuilder`         | `View`         | `ViewModifier` |
/// | ------- | --------------------- | -------------- | -------------- |
/// | Charts  | `ChartContentBuilder` | `ChartContent` | N/A            |
/// | MapKit  | `MapContentBuilder`   | `MapContent`   | N/A            |
///
/// Using this protocol all of these builders can be supported.
///
/// - Note: This protocol relies on type erasure, and is not suitable for DSLs that would have a considerable performance/behavior impact from the use of erasure such as `ViewBuilder`.
///
/// The following map to SwiftUI's building blocks:
///
/// | `ViewBuilder`      | `View`      | `ViewModifier`      |
/// | ------------------ | ----------- | ------------------- |
/// | ``ContentBuilder`` | ``Content`` | ``ContentModifier`` |
///
/// ## Content Type
/// Create a type alias for the ``Content`` associated type to specify the type of content this builder produces.
///
/// In most cases, the DSLs that are being wrapped will use a protocol such as `View` in SwiftUI or `ChartContent` in Swift Charts.
/// Use an `any` existential or type eraser (such as `AnyView` in SwiftUI)
///
/// ```swift
/// struct ChartContentBuilder: ContentBuilder {
///     typealias Content = any ChartContent
/// }
/// ```
///
/// ## Elements
///
/// Create a ``TagName`` type to represent the available elements.
///
/// ```swift
/// struct ChartContentBuilder: ContentBuilder {
///     ...
///     enum TagName: String {
///         case barMark = "BarMark"
///         case plot = "Plot"
///         ...
///     }
/// }
/// ```
///
/// The ``lookup(_:element:context:)`` function will be called whenever an element is built.
/// In this function, create the element types, and erase them to the ``Content`` type.
///
/// ```swift
/// struct ChartContentBuilder: ContentBuilder {
///     ...
///     static func lookup<R: RootRegistry>(
///         _ tag: TagName,
///         element: ElementNode,
///         context: Context<R>
///     ) -> Content {
///         switch tag {
///         case .barMark:
///             return BarMark(element: element)
///         case .plot:
///             return Plot<R>(element: element, context: context)
///         }
///     }
/// }
/// ```
///
/// Attributes can be access using the ``ElementNode/attributeValue(for:)`` and ``ElementNode/attributeBoolean(for:)`` functions.
///
/// ## Modifiers
/// Custom modifiers can be created with the ``ContentModifier`` protocol.
/// Set the ``ContentModifier/Builder`` associated type to the ``ContentBuilder`` it is compatible with.
///
/// Depend on `LiveViewNativeStylesheet` to create a parser for a custom modifier.
/// Add the ``LiveViewNativeStylesheet/ParseableExpression`` macro to have a parser generated from the `init` clauses on the type.
/// Add a static `name` property to be used by the macro.
///
/// - Note: Use `ViewReference` to support nested content in a modifier.
///
/// ```swift
/// import LiveViewNativeStylesheet
///
/// @ParseableExpression
/// struct SymbolModifier: ContentModifier {
///     typealias Builder = ChartContentBuilder
///
///     static let name = "symbol"
///
///     let content: ViewReference
///
///     init(content: ViewReference) {
///         self.content = content
///     }
///
///     func apply<R: RootRegistry>(
///         to content: Builder.Content,
///         on element: ElementNode,
///         in context: Builder.Context<R>
///     ) -> Builder.Content {
///         content
///             .symbol {
///                 Builder.buildChildren(of: element, forTemplate: self.content, in: context)
///             }
///     }
/// }
/// ```
///
/// Given the initializer `init(content:)`, the `@ParseableExpression` macro will allow the following syntax:
///
/// ```swift
/// symbol(content: :my_content)
/// symbol(content: [:a, :b])
/// ```
///
/// ``ContentModifier/apply(to:on:in:)`` will be called on each modifier referenced by the `class` attribute when elements are built.
///
/// Add a ``ModifierType`` type to enumerate the available modifiers.
/// This type should conform to `ContentModifier`. Use the `OneOf` parser to support multiple modifiers.
/// Switch over the possible modifiers in `apply` and forward the call to the correct type.
///
/// ```swift
/// struct ChartContentBuilder: ContentBuilder {
///     ...
///     enum ModifierType: ChartContent {
///         typealias Content = ChartContentBuilder
///
///         case symbol(SymbolModifier)
///         // ...
///
///         static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
///             OneOf {
///                 SymbolModifier.parser(in: context).map(Self.symbol)
///                 // ...
///             }
///         }
///
///         func apply<R: RootRegistry>(
///             to content: Builder.Content,
///             on element: ElementNode,
///             in context: Builder.Context<R>
///         ) -> Builder.Content {
///             switch self {
///             case let .symbol(modifier):
///                 return modifier.apply(to: content, on: element, in: context)
///             // ...
///             }
///         }
///     }
/// }
/// ```
///
/// ## Building Content
/// Use ``buildChildren(of:forTemplate:in:)`` to build the children of an element with this DSL.
/// ``ContentBuilderContext`` can be used to access the ``Context`` from the environment in a `View` type.
///
/// ``ObservedElement`` should be created with `observeChildren` set to `true` so that updates to the content are applied.
/// If this is not set, the content will be static.
///
/// - Note: This method will automatically handle `template` attributes. However, for more manual construction use ``build(_:in:)-5jedi`` and ``build(_:in:)-604l2``.
///
/// ```swift
/// struct MyChart<R: RootRegistry>: View {
///     @ObservedElement(observeChildren: true) private var element
///     @ContentBuilderContext<R> private var context
///
///     var body: some View {
///         unboxContent(ChartContentBuilder.buildChildren(
///             of: element,
///             in: context
///         ))
///     }
///
///     // The `any ChartContent` produced by the builder must be unboxed.
///     // This could be avoided by using a custom eraser type such as `AnyChartContent` as the `ChartContentBuilder.Content`,
///     // however not all DSLs provide these types.
///     func unboxContent(_ content: some ChartContent) -> AnyView {
///         AnyView(Chart {
///             content
///         })
///     }
/// }
/// ```
///
/// This can be used within the DSL's custom elements as well.
///
/// - Note: ``ObservedElement`` and ``LiveContext`` cannot be used in non-`View` types.
/// The ``ElementNode`` and ``Context`` should be passed into each element manually.
///
/// ```html
/// struct MyPlot<R: RootRegistry>: ChartContent {
///     let element: ElementNode
///     let context: ChartContentBuilder.Context<R>
///
///     var body: some ChartContent {
///         Plot {
///             ChartContentBuilder.buildChildren(
///                 of: element,
///                 in: context
///             )
///         }
///     }
/// }
/// ```
public protocol ContentBuilder {
    /// An enum with the supported element names.
    associatedtype TagName: RawRepresentable<String>
    
    /// The type of content this builder produces.
    ///
    /// A protocol cannot be used as the content type.
    ///
    /// ```swift
    /// typealias Content = View // error
    /// ```
    ///
    /// Instead, use an `any` existential or a custom type eraser.
    ///
    /// ```swift
    /// typealias Content = any View
    /// // or
    /// typealias Content = AnyView
    /// ```
    ///
    /// In many DSLs, `any` existentials cannot be used as content directly.
    /// If no custom type eraser is available, unbox the content and erase the `View` that holds it.
    ///
    /// ```swift
    /// func unbox(_ content: some MapContent) -> AnyView {
    ///     AnyView(Map {
    ///         content
    ///     })
    /// }
    ///
    /// let content: any MapContent = ...
    /// unbox(content)
    /// ```
    ///
    /// If a custom type eraser *is* available, it may still be preferable to use an `any` existential.
    /// This can avoid creating many wrapper types when just one can be used at the root of the hierarchy.
    ///
    /// ```swift
    /// let content: any ChartContent = ...
    /// Chart {
    ///     AnyChartContent(content)
    /// }
    /// ```
    associatedtype Content
    
    associatedtype ModifierType: ContentModifier = EmptyContentModifier<Self> where ModifierType.Builder == Self
    
    /// Switch over the ``tag`` and provide the appropriate ``Content``.
    ///
    /// The ``ObservedElement`` and ``LiveContext`` property wrappers cannot be used outside of `View`.
    /// Therefore, the ``element`` and ``context`` must be passed manually into each type to be used.
    static func lookup<R: RootRegistry>(
        _ tag: TagName,
        element: ElementNode,
        context: Context<R>
    ) -> Content
    
    /// Provide an empty content, such as `EmptyView` in SwiftUI.
    static func empty() -> Content
    
    /// Merge content together, such as `TupleView<A, B>` in SwiftUI.
    static func reduce(
        accumulated: Content,
        next: Content
    ) -> Content
}

public extension ContentBuilder {
    /// The ``context`` associated with this builder.
    ///
    /// This is used to support the building of nested `View` elements from within any builder
    /// with the ``buildView(_:in:)`` function.
    typealias Context<R: RootRegistry> = ContentBuilderContext<R, Self>.Value
}

/// Access the context for a ``ContentBuilder`` from within a `View`.
///
/// Use this property wrapper in a `View` to access the ``ContentBuilder.Context`` from the environment.
///
/// ```swift
/// struct MyChart<R: RootRegistry>: View {
///   @ContentBuilderContext<R> private var context
///   @ObservedElement private var element
///
///   var body: some View {
///     Chart {
///       ChartContentBuilder.build(
///         element.children(),
///         in: context
///       )
///     }
///   }
/// }
/// ```
@propertyWrapper
public struct ContentBuilderContext<R: RootRegistry, Builder: ContentBuilder>: DynamicProperty {
    @Environment(\.coordinatorEnvironment) private var coordinatorEnvironment
    @LiveContext<R> private var context
    @Environment(\.stylesheet) private var stylesheet
    
    @StateObject private var stylesheetResolver = StylesheetResolver()
    
    final class StylesheetResolver: ObservableObject {
        var previousStylesheetContent: [String] = []
        var resolvedStylesheet: [String:[BuilderModifierContainer<Builder>]] = [:]
    }
    
    public init() {}
    
    public var wrappedValue: Value {
        Value(
            coordinatorEnvironment: coordinatorEnvironment,
            context: context.storage,
            stylesheet: stylesheet as! Stylesheet<R>,
            resolvedStylesheet: stylesheetResolver.resolvedStylesheet
        )
    }
    
    public struct Value {
        let coordinatorEnvironment: CoordinatorEnvironment?
        let context: LiveContextStorage<R>
        let stylesheet: Stylesheet<R>?
        
        let resolvedStylesheet: [String:[BuilderModifierContainer<Builder>]]
        
        public var coordinator: LiveViewCoordinator<R> {
            context.coordinator
        }
        
        public var url: URL {
            context.url
        }
        
        @MainActor
        public var document: Document? {
            context.coordinator.document
        }
        
        func value<OtherBuilder: ContentBuilder>(for _: OtherBuilder.Type = OtherBuilder.self) -> ContentBuilderContext<R, OtherBuilder>.Value {
            return .init(
                coordinatorEnvironment: coordinatorEnvironment,
                context: context,
                stylesheet: stylesheet,
                resolvedStylesheet: stylesheet.flatMap({
                    try? ContentBuilderContext<R, OtherBuilder>.resolveStylesheet($0)
                }) ?? [:]
            )
        }
    }
    
    public func update() {
        let stylesheet = stylesheet as? Stylesheet<R>
        guard stylesheet?.content != stylesheetResolver.previousStylesheetContent
        else { return }
        stylesheetResolver.previousStylesheetContent = stylesheet?.content ?? []
        stylesheetResolver.resolvedStylesheet = stylesheet.flatMap({ try? Self.resolveStylesheet($0) }) ?? [:]
    }
    
    static func resolveStylesheet(
        _ stylesheet: Stylesheet<R>
    ) throws -> [String:[BuilderModifierContainer<Builder>]] {
        if Builder.ModifierType.self == EmptyContentModifier<Builder>.self {
            return [:]
        } else {
            return try stylesheet.content.reduce(into: [:], {
                $0.merge(try StylesheetParser<BuilderModifierContainer<Builder>>(context: .init()).parse($1.utf8), uniquingKeysWith: { $1 })
            })
        }
    }
}

enum BuilderModifierContainer<Builder: ContentBuilder>: ViewModifier, ParseableModifierValue {
    case unsupported
    case modifier(Builder.ModifierType)
    
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            Builder.ModifierType.parser(in: context).map(Self.modifier)
            _AnyNodeParser(context: context).map({ _ in Self.unsupported })
        }
    }
    
    func body(content: Content) -> some View {
        content
    }
}

public extension ContentBuilder {
    /// Build a sequence of nodes.
    ///
    /// Use this method to aggregate content into a final result.
    ///
    /// ```swift
    /// MapContentBuilder.build(
    ///   element.children(),
    ///   context: context
    /// )
    /// ```
    ///
    /// Each child will be built, and ``reduce(accumulated:next:)`` will be called to accumulate the result.
    ///
    /// If the sequence is empty, ``empty()`` will be called.
    static func build<R: RootRegistry>(
        _ nodes: some Sequence<Node>,
        in context: Context<R>
    ) throws -> Content {
        let elements = nodes.compactMap({ $0.asElement() })
        if let first = elements.first {
            var result = try build(first, in: context)
            for element in elements.dropFirst() {
                result = reduce(
                    accumulated: result,
                    next: try build(element, in: context)
                )
            }
            return result
        } else {
            return empty()
        }
    }
    
    /// Builds a single ``ElementNode``.
    ///
    /// This will call ``lookup(_:element:context:)`` to create the content.
    ///
    /// ```swift
    /// MapContentBuilder.build(
    ///   element.children().first!,
    ///   in: context
    /// )
    /// ```
    ///
    /// Any modifiers in the `modifiers` attribute will be decoded and applied.
    /// ``decodeModifier(_:from:)`` will be called for each modifier in the stack.
    static func build<R: RootRegistry>(
        _ element: ElementNode,
        in context: Context<R>
    ) throws -> Content {
        guard let tag = TagName(rawValue: element.tag)
        else { throw ContentBuilderError.unknownTag(element.tag) }
        
        let result = lookup(tag, element: element, context: context)
        
        let classNames = (element.attributeValue(for: "class")?.components(separatedBy: .whitespacesAndNewlines) ?? [])
        + (element.attributeValue(for: "style")?.split(separator: ";" as Character) ?? []).map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
        
        return classNames.reduce(result) {
            (context.resolvedStylesheet[String($1)] ?? []).reduce($0) {
                switch $1 {
                case .unsupported:
                    return $0
                case let .modifier(modifier):
                    return Self.applyModifier(modifier, to: $0, on: element, in: context)
                }
            }
        }
    }
    
    /// Unbox `any ContentModifier<Self>` and apply to ``content``.
    private static func applyModifier<R: RootRegistry>(
        _ modifier: some ContentModifier<Self>,
        to content: Content,
        on element: ElementNode,
        in context: Context<R>
    ) -> Content {
        modifier.apply(
            to: content,
            on: element,
            in: context
        )
    }
    
    /// Builds the children of an ``ElementNode``.
    ///
    /// Prefer this method to build children, as it automatically handles the `template` attribute.
    ///
    /// Defers to ``build(_:in:)-5jedi``.
    static func buildChildren<R: RootRegistry>(
        of element: ElementNode,
        forTemplate template: String? = nil,
        in context: Context<R>
    ) throws -> Content {
        if let template {
            return try build(
                element
                    .children()
                    .filter({ $0.attributes().contains(where: { $0.name == "template" && $0.value == template }) }),
                in: context
            )
        } else {
            return try build(
                element
                    .children()
                    .filter({ !$0.attributes().contains(where: { $0.name == "template" }) }),
                in: context
            )
        }
    }
    
    static func buildChildren<R: RootRegistry>(
        of element: ElementNode,
        forTemplate template: ViewReference,
        in context: Context<R>
    ) throws -> Content {
        return try build(
            element
                .children()
                .filter({ $0.attributes().contains(where: { $0.name == "template" && template.value.contains($0.value ?? "") }) }),
            in: context
        )
    }
}

public extension ContentBuilder {
    /// Builds nested SwiftUI `View` content.
    ///
    /// Use this to include SwiftUI `View` elements that are nested within another DSL.
    ///
    /// ```swift
    /// MapContentBuilder.buildView(
    ///   element.children(),
    ///   in: context
    /// )
    /// ```
    static func buildView<R: RootRegistry, C: RandomAccessCollection>(
        _ nodes: C,
        in context: Context<R>
    ) -> some View where C.Element == Node, C.Index == Int {
        ViewTreeBuilder().fromNodes(
            nodes,
            context: context.context
        )
        .environment(\.coordinatorEnvironment, context.coordinatorEnvironment)
        .environment(\.anyLiveContextStorage, context.context)
    }
    /// Builds nested SwiftUI `View` content.
    ///
    /// Use this to include SwiftUI `View` elements that are nested within another DSL.
    ///
    /// ```swift
    /// MapContentBuilder.buildChildViews(
    ///   of: element,
    ///   in: context
    /// )
    /// ```
    @ViewBuilder
    static func buildChildViews<R: RootRegistry>(
        of element: ElementNode,
        forTemplate template: String? = nil,
        in context: Context<R>
    ) -> some View {
        if let template {
            ViewTreeBuilder().fromNodes(
                element.children()
                    .filter({ $0.attributes().contains(where: { $0.name == "template" && $0.value == template }) }),
                context: context.context
            )
                .environment(\.coordinatorEnvironment, context.coordinatorEnvironment)
                .environment(\.anyLiveContextStorage, context.context)
        } else {
            ViewTreeBuilder().fromNodes(
                element.children()
                    .filter({ !$0.attributes().contains(where: { $0.name == "template" }) }),
                context: context.context
            )
                .environment(\.coordinatorEnvironment, context.coordinatorEnvironment)
                .environment(\.anyLiveContextStorage, context.context)
        }
    }
    
    @ViewBuilder
    static func buildChildViews<R: RootRegistry>(
        of element: ElementNode,
        forTemplate template: ViewReference,
        in context: Context<R>
    ) -> some View {
        ViewTreeBuilder().fromNodes(
            element.children()
                .filter({ $0.attributes().contains(where: { $0.name == "template" && template.value.contains($0.value ?? "") }) }),
            context: context.context
        )
            .environment(\.coordinatorEnvironment, context.coordinatorEnvironment)
            .environment(\.anyLiveContextStorage, context.context)
    }
    
    @ViewBuilder
    static func buildChildText<R: RootRegistry>(
        of element: ElementNode,
        forTemplate template: TextReference,
        in context: Context<R>
    ) -> SwiftUI.Text {
        element.children()
            .lazy
            .filter({ $0.attributes().contains(where: { $0.name == "template" && template.value.contains($0.value ?? "") }) })
            .first?.asElement().flatMap({ Text<R>(element: $0, overrideStylesheet: context.stylesheet).body })
                ?? SwiftUI.Text("")
    }
    
    /// Builds nested content with a ``ContentBuilder`` other than `Self`.
    ///
    /// Use this to include elements from another DSL that are used within this DSL.
    ///
    /// ```swift
    /// MapContentBuilder.build(
    ///   element.children(),
    ///   with: ChartContentBuilder.self,
    ///   in: context
    /// )
    /// ```
    static func build<Builder: ContentBuilder, R: RootRegistry, C: Sequence>(
        _ nodes: C,
        with _: Builder.Type = Builder.self,
        in context: Context<R>
    ) throws -> Builder.Content where C.Element == Node {
        try Builder.build(
            nodes,
            in: context.value(for: Builder.self)
        )
    }
    
    /// Builds nested content with a ``ContentBuilder`` other than `Self`.
    static func buildChildren<Builder: ContentBuilder, R: RootRegistry>(
        of element: ElementNode,
        forTemplate template: String? = nil,
        with _: Builder.Type = Builder.self,
        in context: Context<R>
    ) throws -> Builder.Content {
        try Builder.buildChildren(
            of: element,
            forTemplate: template,
            in: context.value(for: Builder.self)
        )
    }
    
    /// Builds nested content with a ``ContentBuilder`` other than `Self`.
    static func buildChildren<Builder: ContentBuilder, R: RootRegistry>(
        of element: ElementNode,
        forTemplate template: ViewReference,
        with _: Builder.Type = Builder.self,
        in context: Context<R>
    ) throws -> Builder.Content {
        try Builder.buildChildren(
            of: element,
            forTemplate: template,
            in: context.value(for: Builder.self)
        )
    }
}

/// A modifier that can be used with a ``ContentBuilder``.
///
/// ``apply(to:on:in:)`` will be called for each modifier in the `modifiers` attribute on an element.
///
/// Modifiers must be decoded from the ``ContentBuilder/decodeModifier(_:from:registry:)``.
///
/// - Note: Keys are automatically converted from `camelCase` to `snake_case` in the decoder.
public protocol ContentModifier<Builder>: ParseableModifierValue {
    associatedtype Builder: ContentBuilder
    func apply<R: RootRegistry>(
        to content: Builder.Content,
        on element: ElementNode,
        in context: Builder.Context<R>
    ) -> Builder.Content
}

public struct EmptyContentModifier<Builder: ContentBuilder>: ContentModifier {
    public init() {}
    
    public func apply<R>(
        to content: Builder.Content,
        on element: ElementNode,
        in context: Builder.Context<R>
    ) -> Builder.Content where R : RootRegistry {
        return content
    }
    
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ASTNode("__never__", in: context) {}
            .map({ _ in fatalError() })
    }
}

enum ContentBuilderError: Error {
    case unknownTag(String)
}
