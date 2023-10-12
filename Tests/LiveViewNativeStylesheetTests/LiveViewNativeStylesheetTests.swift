import XCTest
import SwiftUI
@testable import LiveViewNativeStylesheet

@ParseableExpression
struct FrameModifier: ViewModifier, Equatable {
    static let name = "frame"
    
    let mode: Mode
    enum Mode {
        case fixed
        case flexible
    }
    let minWidth: CGFloat?
    let width: CGFloat?
    let maxWidth: CGFloat?
    let minHeight: CGFloat?
    let height: CGFloat?
    let maxHeight: CGFloat?
    
    init(width: Double?, height: Double?) {
        self.minWidth = nil
        self.width = width.flatMap(CGFloat.init)
        self.maxWidth = nil
        self.minHeight = nil
        self.height = height.flatMap(CGFloat.init)
        self.maxHeight = nil
        
        self.mode = .fixed
    }
    
    init(
        minWidth: Double?,
        idealWidth: Double?,
        maxWidth: Double?,
        minHeight: Double?,
        idealHeight: Double?,
        maxHeight: Double?
    ) {
        self.minWidth = minWidth.flatMap(CGFloat.init)
        self.width = idealWidth.flatMap(CGFloat.init)
        self.maxWidth = maxWidth.flatMap(CGFloat.init)
        self.minHeight = minHeight.flatMap(CGFloat.init)
        self.height = idealHeight.flatMap(CGFloat.init)
        self.maxHeight = maxHeight.flatMap(CGFloat.init)
        
        self.mode = .flexible
    }
    
    func body(content: Content) -> some View {
        switch mode {
        case .fixed:
            content.frame(width: width, height: height)
        case .flexible:
            content.frame(minWidth: minWidth, idealWidth: width, maxWidth: maxWidth, minHeight: minHeight, idealHeight: height, maxHeight: maxHeight)
        }
    }
}

// {:foregroundColor, [], [[color: {:., [], [nil, :clear]}]]}
@ParseableExpression
struct ForegroundColorModifier: ViewModifier {
    static let name = "foregroundColor"
    
    let color: Color?
    
    init(color: Color?) {
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content.foregroundColor(color)
    }
}

@ParseableExpression
struct ColorModifier: ViewModifier {
    static let name = "color"
    
    let color: TestColor?
    
    init(color: TestColor?) {
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content
    }
}

@ParseableExpression
struct BackgroundModifier: ViewModifier {
    static var name: String { "background" }
    
    let content: String?
    
    init(content: String?) {
        self.content = content
    }
    
    func body(content: Content) -> some View {
        content.background(.foreground)
    }
}

indirect enum TestColor: ParseableModifierValue, Equatable {
    case foo
    case bar
    case baz(BazNode)
    case qux
    case multiple([Self])
    
    public static func parser() -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            OneOf {
                ConstantAtomLiteral("foo").map({ Self.foo })
                ConstantAtomLiteral("bar").map({ Self.bar })
                BazNode.parser().map({ Self.baz($0) })
                ConstantAtomLiteral("qux").map({ Self.qux })
            }
        }
        .collect()
        .map(Self.multiple)
    }
    
    @ParseableExpression
    struct BazNode: Equatable {
        static let name = "baz"
        
        let a: Int
        let b: Int
        
        init(_ a: Int, _ b: Int) {
            self.a = a
            self.b = b
        }
    }
}

extension ForegroundStyle: ParseableModifierValue {
    public static func parser() -> some Parser<Substring.UTF8View, Self> {
        ConstantAtomLiteral("foreground").map({ Self.init() })
    }
}

extension HierarchicalShapeStyle: ParseableModifierValue {
    public static func parser() -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ConstantAtomLiteral("primary").map({ Self.primary })
            ConstantAtomLiteral("secondary").map({ Self.secondary })
            ConstantAtomLiteral("tertiary").map({ Self.tertiary })
            ConstantAtomLiteral("quaternary").map({ Self.quaternary })
        }
    }
}

struct ShapeStyleModifier {
    let modify: (AnyShapeStyle) -> AnyShapeStyle
    
    init(_ modify: @escaping (AnyShapeStyle) -> AnyShapeStyle) {
        self.modify = modify
    }
}

extension Color {
    static func parser() -> some Parser<Substring.UTF8View, Self> {
        MemberExpression {
            OneOf {
                NilLiteral()
                ConstantAtomLiteral("Color")
            }
        } member: {
            OneOf {
                ConstantAtomLiteral("clear").map({ Color.clear })
                
                AtomLiteral().map({ Color($0) })
            }
        }
        .map(\.member)
    }
}

enum TestRegistry: RootRegistry {
    public typealias Modifiers = _ConditionalModifier<
        FrameModifier,
        ForegroundColorModifier
    >
}

