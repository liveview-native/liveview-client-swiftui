//
//  UITextContentType+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

#if os(iOS) || os(tvOS) || os(visionOS)
/// See [`UIKit.UITextContentType`](https://developer.apple.com/documentation/uikit/UITextContentType) for more details.
///
/// Possible values:
/// - `name`
/// - `namePrefix`
/// - `givenName`
/// - `middleName`
/// - `familyName`
/// - `nameSuffix`
/// - `nickname`
/// - `jobTitle`
/// - `organizationName`
/// - `location`
/// - `fullStreetAddress`
/// - `streetAddressLine1`
/// - `streetAddressLine2`
/// - `addressCity`
/// - `addressState`
/// - `addressCityAndState`
/// - `sublocality`
/// - `countryName`
/// - `postalCode`
/// - `telephoneNumber`
/// - `emailAddress`
/// - `URL`
/// - `creditCardNumber`
/// - `username`
/// - `password`
/// - `newPassword`
/// - `oneTimeCode`
@_documentation(visibility: public)
@available(iOS 13.0, tvOS 13.0, visionOS 1, *)
extension UITextContentType: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "name": .name,
            "namePrefix": .namePrefix,
            "givenName": .givenName,
            "middleName": .middleName,
            "familyName": .familyName,
            "nameSuffix": .nameSuffix,
            "nickname": .nickname,
            "jobTitle": .jobTitle,
            "organizationName": .organizationName,
            "location": .location,
            "fullStreetAddress": .fullStreetAddress,
            "streetAddressLine1": .streetAddressLine1,
            "streetAddressLine2": .streetAddressLine2,
            "addressCity": .addressCity,
            "addressState": .addressState,
            "addressCityAndState": .addressCityAndState,
            "sublocality": .sublocality,
            "countryName": .countryName,
            "postalCode": .postalCode,
            "telephoneNumber": .telephoneNumber,
            "emailAddress": .emailAddress,
            "URL": .URL,
            "creditCardNumber": .creditCardNumber,
            "username": .username,
            "password": .password,
            "newPassword": .newPassword,
            "oneTimeCode": .oneTimeCode,
        ])
    }
}
#endif
