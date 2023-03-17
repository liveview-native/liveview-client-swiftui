//
//  MultiDatePicker.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 3/8/23.
//

#if os(iOS)
import SwiftUI

struct MultiDatePicker<R: RootRegistry>: View {
    @LiveContext<R> private var context
    @ObservedElement private var element
    @Attribute("start") private var start: Date?
    @Attribute("end") private var end: Date?
    @LiveBinding(attribute: "value-binding") private var dates: Set<SelectedDate> = []
    
    private var dateComponents: Binding<Set<DateComponents>> {
        Binding {
            Set(self.dates.map(\.dateComponents))
        } set: {
            self.dates = Set($0.map(SelectedDate.init(dateComponents:)))
        }
    }
    
    var body: some View {
        if let start, let end {
            SwiftUI.MultiDatePicker(selection: dateComponents, in: start..<end) {
                context.buildChildren(of: element)
            }
        } else if let start {
            SwiftUI.MultiDatePicker(selection: dateComponents, in: start...) {
                context.buildChildren(of: element)
            }
        } else if let end {
            SwiftUI.MultiDatePicker(selection: dateComponents, in: ..<end) {
                context.buildChildren(of: element)
            }
        } else {
            SwiftUI.MultiDatePicker(selection: dateComponents) {
                context.buildChildren(of: element)
            }
        }
    }
    
    struct SelectedDate: Codable, Equatable, Hashable {
        let dateComponents: DateComponents
        
        init(dateComponents: DateComponents) {
            self.dateComponents = dateComponents
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            let date = try Date(string, strategy: .elixirDate)
            self.dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            let date = dateComponents.date!
            try container.encode(date.formatted(.elixirDate))
        }
    }
}
#endif
