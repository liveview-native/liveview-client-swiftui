import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

/// A reference to nested content from a stylesheet.
///
/// Parses an atom or list of atoms.
public struct ViewReference: ParseableModifierValue {
    let value: [String]

    public func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> some View {
        ForEach(value, id: \.self) {
            context.buildChildren(of: element, forTemplate: $0)
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
typealias InlineViewReference = ViewReference

/// A `ViewReference` that only resolves to `SwiftUI.Text`.
public struct TextReference: ParseableModifierValue {
    let value: String

    @MainActor
    public func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> SwiftUI.Text {
        context.children(of: element, forTemplate: value).first?.asElement().flatMap({
            Text<R>(element: $0, overrideStylesheet: context.coordinator.session.stylesheet).body
        })
            ?? SwiftUI.Text("")
    }

    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        AtomLiteral().map({ Self.init(value: $0) })
    }
}

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
struct ToolbarTreeBuilder<R: RootRegistry> {
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
    @inline(__always)
    fileprivate func f(_ n: FromNodeValue?, _ c: LiveContextStorage<R>) -> some ToolbarContent {
        return n.flatMap({ fromNode($0, context: c) })
    }
    
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
struct CustomizableToolbarTreeBuilder<R: RootRegistry> {
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
    @inline(__always)
    fileprivate func f(_ n: FromNodeValue?, _ c: LiveContextStorage<R>) -> some CustomizableToolbarContent {
        return n.flatMap({ fromNode($0, context: c) })
    }
    
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
