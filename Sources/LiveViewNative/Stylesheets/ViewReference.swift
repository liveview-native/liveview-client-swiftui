import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

/// A reference to nested content from a stylesheet.
///
/// Parses an atom or list of atoms.
///
/// ```elixir
/// :my_view
/// [:view1, :view2]
/// ```
///
/// ```html
/// <Rectangle template="my_view" />
/// <Text template="view1" />
/// <ScrollView template="view2" />
/// ```
public struct ViewReference: ParseableModifierValue {
    let value: [String]

    @MainActor
    public func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> some View {
        ForEach(value, id: \.self) {
            context.buildChildren(of: element, forTemplate: $0)
        }
        .transformEnvironment(\.self) { environment in
            if environment.anyLiveContextStorage == nil {
                environment.anyLiveContextStorage = context.storage
            }
            if environment.coordinatorEnvironment == nil {
                environment.coordinatorEnvironment = .init(context.coordinator, document: context.coordinator.document!)
            }
        }
    }

    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            AtomLiteral().map({
                Self.init(value: [$0])
            })
            ListLiteral {
                AtomLiteral()
            }
            .map(Self.init(value:))
        }
    }
}

/// A type reference that is resolved inline (an argument that accepts `some View`, not `() -> some View`)
///
/// See ``ViewReference`` for more details.
typealias InlineViewReference = ViewReference

/// A ``ViewReference`` that only resolves to `SwiftUI.Text`.
public struct TextReference: ParseableModifierValue {
    let value: String
    
    @MainActor
    public func resolveTemplate<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> ElementNode? {
        context.children(of: element, forTemplate: value).first?.asElement()
    }

    @MainActor
    public func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> SwiftUI.Text {
        resolveTemplate(on: element, in: context).flatMap({
            Text<R>(element: $0, overrideStylesheet: context.coordinator.session.stylesheet).body
        })
            ?? SwiftUI.Text("")
    }

    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        AtomLiteral().map({ Self.init(value: $0) })
    }
}

extension View {
    /// Sets up an observer for a `Text` element used in a `TextReference`.
    ///
    /// When a modifier uses a `TextReference` type,
    /// changes to the content of the `Text` may not update properly
    /// without setting up an observer for the `Text` element.
    ///
    /// This modifier will create an observer that updates the modifiers
    /// provided to `content` whenever the `Text` element receives an update.
    ///
    /// ```swift
    /// struct MyCustomModifier<R: RootRegistry>: ViewModifier {
    ///     let reference: TextReference
    ///     @ObservedElement private var element
    ///     @LiveContext<R> private var context
    ///
    ///     func body(content: Content) -> some View {
    ///         content._observeTextReference(reference, on: element, in: context) { content in
    ///             content.badge(reference.resolve(on: element, in: context))
    ///         }
    ///     }
    /// }
    /// ```
    @MainActor
    func _observeTextReference(
        _ reference: TextReference?,
        on element: ElementNode,
        in context: LiveContext<some RootRegistry>,
        _ content: @escaping (_TextReferenceObserver.ObservedContentBlock.Content) -> some View
    ) -> some View {
        self.modifier(_TextReferenceObserver(element: reference?.resolveTemplate(on: element, in: context) ?? element, content: content))
    }
}

struct _TextReferenceObserver: ViewModifier {
    @EnvironmentObject private var parentObserver: ObservedElement.Observer
    @StateObject private var observer: ObservedElement.Observer
    let element: ElementNode
    let content: (_TextReferenceObserver.ObservedContentBlock.Content) -> any View
    
    init(element: ElementNode, content: @escaping (_TextReferenceObserver.ObservedContentBlock.Content) -> any View) {
        self._observer = .init(wrappedValue: .init(element.id))
        self.element = element
        self.content = content
    }
    
    func body(content: Content) -> some View {
        content
            .environmentObject(parentObserver)
            .modifier(ObservedContentBlock(element: element, content: self.content))
            .environmentObject(observer)
    }
    
