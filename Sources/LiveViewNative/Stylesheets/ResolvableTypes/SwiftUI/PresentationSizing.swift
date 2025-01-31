//
//  PresentationSizing.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("PresentationSizing")
@available(iOS 18, macOS 15, tvOS 18, visionOS 2, watchOS 11, *)
indirect enum StylesheetResolvablePresentationSizing: PresentationSizing, StylesheetResolvable {
    case automatic
    case fitted
    case form
    case page
    
    case _fitted(Self, horizontal: AttributeReference<Bool>, vertical: AttributeReference<Bool>)
    case _fittedResolved(Self, horizontal: Bool, vertical: Bool)
    func fitted(horizontal: AttributeReference<Bool>, vertical: AttributeReference<Bool>) -> Self {
        ._fitted(self, horizontal: horizontal, vertical: vertical)
    }
    
    case _sticky(Self, horizontal: AttributeReference<Bool>, vertical: AttributeReference<Bool>)
    case _stickyResolved(Self, horizontal: Bool, vertical: Bool)
    func sticky(horizontal: AttributeReference<Bool> = .constant(false), vertical: AttributeReference<Bool> = .constant(false)) -> Self {
        ._sticky(self, horizontal: horizontal, vertical: vertical)
    }
}

@available(iOS 18, macOS 15, tvOS 18, visionOS 2, watchOS 11, *)
extension StylesheetResolvablePresentationSizing {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        switch self {
        case .automatic:
            return self
        case .fitted:
            return self
        case .form:
            return self
        case .page:
            return self
        case let ._fitted(parent, horizontal, vertical):
            return ._fittedResolved(
                parent,
                horizontal: horizontal.resolve(on: element, in: context),
                vertical: vertical.resolve(on: element, in: context)
            )
        case ._fittedResolved:
            return self
        case let ._sticky(parent, horizontal, vertical):
            return ._stickyResolved(
                parent,
                horizontal: horizontal.resolve(on: element, in: context),
                vertical: vertical.resolve(on: element, in: context)
            )
        case ._stickyResolved:
            return self
        }
    }
    
    func proposedSize(for root: PresentationSizingRoot, context: PresentationSizingContext) -> ProposedViewSize {
        switch self {
        case .automatic:
            return AutomaticPresentationSizing.automatic.proposedSize(for: root, context: context)
        case .fitted:
            return FittedPresentationSizing.fitted.proposedSize(for: root, context: context)
        case .form:
            return FormPresentationSizing.form.proposedSize(for: root, context: context)
        case .page:
            return PagePresentationSizing.page.proposedSize(for: root, context: context)
        case ._fitted:
            fatalError()
        case let ._fittedResolved(parent, horizontal, vertical):
            return parent.fitted(horizontal: horizontal, vertical: vertical).proposedSize(for: root, context: context)
        case ._sticky:
            fatalError()
        case let ._stickyResolved(parent, horizontal, vertical):
            return parent.sticky(horizontal: horizontal, vertical: vertical).proposedSize(for: root, context: context)
        }
    }
}

@available(iOS 18, macOS 15, tvOS 18, visionOS 2, watchOS 11, *)
extension StylesheetResolvablePresentationSizing: AttributeDecodable {
    init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "automatic":
            self = .automatic
        case "fitted":
            self = .fitted
        case "form":
            self = .form
        case "page":
            self = .page
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
