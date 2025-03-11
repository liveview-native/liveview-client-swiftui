//
//  QuartzCore.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
import QuartzCore
import LiveViewNativeStylesheet

extension CATransform3D {
    @ASTDecodable("CATransform3D")
    public enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(CATransform3D)
    }
}

public extension CATransform3D.Resolvable {
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> CATransform3D {
        switch self {
        case let .__constant(value):
            return value
        }
    }
}
#endif
