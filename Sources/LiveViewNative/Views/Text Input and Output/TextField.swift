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
/// <TextField text="first_name">
///     First Name
/// </TextField>
/// ```
///
/// You can style the label by using elements inside.
///
/// ```html
/// <TextField text="last_name">
///     <Text fontWeight="bold" font="caption">Last Name</Text>
/// </TextField>
/// ```
///
/// ### Input Configuration
/// Use modifiers to configure how text is input.
///
/// ```elixir
/// "search-field" do
///   autocorrectDisabled(true)
///   textInputAutocapitalization(.words)
///   keyboardType(.webSearch)
///   submitLabel(.search)
/// end
/// ```
///
/// ```html
/// <TextField
///     text="value"
///     class="search-field"
/// >
///     Enter Search Text
/// </TextField>
/// ```
///
/// ### Formatting Values
/// Use the ``format`` attribute to input values such as numbers and URLs.
///
/// ```html
/// <VStack>
///     <TextField
///         text="amount"
///         format="currency"
///         currencyCode="usd"
///         class="decimal-pad"
///     >
///         Enter Amount
///     </TextField>
///
///     <TextField
///         text="bank_address"
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
/// * ``text``
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
@_documentation(visibility: public)
@LiveElement
struct TextField<Root: RootRegistry>: TextFieldProtocol {
    @FormState("text", default: "") var text: String?
    
    @LiveElementIgnored
    @FocusState private var isFocused: Bool
    
    @_documentation(visibility: public)
    @Event(.init(name: "phx-focus"), type: "focus") var focusEvent
    
    @_documentation(visibility: public)
    @Event(.init(name: "phx-blur"), type: "blur") var blurEvent
    
    /// The axis to scroll when the content doesn't fit.
    ///
    /// Possible values:
    /// * `horizontal`
    /// * `vertical`
    var axis: Axis = .horizontal
    
    /// Additional guidance on what to enter.
    var prompt: String?

    /// Possible values:
    /// * `date-time`
    /// * `url`
    /// * `iso8601`
    /// * `number`
    /// * `percent`
    /// * `currency`
    /// * `name`
    @_documentation(visibility: public)
    private var format: String?
    
    /// The currency code for the locale.
    ///
    /// Example currency codes include `USD`, `EUR`, and `JPY`.
    @_documentation(visibility: public)
    private var currencyCode: String?
    
    /// A type used to format a person’s name with a style appropriate for the given locale.
    /// 
    /// Possible values:
    /// * `short`
    /// * `medium`
    /// * `long`
    /// * `abbreviated`
    @_documentation(visibility: public)
    private var nameStyle: PersonNameComponents.FormatStyle.Style?
    
    var body: some View {
        field
            .focused($isFocused)
            .onChange(of: isFocused, perform: handleFocus)
            .preference(key: _ProvidedBindingsKey.self, value: ["phx-focus", "phx-blur"])
    }
    
    @MainActor
    func handleFocus(_ isFocused: Bool) {
        if isFocused {
            focusEvent(value:
                $liveElement.element.buildPhxValuePayload()
                    .merging(["value": textBinding.wrappedValue], uniquingKeysWith: { a, _ in a })
            )
        } else {
            blurEvent(value:
                $liveElement.element.buildPhxValuePayload()
                    .merging(["value": textBinding.wrappedValue], uniquingKeysWith: { a, _ in a })
            )
        }
    }
    
    @ViewBuilder
    private var field: some View {
        if let format {
            switch format {
            case "dateTime":
                SwiftUI.TextField(
                    value: valueBinding(format: .dateTime),
                    format: .dateTime,
                    prompt: prompt.flatMap(SwiftUI.Text.init)
                ) {
                    label
                }
            case "url":
                SwiftUI.TextField(
                    value: valueBinding(format: .url),
                    format: .url,
                    prompt: prompt.flatMap(SwiftUI.Text.init)
                ) {
                    label
                }
            case "iso8601":
                SwiftUI.TextField(
                    value: valueBinding(format: .iso8601),
                    format: .iso8601,
                    prompt: prompt.flatMap(SwiftUI.Text.init)
                ) {
                    label
                }
            case "number":
                SwiftUI.TextField(
                    value: valueBinding(format: .number),
                    format: .number,
                    prompt: prompt.flatMap(SwiftUI.Text.init)
                ) {
                    label
                }
            case "percent":
                SwiftUI.TextField(
                    value: valueBinding(format: .percent),
                    format: .percent,
                    prompt: prompt.flatMap(SwiftUI.Text.init)
                ) {
                    label
                }
            case "currency":
                if let currencyCode {
                    SwiftUI.TextField(
                        value: valueBinding(format: .currency(code: currencyCode)),
                        format: .currency(code: currencyCode),
                        prompt: prompt.flatMap(SwiftUI.Text.init)
                    ) {
                        label
                    }
                } else {
                    SwiftUI.TextField(
                        text: textBinding,
                        prompt: prompt.flatMap(SwiftUI.Text.init),
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
                        prompt: prompt.flatMap(SwiftUI.Text.init)
                    ) {
                        label
                    }
                } else {
                    SwiftUI.TextField(
                        text: textBinding,
                        prompt: prompt.flatMap(SwiftUI.Text.init),
                        axis: axis
                    ) {
                        label
                    }
                }
            default:
                SwiftUI.TextField(
                    text: textBinding,
                    prompt: prompt.flatMap(SwiftUI.Text.init),
                    axis: axis
                ) {
                    label
                }
            }
        } else {
            SwiftUI.TextField(
                text: textBinding,
                prompt: prompt.flatMap(SwiftUI.Text.init),
                axis: axis
            ) {
                label
            }
        }
    }
    
    var label: some View {
        $liveElement.children()
    }
}
