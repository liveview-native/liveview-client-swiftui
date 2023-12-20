//
//  ViewModifierBuilder.swift
//
//
//  Created by Carson Katri on 2/1/23.
//

import SwiftUI

/// A Swift result builder that allows building a single, concrete `ViewModifier` from a set of conditional modifiers.
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
    
    public static func buildOptional<M>(_ component: M?) -> _ConditionalModifier<M, EmptyModifier> where M: ViewModifier {
        _ConditionalModifier(storage: component.map({ .trueModifier($0) }) ?? .falseModifier(.init()))
    }
    
    public static func buildLimitedAvailability<M>(_ component: M) -> _AnyViewModifier where M: ViewModifier {
        _AnyViewModifier(component)
    }
}

/// A type-erased `ViewModifier`.
public struct _AnyViewModifier: ViewModifier {
    let apply: (any View) -> AnyView
    
    init(_ modifier: some ViewModifier) {
        func applyModifier(_ view: some View) -> AnyView {
            AnyView(view.modifier(modifier))
        }
        self.apply = { applyModifier($0) }
    }
    
    public func body(content: Content) -> some View {
        apply(content)
    }
}

/// A `ViewModifier` that switches between two possible modifier types.
public struct _ConditionalModifier<TrueModifier, FalseModifier>: ViewModifier
    where TrueModifier: ViewModifier, FalseModifier: ViewModifier
{
    @usableFromInline
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
