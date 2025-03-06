//
//  CoreGraphics.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import CoreGraphics
import LiveViewNativeStylesheet

extension CGPoint {
    @ASTDecodable("CGPoint")
    @MainActor
    public enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(CGPoint)
        case _init(x: AttributeReference<CGFloat>, y: AttributeReference<CGFloat>)
        
        init(x: AttributeReference<CGFloat>, y: AttributeReference<CGFloat>) {
            self = ._init(x: x, y: y)
        }
        
        static var zero: Self { ._init(x: .constant(0), y: .constant(0)) }
    }
}

public extension CGPoint.Resolvable {
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> CGPoint {
        switch self {
        case let .__constant(value):
            return value
        case ._init(let x, let y):
            return .init(x: x.resolve(on: element, in: context), y: y.resolve(on: element, in: context))
        }
    }
}

extension CGVector {
    @ASTDecodable("CGVector")
    @MainActor
    public enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(CGVector)
        case _init(dx: AttributeReference<CGFloat>, dy: AttributeReference<CGFloat>)
        
        init(dx: AttributeReference<CGFloat>, dy: AttributeReference<CGFloat>) {
            self = ._init(dx: dx, dy: dy)
        }
        
        static var zero: Self { ._init(dx: .constant(0), dy: .constant(0)) }
    }
}

public extension CGVector.Resolvable {
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> CGVector {
        switch self {
        case let .__constant(value):
            return value
        case ._init(let dx, let dy):
            return .init(dx: dx.resolve(on: element, in: context), dy: dy.resolve(on: element, in: context))
        }
    }
}

extension CGSize {
    @MainActor
    public enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(CGSize)
        case _reference(AttributeReference<CGSize>)
        case _ast(ASTCGSize)
        
        public init(from decoder: any Decoder) throws {
            var container = try decoder.singleValueContainer()
            
            if let reference = try? container.decode(AttributeReference<CGSize>.self) {
                self = ._reference(reference)
            } else {
                self = ._ast(try container.decode(ASTCGSize.self))
            }
        }
        
        @ASTDecodable("CGSize")
        public enum ASTCGSize: @preconcurrency Decodable {
            case _init(width: AttributeReference<CGFloat>, height: AttributeReference<CGFloat>)
            
            init(width: AttributeReference<CGFloat>, height: AttributeReference<CGFloat>) {
                self = ._init(width: width, height: height)
            }
        }
    }
}

public extension CGSize.Resolvable {
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> CGSize {
        switch self {
        case let .__constant(value):
            return value
        case let ._reference(reference):
            return reference.resolve(on: element, in: context)
        case ._ast(._init(let width, let height)):
            return .init(width: width.resolve(on: element, in: context), height: height.resolve(on: element, in: context))
        }
    }
}

extension CGRect {
    @ASTDecodable("CGRect")
    @MainActor
    public enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(CGRect)
        case _init1(origin: CGPoint.Resolvable, size: CGSize.Resolvable)
        case _init2(x: AttributeReference<CGFloat>, y: AttributeReference<CGFloat>, width: AttributeReference<CGFloat>, height: AttributeReference<CGFloat>)
        
        init(origin: CGPoint.Resolvable, size: CGSize.Resolvable) {
            self = ._init1(origin: origin, size: size)
        }
        
        init(x: AttributeReference<CGFloat>, y: AttributeReference<CGFloat>, width: AttributeReference<CGFloat>, height: AttributeReference<CGFloat>) {
            self = ._init2(x: x, y: y, width: width, height: height)
        }
    }
}

public extension CGRect.Resolvable {
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> CGRect {
        switch self {
        case let .__constant(value):
            return value
        case let ._init1(origin, size):
            return .init(origin: origin.resolve(on: element, in: context), size: size.resolve(on: element, in: context))
        case let ._init2(x, y, width, height):
            return .init(x: x.resolve(on: element, in: context), y: y.resolve(on: element, in: context), width: width.resolve(on: element, in: context), height: height.resolve(on: element, in: context))
        }
    }
}

extension CGPath {
    @ASTDecodable("CGPath")
    public enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(CGPath)
    }
}

public extension CGPath.Resolvable {
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> CGPath {
        switch self {
        case let .__constant(value):
            return value
        }
    }
}

extension CGMutablePath {
    @ASTDecodable("CGMutablePath")
    public enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(CGMutablePath)
    }
}

public extension CGMutablePath.Resolvable {
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> CGMutablePath {
        switch self {
        case let .__constant(value):
            return value
        }
    }
}

extension CGLineCap {
    @ASTDecodable("CGLineCap")
    public enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(CGLineCap)
        case butt
        case round
        case square
    }
}

public extension CGLineCap.Resolvable {
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> CGLineCap {
        switch self {
        case let .__constant(value):
            return value
        case .butt:
            return .butt
        case .round:
            return .round
        case .square:
            return .square
        }
    }
}

extension CGLineJoin {
    @ASTDecodable("CGLineJoin")
    public enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(CGLineJoin)
        case miter
        case round
        case bevel
    }
}

public extension CGLineJoin.Resolvable {
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> CGLineJoin {
        switch self {
        case let .__constant(value):
            return value
        case .miter:
            return .miter
        case .round:
            return .round
        case .bevel:
            return .bevel
        }
    }
}

extension CGAffineTransform {
    @ASTDecodable("CGAffineTransform")
    public enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(CGAffineTransform)
    }
}

public extension CGAffineTransform.Resolvable {
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> CGAffineTransform {
        switch self {
        case let .__constant(value):
            return value
        }
    }
}

extension CGImage {
    @ASTDecodable("CGImage")
    public enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(CGImage)
    }
}

public extension CGImage.Resolvable {
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> CGImage {
        switch self {
        case let .__constant(value):
            return value
        }
    }
}

extension CGColor {
    @ASTDecodable("CGColor")
    public enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(CGColor)
    }
}

public extension CGColor.Resolvable {
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> CGColor {
        switch self {
        case let .__constant(value):
            return value
        }
    }
}

extension CGFloat {
    public enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(CGFloat)
        case reference(AttributeReference<CGFloat>)
        
        @ASTDecodable("CGFloat")
        enum Member: @preconcurrency Decodable {
            case infinity
            case pi
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let member = try? container.decode(Member.self) {
                switch member {
                case .infinity:
                    self = .__constant(.infinity)
                case .pi:
                    self = .__constant(.pi)
                }
            } else {
                self = .reference(try container.decode(AttributeReference<CGFloat>.self))
            }
        }
        
        public func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> CGFloat where R : RootRegistry {
            switch self {
            case let .__constant(constant):
                return constant
            case let .reference(reference):
                return reference.resolve(on: element, in: context)
            }
        }
    }
}
