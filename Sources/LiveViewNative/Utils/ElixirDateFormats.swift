//
//  DateParsing.swift
//  
//
//  Created by Carson Katri on 1/17/23.
//

import Foundation

/// A formatter that parses ISO8601 dates as produced by Elixir's `DateTime`.
nonisolated(unsafe) fileprivate let dateTimeFormatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withFullDate, .withFullTime, .withFractionalSeconds]
    return formatter
}()

/// A formatter that parses ISO8601 dates as produced by Elixir's `Date`.
nonisolated(unsafe) fileprivate let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

public struct ElixirDateFormat: ParseableFormatStyle {
    public func format(_ value: Date) -> String {
        dateFormatter.string(from: value)
    }
    
    public var parseStrategy = ElixirDateParseStrategy()
}

public struct ElixirDateParseStrategy: ParseStrategy {
    public func parse(_ value: String) throws -> Date {
        guard let value = dateFormatter.date(from: value) else {
            throw DateParseError.invalidDate
        }
        return value
    }
}

public struct ElixirDateTimeFormat: ParseableFormatStyle {
    public typealias FormatInput = Date
    
    public typealias FormatOutput = String
    
    public func format(_ value: Date) -> String {
        dateTimeFormatter.string(from: value)
    }
    
    public var parseStrategy = ElixirDateTimeOrDateParseStrategy()
}

public struct ElixirDateTimeOrDateParseStrategy: ParseStrategy {
    public func parse(_ value: String) throws -> Date {
        guard let value = dateTimeFormatter.date(from: value) ?? dateFormatter.date(from: value)
        else { throw DateParseError.invalidDate }
        return value
    }
}

private enum DateParseError: Error {
    case invalidDate
}

public extension FormatStyle where Self == ElixirDateTimeFormat {
    static var elixirDateTime: ElixirDateTimeFormat { .init() }
}

public extension FormatStyle where Self == ElixirDateFormat {
    static var elixirDate: ElixirDateFormat { .init() }
}

public extension ParseStrategy where Self == ElixirDateTimeOrDateParseStrategy {
    static var elixirDateTimeOrDate: ElixirDateTimeOrDateParseStrategy { .init() }
}

public extension ParseStrategy where Self == ElixirDateParseStrategy {
    static var elixirDate: ElixirDateParseStrategy { .init() }
}
