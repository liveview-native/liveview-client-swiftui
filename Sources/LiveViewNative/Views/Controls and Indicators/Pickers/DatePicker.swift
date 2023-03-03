//
//  DatePicker.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/17/23.
//

#if os(iOS) || os(macOS)
import SwiftUI

struct DatePicker<R: RootRegistry>: View {
    private let context: LiveContext<R>
    @ObservedElement private var element
    @FormState(default: CodableDate()) private var value: CodableDate
    @Attribute("start") private var start: Date?
    @Attribute("end") private var end: Date?
    @Attribute(
        "displayed-components",
        transform: {
            switch $0?.value {
            case "hour-and-minute":
                return .hourAndMinute
            case "date":
                return .date
            default:
                return [.hourAndMinute, .date]
            }
        }
    ) private var components: DatePickerComponents
    @Attribute("date-picker-style") private var style: DatePickerStyle = .automatic
    
    private var dateBinding: Binding<Date> {
        Binding {
            value.date
        } set: { newValue in
            value.date = newValue
        }
    }
    
    init(context: LiveContext<R>) {
        self.context = context
    }
    
    var body: some View {
        if let start, let end {
            SwiftUI.DatePicker(selection: dateBinding, in: start...end, displayedComponents: components) {
                context.buildChildren(of: element)
            }
            .applyDatePickerStyle(style)
        } else if let start {
            SwiftUI.DatePicker(selection: dateBinding, in: start..., displayedComponents: components) {
                context.buildChildren(of: element)
            }
            .applyDatePickerStyle(style)
        } else if let end {
            SwiftUI.DatePicker(selection: dateBinding, in: ...end, displayedComponents: components) {
                context.buildChildren(of: element)
            }
            .applyDatePickerStyle(style)
        } else {
            SwiftUI.DatePicker(selection: dateBinding, displayedComponents: components) {
                context.buildChildren(of: element)
            }
            .applyDatePickerStyle(style)
        }
    }
}

/// A `Date` wrapper that encodes/decodes using the Elixir date formats.
private struct CodableDate: FormValue {
    var date: Date
    
    var formValue: String {
        date.formatted(.iso8601)
    }
    
    init() {
        self.date = Date()
    }
    
    init?(formValue: String) {
        if let date = try? Date(formValue, strategy: .elixirDateTimeOrDate) {
            self.date = date
        } else {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let s = try container.decode(String.self)
        self.date = try Date(s, strategy: .elixirDateTimeOrDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(date.formatted(.elixirDateTime))
    }
}

private enum DatePickerStyle: String, AttributeDecodable {
    case automatic
    case compact
    case graphical
#if os(iOS)
    case wheel
#endif
#if os(macOS)
    case field
    case stepperField = "stepper-field"
#endif
}

private extension View {
    @ViewBuilder
    func applyDatePickerStyle(_ style: DatePickerStyle?) -> some View {
        switch style {
        case .automatic, nil:
            self.datePickerStyle(.automatic)
        case .compact:
            self.datePickerStyle(.compact)
        case .graphical:
            self.datePickerStyle(.graphical)
#if os(iOS)
        case .wheel:
            self.datePickerStyle(.wheel)
#endif
#if os(macOS)
        case .field:
            self.datePickerStyle(.field)
        case .stepperField:
            self.datePickerStyle(.stepperField)
#endif
        }
    }
}
#endif
