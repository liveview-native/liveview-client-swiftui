//
//  ParseableRangeExpression.swift
//
//
//  Created by Carson Katri on 10/25/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// A range of values with a given bound type.
///
/// Use range operators to create a range in a stylesheet.
///
/// ### Closed Ranges
/// Use `...` with an upper and lower bound to build a closed range.
///
/// ```swift
/// 1...10
/// ```
///
/// ### Partial Ranges
/// Use `...` after a lower bound to build a partial range from a value.
///
/// ```swift
/// 1...
/// ```
///
/// Use `...` before an upper bound to build a partial range through a value.
///
/// ```swift
/// ...10
/// ```
///
/// Use `..<` before an upper bound to build a partial range up to a value.
///
/// ```swift
/// ..<10
/// ```
///
/// ### Half Open Ranges
/// Use `..<` with an upper and lower bound to build a half open range.
///
/// ```swift
/// 1..<10
/// ```
@_documentation(visibility: public)
struct ParseableRangeExpression<Bound: Comparable & ParseableModifierValue>: @preconcurrency RangeExpression, ParseableModifierValue {
    let value: any RangeExpression<Bound>
    
    func relative<C>(to collection: C) -> Range<Bound> where C : Collection, Bound == C.Index {
        value.relative(to: collection)
    }
    
    func contains(_ element: Bound) -> Bool {
        value.contains(element)
    }
    
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            PartialRangeFrom<Bound>.parser(in: context).map({ .init(value: $0) })
            PartialRangeThrough<Bound>.parser(in: context).map({ .init(value: $0) })
            PartialRangeUpTo<Bound>.parser(in: context).map({ .init(value: $0) })
            ClosedRange<Bound>.parser(in: context).map({ .init(value: $0) })
            Range<Bound>.parser(in: context).map({ .init(value: $0) })
        }
    }
}

extension PartialRangeFrom: ParseableModifierValue where Bound: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseablePartialRangeFrom.parser(in: context).map(\.value)
    }
    
    @ASTDecodable("...")
    struct ParseablePartialRangeFrom {
        let value: PartialRangeFrom<Bound>
        
        init(_ lowerBound: Bound, _ upperBound: NilConstant) {
            self.value = lowerBound...
        }
    }
}

extension PartialRangeThrough: ParseableModifierValue where Bound: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseablePartialRangeThrough.parser(in: context).map(\.value)
    }
    
    @ASTDecodable("...")
    struct ParseablePartialRangeThrough {
        let value: PartialRangeThrough<Bound>
        
        init(_ lowerBound: NilConstant, _ upperBound: Bound) {
            self.value = ...upperBound
        }
    }
}

extension PartialRangeUpTo: ParseableModifierValue where Bound: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseablePartialRangeUpTo.parser(in: context).map(\.value)
    }
    
    @ASTDecodable("..<")
    struct ParseablePartialRangeUpTo {
        let value: PartialRangeUpTo<Bound>
        
        init(_ lowerBound: NilConstant, _ upperBound: Bound) {
            self.value = ..<upperBound
        }
    }
}

extension ClosedRange: ParseableModifierValue where Bound: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableClosedRange.parser(in: context).map(\.value)
    }
    
    @ASTDecodable("...")
    struct ParseableClosedRange {
        let value: ClosedRange<Bound>
        
        init(_ lowerBound: Bound, _ upperBound: Bound) {
            self.value = lowerBound...upperBound
        }
    }
}

extension Range: ParseableModifierValue where Bound: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableRange.parser(in: context).map(\.value)
    }
    
    @ASTDecodable("..<")
    struct ParseableRange {
        let value: Range<Bound>
        
        init(_ lowerBound: Bound, _ upperBound: Bound) {
            self.value = lowerBound..<upperBound
        }
    }
}
