//
//  TextContentTypeModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/21/23.
//

import SwiftUI

/// Sets the text content type for this view, which the system uses to offer suggestions while the user enters text.
///
/// See ``TextContentType`` for a list of possible values.
///
/// ```html
/// <VStack modifiers={padding(50) |> text_field_style(:rounded_border)}>
///     <TextField modifiers={text_content_type(:name)}>
///         Name
///     </TextField>
///     <TextField modifiers={text_content_type(:email_address)}>
///         Email
///     </TextField>
/// </VStack>
/// ```
///
/// ## Arguments
/// * ``textContentType``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct TextContentTypeModifier: ViewModifier, Decodable {
    /// One of the content types available in the ``TextContentType`` enum that identify the semantic meaning expected for a text-entry area.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let textContentType: TextContentType?

    func body(content: Content) -> some View {
        switch textContentType {
        #if !os(macOS)
        case .url:
            content.textContentType(.URL)
        case .name_prefix:
            content.textContentType(.namePrefix)
        case .name:
            content.textContentType(.name)
        case .name_suffix:
            content.textContentType(.nameSuffix)
        case .given_name:
            content.textContentType(.givenName)
        case .middle_name:
            content.textContentType(.middleName)
        case .family_name:
            content.textContentType(.familyName)
        case .nickname:
            content.textContentType(.nickname)
        case .organization_name:
            content.textContentType(.organizationName)
        case .job_title:
            content.textContentType(.jobTitle)
        case .location:
            content.textContentType(.location)
        case .full_street_address:
            content.textContentType(.fullStreetAddress)
        case .street_address_line_1:
            content.textContentType(.streetAddressLine1)
        case .street_address_line_2:
            content.textContentType(.streetAddressLine2)
        case .address_city:
            content.textContentType(.addressCity)
        case .address_city_and_state:
            content.textContentType(.addressCityAndState)
        case .address_state:
            content.textContentType(.addressState)
        case .postal_code:
            content.textContentType(.postalCode)
        case .sublocality:
            content.textContentType(.sublocality)
        case .country_name:
            content.textContentType(.countryName)
        case .new_password:
            content.textContentType(.newPassword)
        case .email_address:
            content.textContentType(.emailAddress)
        case .telephone_number:
            content.textContentType(.telephoneNumber)
        case .credit_card_number:
            content.textContentType(.creditCardNumber)
        #elseif os(iOS) || os(tvOS)
        case .date_time:
            content.textContentType(.dateTime)
        case .flight_number:
            content.textContentType(.flightNumber)
        case .shipment_tracking_number:
            content.textContentType(.shipmentTrackingNumber)
        #endif
        case .username:
            content.textContentType(.username)
        case .password:
            content.textContentType(.password)
        case .one_time_code:
            content.textContentType(.oneTimeCode)
        case .none:
            content.textContentType(nil)
        default:
            content
        }
    }
}

/// A content type to use with ``TextContentTypeModifier``.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
private enum TextContentType: String, Decodable {
#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case url

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case name_prefix

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case name

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case name_suffix

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case given_name

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case middle_name

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case family_name

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case nickname

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case organization_name

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case job_title

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case location

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case full_street_address

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case street_address_line_1

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case street_address_line_2

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case address_city

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case address_city_and_state

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case address_state

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case postal_code

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case sublocality

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case country_name

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case new_password

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case email_address

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case telephone_number

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, watchOS 9.0, *)
    case credit_card_number

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, *)
    case date_time

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, *)
    case flight_number

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    @available(iOS 16.0, *)
    case shipment_tracking_number

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    case username
    
#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    case password

#if swift(>=5.8)
    @_documentation(visibility: public)
#endif
    case one_time_code
}
