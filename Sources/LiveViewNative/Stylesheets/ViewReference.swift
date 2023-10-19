import SwiftUI
import LiveViewNativeStylesheet

struct ViewReference: ParseableModifierValue {
    let value: [String]

    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> some View {
        ForEach(value, id: \.self) {
            context.buildChildren(of: element, forTemplate: $0)
        }
    }

    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            String.parser(in: context).map({ Self.init(value: [$0]) })
            Array<String>.parser(in: context).map(Self.init(value:))
        }
    }
}

struct TextReference: ParseableModifierValue {
    let value: String

    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> SwiftUI.Text {
        context.children(of: element, forTemplate: value).first?.asElement().flatMap({ Text<R>(element: $0).body })
            ?? SwiftUI.Text("")
    }

    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        String.parser(in: context).map({ Self.init(value: $0) })
    }
}
