//
//  ViewModifierBuilder.swift
//
//
//  Created by Carson Katri on 2/1/23.
//

import SwiftUI

@resultBuilder
public enum ViewModifierBuilder {
    public static func buildBlock<M>(_ modifier: M) -> M where M: ViewModifier {
        modifier
    }
    
    public static func buildEither<TrueModifier, FalseModifier>(
        first: @autoclosure () throws -> TrueModifier
    ) rethrows -> _ConditionalModifier<TrueModifier, FalseModifier>
        where TrueModifier: ViewModifier, FalseModifier: ViewModifier
    {
        _ConditionalModifier(storage: .trueModifier(try first()))
    }
    
    public static func buildEither<TrueModifier, FalseModifier>(
        second: @autoclosure () throws -> FalseModifier
    ) rethrows -> _ConditionalModifier<TrueModifier, FalseModifier>
        where TrueModifier: ViewModifier, FalseModifier: ViewModifier
    {
        _ConditionalModifier(storage: .falseModifier(try second()))
    }
}

@frozen public struct _ConditionalModifier<TrueModifier, FalseModifier>: ViewModifier
    where TrueModifier: ViewModifier, FalseModifier: ViewModifier
{
    @usableFromInline
    @frozen
    internal enum Storage {
        case trueModifier(TrueModifier)
        case falseModifier(FalseModifier)
    }
    
    @usableFromInline
    internal let storage: Storage
    
    @inlinable
    public func body(content: Content) -> some View {
        switch storage {
        case let .trueModifier(modifier):
            content.modifier(modifier)
        case let .falseModifier(modifier):
            content.modifier(modifier)
        }
    }
}