    struct ObservedContentBlock: ViewModifier {
        @ObservedElement private var element
        let content: (_TextReferenceObserver.ObservedContentBlock.Content) -> any View
        
        init(element: ElementNode, content: @escaping (_TextReferenceObserver.ObservedContentBlock.Content) -> any View) {
            self._element = .init(element: element)
            self.content = content
        }
        
        func body(content: Content) -> some View {
            AnyView(self.content(content))
        }
    }
}

/// A ``ViewReference`` that only resolves to `ToolbarContent` types.
///
/// Use an atom or list of atoms to reference toolbar content.
///
/// ```elixir
/// :my_toolbar_content
/// [:item1, :item2]
/// ```
///
/// ```html
/// <ToolbarItem template="my_toolbar_content">
///     ...
/// </ToolbarItem>
/// <ToolbarItem template="item1" />
/// <ToolbarItem template="item2" />
/// ```
@_documentation(visibility: public)
struct ToolbarContentReference: ParseableModifierValue {
    let value: [String]
    
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> some ToolbarContent {
        ToolbarTreeBuilder<R>().fromNodes(
            value.reduce(into: [LiveViewNativeCore.Node]()) {
                $0.append(contentsOf: context.children(of: element, forTemplate: $1))
            },
            context: context.storage
        )
    }

    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            AtomLiteral().map({
                Self.init(value: [$0])
            })
            ListLiteral {
                AtomLiteral()
            }
            .map(Self.init(value:))
        }
    }
}

/// A ``ViewReference`` that only resolves to `CustomizableToolbarContent` types.
///
/// Use an atom or list of atoms to reference customizable toolbar content.
///
/// ```elixir
/// :my_toolbar_content
/// [:item1, :item2]
/// ```
///
/// ```html
/// <ToolbarItem template="my_toolbar_content" id="item0">
///     ...
/// </ToolbarItem>
/// <ToolbarItem template="item1" id="item1" />
/// <ToolbarItem template="item2" id="item2" />
/// ```
@_documentation(visibility: public)
struct CustomizableToolbarContentReference: ParseableModifierValue {
    let value: [String]
    
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> some CustomizableToolbarContent {
        CustomizableToolbarTreeBuilder<R>().fromNodes(
            value.reduce(into: [LiveViewNativeCore.Node]()) {
                $0.append(contentsOf: context.children(of: element, forTemplate: $1))
            },
            context: context.storage
        )
    }

    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            AtomLiteral().map({
                Self.init(value: [$0])
            })
            ListLiteral {
                AtomLiteral()
            }
            .map(Self.init(value:))
        }
    }
}

private enum FromNodeValue {
    case n(Node)
    case e(Error)
}

