//
//  TextField.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct TextField<R: CustomRegistry>: TextFieldProtocol {
    @ObservedElement var element: ElementNode
    let context: LiveContext<R>
    @FormState var value: String?
    @FocusState private var isFocused: Bool
    
    init(element: ElementNode, context: LiveContext<R>) {
        self.context = context
    }
    
    var body: some View {
        field
            .focused($isFocused)
            .phxTextFieldStyle(textFieldStyle)
            .phxAutocorrectionDisabled(disableAutocorrection)
            .textInputAutocapitalization(autocapitalization)
            .phxKeyboardType(keyboard)
            .phxSubmitLabel(submitLabel)
            .onChange(of: isFocused, perform: handleFocus)
    }
    
    @ViewBuilder
    private var field: some View {
        if let format = element.attributeValue(for: "format") {
            switch format {
            case "date-time":
                SwiftUI.TextField(
                    self.placeholder ?? "",
                    value: valueBinding(format: .dateTime),
                    format: .dateTime,
                    prompt: prompt
                )
            case "url":
                SwiftUI.TextField(
                    self.placeholder ?? "",
                    value: valueBinding(format: .url),
                    format: .url,
                    prompt: prompt
                )
            case "iso8601":
                SwiftUI.TextField(
                    self.placeholder ?? "",
                    value: valueBinding(format: .iso8601),
                    format: .iso8601,
                    prompt: prompt
                )
            case "number":
                SwiftUI.TextField(
                    self.placeholder ?? "",
                    value: valueBinding(format: .number),
                    format: .number,
                    prompt: prompt
                )
            case "percent":
                SwiftUI.TextField(
                    self.placeholder ?? "",
                    value: valueBinding(format: .percent),
                    format: .percent,
                    prompt: prompt
                )
            case let format:
                if format.starts(with: "currency-"),
                   let code = format.split(separator: "currency-").last.map(String.init)
                {
                    SwiftUI.TextField(
                        self.placeholder ?? "",
                        value: valueBinding(format: .currency(code: code)),
                        format: .currency(code: code),
                        prompt: prompt
                    )
                } else if format.starts(with: "name-"),
                          let style = format.split(separator: "name-").last
                {
                    let nameStyle: PersonNameComponents.FormatStyle.Style = {
                        switch style {
                        case "short":
                            return .short
                        case "medium":
                            return .medium
                        case "long":
                            return .long
                        case "abbreviated":
                            return .abbreviated
                        default:
                            return .medium
                        }
                    }()
                    SwiftUI.TextField(
                        self.placeholder ?? "",
                        value: valueBinding(format: .name(style: nameStyle)),
                        format: .name(style: nameStyle),
                        prompt: prompt
                    )
                } else {
                    SwiftUI.TextField(
                        self.placeholder ?? "",
                        text: textBinding,
                        prompt: prompt,
                        axis: axis
                    )
                }
            }
        } else {
            SwiftUI.TextField(
                self.placeholder ?? "",
                text: textBinding,
                prompt: prompt,
                axis: axis
            )
        }
    }
}
