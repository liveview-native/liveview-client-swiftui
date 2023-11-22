//
//  UITextContentType+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

#if os(iOS) || os(tvOS)
@available(iOS 13.0, tvOS 13.0, *)
extension UITextContentType: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "name": .name,
            "namePrefix": .namePrefix,
            "givenName": .givenName,
            "MmddleName": .middleName,
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
