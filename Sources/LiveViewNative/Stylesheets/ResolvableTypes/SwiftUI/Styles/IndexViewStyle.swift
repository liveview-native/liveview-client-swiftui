//
//  IndexViewStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("IndexViewStyle")
enum StylesheetResolvableIndexViewStyle: StylesheetResolvable, @preconcurrency Decodable {
    case page
    
    case _page(backgroundDisplayMode: AttributeReference<PageIndexViewStyle.BackgroundDisplayMode.Resolvable>)
    case _pageResolved(backgroundDisplayMode: PageIndexViewStyle.BackgroundDisplayMode)
    static func page(backgroundDisplayMode: AttributeReference<PageIndexViewStyle.BackgroundDisplayMode.Resolvable>) -> Self {
        ._page(backgroundDisplayMode: backgroundDisplayMode)
    }
}

extension PageIndexViewStyle.BackgroundDisplayMode.Resolvable: AttributeDecodable {
    public nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        fatalError()
    }
}

extension StylesheetResolvableIndexViewStyle {
    @MainActor
    func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> Self where R : RootRegistry {
        switch self {
        case .page:
            return self
        case let ._page(backgroundDisplayMode):
            return ._pageResolved(backgroundDisplayMode: backgroundDisplayMode.resolve(on: element, in: context).resolve(on: element, in: context))
        case ._pageResolved:
            return self
        }
    }
}

extension View {
    @_disfavoredOverload
    @ViewBuilder
    func indexViewStyle(_ style: StylesheetResolvableIndexViewStyle) -> some View {
        switch style {
        case .page:
            self.indexViewStyle(.page)
        case let ._pageResolved(backgroundDisplayMode):
            self.indexViewStyle(.page(backgroundDisplayMode: backgroundDisplayMode))
        case ._page:
            fatalError()
        }
    }
}

extension StylesheetResolvableIndexViewStyle: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "page":
            self = .page
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
#endif