final class LiveViewNativeStylesheetTests: XCTestCase {
    func testSimpleFrame() throws {
        XCTAssertEqual(
            try FrameModifier.parser().parse(#"{:frame, [], [[width: 3, height: 10]]}"#),
            FrameModifier(width: 3, height: 10)
        )
        XCTAssertEqual(
            try FrameModifier.parser().parse(#"{:frame, [], [[height: 1.2, width: 0.5]]}"#),
            FrameModifier(width: 0.5, height: 1.2)
        )
        XCTAssertEqual(
            try FrameModifier.parser().parse(#"{:frame, [], [[width: 3]]}"#),
            FrameModifier(width: 3, height: nil)
        )
        XCTAssertEqual(
            try FrameModifier.parser().parse(#"{:frame, [], [[height: 3]]}"#),
            FrameModifier(width: nil, height: 3)
        )
        XCTAssertThrowsError(try FrameModifier.parser().parse(#"{:frame, [], [2, [error: 5]]}"#))
    }
    
    func testImplicitMember() throws {
        let fg = try ForegroundColorModifier.parser().parse(#"{:foregroundColor, [], [[color: {:., [], [:Color, :clear]}]]}"#)
        print(fg)
    }
    
    func testStylesheet() throws {
        let stylesheet = try Stylesheet<TestRegistry>(
            from: #"""
            %{
                "w-82" => [{:frame, [], [[width: 82]]}],
                "fg-color-clear" => [{:foregroundColor, [], [[color: {:., [], [nil, :clear]}]]}],
                "fg-color:elixirpurple" => [
                    {:foregroundColor, [], [[color: {:., [], [nil, :elixirpurple]}]]}
                ]
            }
            """#
        )
        print(stylesheet)
    }
    
    func testArray() throws {
        XCTAssertEqual(try Array<String>.parser().parse(#"["hello", "world", "!"]"#), ["hello", "world", "!"])
    }
    
    func testComplexMembers() throws {
        let color = try ColorModifier.parser().parse(#"{:color, [], [[color: {:., [], [nil, {:., [], [:foo, {:., [], [:bar, {:., [], [{:baz, [], [1, 2]}, :qux]}]}]}]}]]}"#)
//        let color = try TestColor.parser().parse(#"{:.,[],[nil,{:.,[],[:foo,{:.,[],[:bar,{:.,[],[{:baz,[],[1,2]},:qux]}]}]}]}"#)
        XCTAssertEqual(color.color, TestColor.multiple([.foo, .bar, .baz(.init(1, 2)), .qux]))
    }
    
    func testAnyShapeStyle() throws {
        let style = try AnyShapeStyle.parser().parse(#"{:., [], [nil, {:., [], [:primary, {:., [], [{:opacity, [], [0.5]}, {:blend_mode, [], [:difference]}]}]}]}"#)
        print(style)
    }
    
    func testBackground() throws {
        print(try BackgroundModifier.parser().parse(#"{:background, [], [[content: :content]]}"#))
    }
}

extension AnyShapeStyle: ParseableModifierValue {
    enum Modifier {
        case opacity(Opacity)
        case blendMode(BlendMode)
        
        @ParseableExpression
        struct Opacity {
            static let name = "opacity"
            
            let opacity: Double
            
            init(_ opacity: Double) {
                self.opacity = opacity
            }
        }
        
        @ParseableExpression
        struct BlendMode {
            static let name = "blend_mode"
            
            let mode: SwiftUI.BlendMode
            
            init(_ mode: SwiftUI.BlendMode) {
                self.mode = mode
            }
        }
        
        func apply(to style: some ShapeStyle) -> any ShapeStyle {
            switch self {
            case let .opacity(opacity):
                return style.opacity(opacity.opacity)
            case let .blendMode(mode):
                return style.blendMode(mode.mode)
            }
        }
    }
    
    public static func parser() -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            OneOf {
                ConstantAtomLiteral("primary").map({ HierarchicalShapeStyle.primary })
                ConstantAtomLiteral("secondary").map({ HierarchicalShapeStyle.secondary })
                ConstantAtomLiteral("tertiary").map({ HierarchicalShapeStyle.tertiary })
                ConstantAtomLiteral("quaternary").map({ HierarchicalShapeStyle.quaternary })
            }
        } member: {
            OneOf {
                Modifier.Opacity.parser().map({ Modifier.opacity($0) })
                Modifier.BlendMode.parser().map({ Modifier.blendMode($0) })
            }
        }
        .map({ (components: (base: any ShapeStyle, members: [Modifier])) -> Self in
            var result: any ShapeStyle = components.base
            for modifier in components.members {
                result = modifier.apply(to: result)
            }
            return AnyShapeStyle(result)
        })
    }
}

extension BlendMode: ParseableModifierValue {
    public static func parser() -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ConstantAtomLiteral("normal").map({ .normal })
            ConstantAtomLiteral("multiply").map({ .multiply })
            ConstantAtomLiteral("screen").map({ .screen })
            ConstantAtomLiteral("overlay").map({ .overlay })
            ConstantAtomLiteral("darken").map({ .darken })
            ConstantAtomLiteral("lighten").map({ .lighten })
            ConstantAtomLiteral("color_Dodge").map({ .colorDodge })
            ConstantAtomLiteral("color_burn").map({ .colorBurn })
            ConstantAtomLiteral("soft_light").map({ .softLight })
            ConstantAtomLiteral("hard_light").map({ .hardLight })
            ConstantAtomLiteral("difference").map({ .difference })
            ConstantAtomLiteral("exclusion").map({ .exclusion })
            ConstantAtomLiteral("hue").map({ .hue })
            ConstantAtomLiteral("saturation").map({ .saturation })
            ConstantAtomLiteral("color").map({ .color })
            ConstantAtomLiteral("luminosity").map({ .luminosity })
            ConstantAtomLiteral("source_Atop").map({ .sourceAtop })
            ConstantAtomLiteral("destination_over").map({ .destinationOver })
            ConstantAtomLiteral("destination_out").map({ .destinationOut })
            ConstantAtomLiteral("plus_darker").map({ .plusDarker })
            ConstantAtomLiteral("plus_lighter").map({ .plusLighter })
        }
    }
}
