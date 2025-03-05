//
//  DeveloperToolsSupport.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import DeveloperToolsSupport
import LiveViewNativeStylesheet

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ColorResource {
    @ASTDecodable("ColorResource")
    public enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(ColorResource)
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public extension ColorResource.Resolvable {
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> ColorResource {
        switch self {
        case let .__constant(value):
            return value
        }
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ImageResource {
    @ASTDecodable("ImageResource")
    public enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(ImageResource)
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public extension ImageResource.Resolvable {
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> ImageResource {
        switch self {
        case let .__constant(value):
            return value
        }
    }
}
