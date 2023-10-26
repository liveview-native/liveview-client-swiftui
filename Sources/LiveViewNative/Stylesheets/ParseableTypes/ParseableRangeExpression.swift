//
//  ParseableRangeExpression.swift
//
//
//  Created by Carson Katri on 10/25/23.
//

import SwiftUI
import LiveViewNativeStylesheet

struct ParseableRangeExpression<Bound: Comparable & ParseableModifierValue>: RangeExpression, ParseableModifierValue {
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
    
    @ParseableExpression
    struct ParseablePartialRangeFrom {
        static var name: String { "..." }
        
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
    
    @ParseableExpression
    struct ParseablePartialRangeThrough {
        static var name: String { "..." }
        
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
    
    @ParseableExpression
    struct ParseablePartialRangeUpTo {
        static var name: String { "..<" }
        
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
    
    @ParseableExpression
    struct ParseableClosedRange {
        static var name: String { "..." }
        
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
    
    @ParseableExpression
    struct ParseableRange {
        static var name: String { "..<" }
        
        let value: Range<Bound>
        
        init(_ lowerBound: Bound, _ upperBound: Bound) {
            self.value = lowerBound..<upperBound
        }
    }
}
