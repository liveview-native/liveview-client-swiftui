//
//  DateParsing.swift
//  
//
//  Created by Carson Katri on 1/17/23.
//

import Foundation

/// A formatter that parses ISO8601 dates as produced by Elixir's `DateTime`.
fileprivate let dateTimeFormatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withFullDate, .withFullTime, .withFractionalSeconds]
    return formatter
}()

/// A formatter that parses ISO8601 dates as produced by Elixir's `Date`.
fileprivate let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

struct ElixirDateTimeFormat: ParseableFormatStyle {
    typealias FormatInput = Date
    
    typealias FormatOutput = String
    
    func format(_ value: Date) -> String {
        dateTimeFormatter.string(from: value)
    }
    
    var parseStrategy = ElixirDateTimeOrDateParseStrategy()
}

struct ElixirDateTimeOrDateParseStrategy: ParseStrategy {
    func parse(_ value: String) throws -> Date {
        guard let value = dateTimeFormatter.date(from: value) ?? dateFormatter.date(from: value)
        else { throw DateParseError.invalidDate }
        return value
    }
    
    enum DateParseError: Error {
        case invalidDate
    }
}

extension FormatStyle where Self == ElixirDateTimeFormat {
    static var elixirDateTime: ElixirDateTimeFormat { .init() }
}

extension ParseStrategy where Self == ElixirDateTimeOrDateParseStrategy {
    static var elixirDateTimeOrDate: ElixirDateTimeOrDateParseStrategy { .init() }
}
