//
//  TextField.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

/// A form element for entering text.
///
/// Any children of the field will be used as the label.
///
/// ```html
/// <TextField value-binding="first_name">
///     First Name
/// </TextField>
/// ```
///
/// You can style the label by using elements inside.
///
/// ```html
/// <TextField value-binding="last_name">
///     <Text font-weight="bold" font="caption">Last Name</Text>
/// </TextField>
/// ```
///
/// ### Formatting Values
/// Use the ``format`` attribute to input values such as numbers and URLs.
///
/// ```html
/// <VStack>
///     <TextField
///         value-binding="amount"
///         format="currency"
///         currency-code="usd"
///     >
///         Enter Amount
///     </TextField>
///
///     <TextField
///         value-binding="bank_address"
///         axis="vertical"
///     >
///         Enter Bank Address
///     </TextField>
/// </VStack>
/// ```
///
/// ### Secure Input
/// To input private text, such as a password, use ``SecureField``.
///
/// ## Attributes
/// * ``format``
/// * ``currencyCode``
/// * ``nameStyle``
/// * ``TextFieldProtocol/axis``
/// * ``TextFieldProtocol/prompt``
///
/// ## Events
/// * ``focusEvent``
/// * ``blurEvent``
///
/// ## See Also
/// * [LiveView Native Live Form](https://github.com/liveview-native/liveview-native-live-form)
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct TextField<R: RootRegistry>: TextFieldProtocol {
    @ObservedElement var element: ElementNode
    @LiveContext<R> var context
    @FormState var value: String?
    @FocusState private var isFocused: Bool
    
    @Event("phx-focus", type: "focus") var focusEvent
    @Event("phx-blur", type: "blur") var blurEvent
    @Attribute("format") private var format: String?
    @Attribute("currency-code") private var currencyCode: String?
    @Attribute(
        "name-style",
        transform: {
            switch $0?.value {
            case "short":
                return .short
            case "medium":
                return .medium
            case "long":
                return .long
            case "abbreviated":
                return .abbreviated
            default:
                return nil
            }
        }
    ) private var nameStyle: PersonNameComponents.FormatStyle.Style?
    
    var body: some View {
        field
            .focused($isFocused)
            .onChange(of: isFocused, perform: handleFocus)
            .preference(key: ProvidedBindingsKey.self, value: ["phx-focus", "phx-blur"])
    }
    
    @ViewBuilder
    private var field: some View {
        if let format {
            switch format {
            case "date-time":
                SwiftUI.TextField(
                    value: valueBinding(format: .dateTime),
                    format: .dateTime,
                    prompt: prompt
                ) {
                    label
                }
            case "url":
                SwiftUI.TextField(
                    value: valueBinding(format: .url),
                    format: .url,
                    prompt: prompt
                ) {
                    label
                }
            case "iso8601":
                SwiftUI.TextField(
                    value: valueBinding(format: .iso8601),
                    format: .iso8601,
                    prompt: prompt
                ) {
                    label
                }
            case "number":
                SwiftUI.TextField(
                    value: valueBinding(format: .number),
                    format: .number,
                    prompt: prompt
                ) {
                    label
                }
            case "percent":
                SwiftUI.TextField(
                    value: valueBinding(format: .percent),
                    format: .percent,
                    prompt: prompt
                ) {
                    label
                }
            case "currency":
                if let currencyCode {
                    SwiftUI.TextField(
                        value: valueBinding(format: .currency(code: currencyCode)),
                        format: .currency(code: currencyCode),
                        prompt: prompt
                    ) {
                        label
                    }
                } else {
                    SwiftUI.TextField(
                        text: textBinding,
                        prompt: prompt,
                        axis: axis
                    ) {
                        label
                    }
                }
            case "name":
                if let nameStyle {
                    SwiftUI.TextField(
                        value: valueBinding(format: .name(style: nameStyle)),
                        format: .name(style: nameStyle),
                        prompt: prompt
                    ) {
                        label
                    }
                } else {
                    SwiftUI.TextField(
                        text: textBinding,
                        prompt: prompt,
                        axis: axis
                    ) {
                        label
                    }
                }
            default:
                SwiftUI.TextField(
                    text: textBinding,
                    prompt: prompt,
                    axis: axis
                ) {
                    label
                }
            }
        } else {
            SwiftUI.TextField(
                text: textBinding,
                prompt: prompt,
                axis: axis
            ) {
                label
            }
        }
    }
    
    var label: some View {
        context.buildChildren(of: element)
    }
}