/// A builder for `ToolbarContent`.
@MainActor
struct ToolbarTreeBuilder<R: RootRegistry> {
    @MainActor
    func fromNodes<Nodes>(_ e: Nodes, context c: LiveContextStorage<R>) -> some ToolbarContent
        where Nodes: RandomAccessCollection, Nodes.Index == Int, Nodes.Element == Node
    {
        switch e.count {
        case 1:
            return ToolbarContentBuilder.buildBlock(f(.n(e[0]), c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 2:
            return ToolbarContentBuilder.buildBlock(f(.n(e[0]), c), f(.n(e[1]), c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 3:
            return ToolbarContentBuilder.buildBlock(f(.n(e[0]), c), f(.n(e[1]), c), f(.n(e[2]), c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 4:
            return ToolbarContentBuilder.buildBlock(f(.n(e[0]), c), f(.n(e[1]), c), f(.n(e[2]), c), f(.n(e[3]), c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 5:
            return ToolbarContentBuilder.buildBlock(f(.n(e[0]), c), f(.n(e[1]), c), f(.n(e[2]), c), f(.n(e[3]), c), f(.n(e[4]), c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 6:
            return ToolbarContentBuilder.buildBlock(f(.n(e[0]), c), f(.n(e[1]), c), f(.n(e[2]), c), f(.n(e[3]), c), f(.n(e[4]), c), f(.n(e[5]), c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 7:
            return ToolbarContentBuilder.buildBlock(f(.n(e[0]), c), f(.n(e[1]), c), f(.n(e[2]), c), f(.n(e[3]), c), f(.n(e[4]), c), f(.n(e[5]), c), f(.n(e[6]), c), f(nil, c), f(nil, c), f(nil, c))
        case 8:
            return ToolbarContentBuilder.buildBlock(f(.n(e[0]), c), f(.n(e[1]), c), f(.n(e[2]), c), f(.n(e[3]), c), f(.n(e[4]), c), f(.n(e[5]), c), f(.n(e[6]), c), f(.n(e[7]), c), f(nil, c), f(nil, c))
        case 9:
            return ToolbarContentBuilder.buildBlock(f(.n(e[0]), c), f(.n(e[1]), c), f(.n(e[2]), c), f(.n(e[3]), c), f(.n(e[4]), c), f(.n(e[5]), c), f(.n(e[6]), c), f(.n(e[7]), c), f(.n(e[8]), c), f(nil, c))
        case 10:
            return ToolbarContentBuilder.buildBlock(f(.n(e[0]), c), f(.n(e[1]), c), f(.n(e[2]), c), f(.n(e[3]), c), f(.n(e[4]), c), f(.n(e[5]), c), f(.n(e[6]), c), f(.n(e[7]), c), f(.n(e[8]), c), f(.n(e[9]), c))
        default:
            // Too many children in toolbar content
            return ToolbarContentBuilder.buildBlock(f(.e(ToolbarError.badChildCount(e.count)), c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        }
    }
    
    // alias for typing
    @MainActor
    @inline(__always)
    fileprivate func f(_ n: FromNodeValue?, _ c: LiveContextStorage<R>) -> some ToolbarContent {
        return n.flatMap({ fromNode($0, context: c) })
    }
    
    @MainActor
    @ToolbarContentBuilder
    fileprivate func fromNode(_ node: FromNodeValue, context: LiveContextStorage<R>) -> some ToolbarContent {
        // ToolbarTreeBuilder.fromNode may not be called with a root or leaf node
        switch node {
        case let .n(node):
            if case .element(let element) = node.data {
                Self.lookup(ElementNode(node: node, data: element))
            }
        case let .e(error):
            SwiftUI.ToolbarItem {
                AnyErrorView<R>(error)
            }
        }
    }
    
    @MainActor
    @ToolbarContentBuilder
    static func lookup(_ node: ElementNode) -> some ToolbarContent {
        switch node.tag {
        case "ToolbarItemGroup":
            ToolbarItemGroup<R>(element: node)
        case "ToolbarItem":
            ToolbarItem<R>(element: node)
        case "ToolbarTitleMenu":
            ToolbarTitleMenu<R>(element: node)
        default:
            SwiftUI.ToolbarItem {
                AnyErrorView<R>(ToolbarError.unknownTag(node.tag))
            }
        }
    }
}

/// A builder for `CustomizableToolbarContent`.
@MainActor
struct CustomizableToolbarTreeBuilder<R: RootRegistry> {
    @MainActor
    func fromNodes<Nodes>(_ e: Nodes, context c: LiveContextStorage<R>) -> some CustomizableToolbarContent
        where Nodes: RandomAccessCollection, Nodes.Index == Int, Nodes.Element == Node
    {
        switch e.count {
        case 1:
            return ToolbarContentBuilder.buildBlock(f(.n(e[0]), c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 2:
            return ToolbarContentBuilder.buildBlock(f(.n(e[0]), c), f(.n(e[1]), c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 3:
            return ToolbarContentBuilder.buildBlock(f(.n(e[0]), c), f(.n(e[1]), c), f(.n(e[2]), c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 4:
            return ToolbarContentBuilder.buildBlock(f(.n(e[0]), c), f(.n(e[1]), c), f(.n(e[2]), c), f(.n(e[3]), c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 5:
            return ToolbarContentBuilder.buildBlock(f(.n(e[0]), c), f(.n(e[1]), c), f(.n(e[2]), c), f(.n(e[3]), c), f(.n(e[4]), c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 6:
            return ToolbarContentBuilder.buildBlock(f(.n(e[0]), c), f(.n(e[1]), c), f(.n(e[2]), c), f(.n(e[3]), c), f(.n(e[4]), c), f(.n(e[5]), c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        case 7:
            return ToolbarContentBuilder.buildBlock(f(.n(e[0]), c), f(.n(e[1]), c), f(.n(e[2]), c), f(.n(e[3]), c), f(.n(e[4]), c), f(.n(e[5]), c), f(.n(e[6]), c), f(nil, c), f(nil, c), f(nil, c))
        case 8:
            return ToolbarContentBuilder.buildBlock(f(.n(e[0]), c), f(.n(e[1]), c), f(.n(e[2]), c), f(.n(e[3]), c), f(.n(e[4]), c), f(.n(e[5]), c), f(.n(e[6]), c), f(.n(e[7]), c), f(nil, c), f(nil, c))
        case 9:
            return ToolbarContentBuilder.buildBlock(f(.n(e[0]), c), f(.n(e[1]), c), f(.n(e[2]), c), f(.n(e[3]), c), f(.n(e[4]), c), f(.n(e[5]), c), f(.n(e[6]), c), f(.n(e[7]), c), f(.n(e[8]), c), f(nil, c))
        case 10:
            return ToolbarContentBuilder.buildBlock(f(.n(e[0]), c), f(.n(e[1]), c), f(.n(e[2]), c), f(.n(e[3]), c), f(.n(e[4]), c), f(.n(e[5]), c), f(.n(e[6]), c), f(.n(e[7]), c), f(.n(e[8]), c), f(.n(e[9]), c))
        default:
            // Too many children in toolbar content
            return ToolbarContentBuilder.buildBlock(f(.e(ToolbarError.badChildCount(e.count)), c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c), f(nil, c))
        }
    }
    
    // alias for typing
    @MainActor
    @inline(__always)
    fileprivate func f(_ n: FromNodeValue?, _ c: LiveContextStorage<R>) -> some CustomizableToolbarContent {
        return n.flatMap({ fromNode($0, context: c) })
    }
    
    @MainActor
    @ToolbarContentBuilder
    fileprivate func fromNode(_ node: FromNodeValue, context: LiveContextStorage<R>) -> some CustomizableToolbarContent {
        // CustomizableToolbarTreeBuilder.fromNode may not be called with a root or leaf node
        switch node {
        case let .n(node):
            if case .element(let element) = node.data {
                Self.lookup(ElementNode(node: node, data: element))
            }
        case let .e(error):
            SwiftUI.ToolbarItem(id: error.localizedDescription) {
                AnyErrorView<R>(error)
            }
        }
    }
    
    @MainActor
    @ToolbarContentBuilder
    static func lookup(_ node: ElementNode) -> some CustomizableToolbarContent {
        switch node.tag {
        case "ToolbarItem":
            CustomizableToolbarItem<R>(element: node)
        case "ToolbarTitleMenu":
            ToolbarTitleMenu<R>(element: node)
        default:
            SwiftUI.ToolbarItem(id: node.tag) {
                AnyErrorView<R>(ToolbarError.unknownTag(node.tag))
            }
        }
    }
}

enum ToolbarError: LocalizedError {
    case badChildCount(Int)
    case unknownTag(String)
    
    var errorDescription: String? {
        switch self {
        case let .badChildCount(count):
            return "\(count) is an invalid number of children for a toolbar. Toolbar supports 1-10 children."
        case let .unknownTag(tag):
            return "Unsupported toolbar content '\(tag)'"
        }
    }
}
