import SwiftUI
import SwiftSyntax

/// Modifier for rasterizing a view hierarchy.
///
/// Usage:
/// ```html
/// <vstack modifiers="drawingGroup()">
/// <vstack modifiers="drawingGroup(opaque: true)">
/// <vstack modifiers="drawingGroup(opaque: true, colorMode: .linear)">
/// ```
public enum DrawingGroupModifier<Library: ElementLibrary>: @unchecked Sendable {
    case drawingGroup(opaque: Bool, colorMode: ColorRenderingMode)
}

extension DrawingGroupModifier: RuntimeViewModifier {
    public static var baseName: String { "drawingGroup" }

    public init(syntax: FunctionCallExprSyntax) throws {
        let opaque = syntax.argument(named: "opaque").flatMap({ Bool(syntax: $0.expression) }) ?? false
        let colorMode = syntax.argument(named: "colorMode").flatMap({ ColorRenderingMode(syntax: $0.expression) }) ?? .nonLinear
        self = .drawingGroup(opaque: opaque, colorMode: colorMode)
    }

    @ViewBuilder
    public func body(content _content: Content) -> some View {
        switch self {
        case .drawingGroup(let opaque, let colorMode):
            _content.drawingGroup(opaque: opaque, colorMode: colorMode)
        }
    }
}
