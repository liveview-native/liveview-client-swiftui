//
//  TabViewStyle.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("TabViewStyle")
enum StylesheetResolvableTabViewStyle: StylesheetResolvable, @preconcurrency Decodable {
    case automatic
    
    @available(macOS, unavailable)
    case page

    #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
    case _page(indexDisplayMode: AttributeReference<PageTabViewStyle.IndexDisplayMode.Resolvable>)
    case _pageResolved(indexDisplayMode: PageTabViewStyle.IndexDisplayMode)
    #endif
    
    #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(macOS, unavailable)
    static func page(indexDisplayMode: AttributeReference<PageTabViewStyle.IndexDisplayMode.Resolvable>) -> Self {
        ._page(indexDisplayMode: indexDisplayMode)
    }
    #endif
}

#if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
extension PageTabViewStyle.IndexDisplayMode.Resolvable: @preconcurrency AttributeDecodable {
    init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "always":
            self = .__constant(.always)
        case "automatic":
            self = .__constant(.automatic)
        case "never":
            self = .__constant(.never)
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
#endif

#if os(watchOS)
extension VerticalPageTabViewStyle.TransitionStyle.Resolvable: @preconcurrency AttributeDecodable {
    init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .__constant(.automatic)
        case "blur":
            self = .__constant(.blur)
        case "identity":
            self = .__constant(.identity)
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
#endif

extension StylesheetResolvableTabViewStyle {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        switch self {
        case .automatic:
            return self
        #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case .page:
            return self
        case let ._page(indexDisplayMode):
            return ._pageResolved(indexDisplayMode: indexDisplayMode.resolve(on: element, in: context).resolve(on: element, in: context))
        case ._pageResolved:
            return self
        #endif
        #if os(watchOS)
        case .verticalPage:
            return self
        case let ._verticalPage(transitionStyle):
            return ._verticalPageResolved(transitionStyle: transitionStyle.resolve(on: element, in: context).resolve(on: element, in: context))
        case ._verticalPageResolved:
            return self
        #endif
        }
    }
}

extension View {
    @_disfavoredOverload
    @ViewBuilder
    func tabViewStyle(_ style: StylesheetResolvableTabViewStyle) -> some View {
        switch style {
        case .automatic:
            self.tabViewStyle(DefaultTabViewStyle.automatic)
        #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case .page:
            self.tabViewStyle(PageTabViewStyle.page)
        case let ._pageResolved(indexDisplayMode):
            self.tabViewStyle(PageTabViewStyle.page(indexDisplayMode: indexDisplayMode))
        case ._page:
            fatalError()
        #endif
        #if os(watchOS)
        case .verticalPage:
            self.tabViewStyle(VerticalPageTabViewStyle.verticalPage)
        case let ._verticalPageResolved(transitionStyle):
            self.tabViewStyle(VerticalPageTabViewStyle.verticalPage(transitionStyle: transitionStyle))
        case ._verticalPage:
            fatalError()
        #endif
        }
    }
}

extension StylesheetResolvableTabViewStyle: @preconcurrency AttributeDecodable {
    init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case "page":
            self = .page
        #endif
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
