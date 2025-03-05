//
//  WatchKit.swift
//  LiveViewNative
//
//  Created by Carson Katri on 2/26/25.
//

#if canImport(WatchKit)
import WatchKit
import LiveViewNativeStylesheet
import LiveViewNativeCore

extension WKTextContentType {
    @ASTDecodable("WKTextContentType")
    public enum Resolvable: StylesheetResolvable, @preconcurrency Decodable, @preconcurrency AttributeDecodable {
        case name
        case namePrefix
        case givenName
        case middleName
        case familyName
        case nameSuffix
        case nickname
        case jobTitle
        case organizationName
        case location
        case fullStreetAddress
        case streetAddressLine1
        case streetAddressLine2
        case addressCity
        case addressState
        case addressCityAndState
        case sublocality
        case countryName
        case postalCode
        case telephoneNumber
        case emailAddress
        case URL
        case creditCardNumber
        case username
        case password
        case newPassword
        case oneTimeCode
    }
}

public extension WKTextContentType.Resolvable {
    func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> WKTextContentType where R : RootRegistry {
        switch self {
        case .name:
            return .name
        case .namePrefix:
            return .namePrefix
        case .givenName:
            return .givenName
        case .middleName:
            return .middleName
        case .familyName:
            return .familyName
        case .nameSuffix:
            return .nameSuffix
        case .nickname:
            return .nickname
        case .jobTitle:
            return .jobTitle
        case .organizationName:
            return .organizationName
        case .location:
            return .location
        case .fullStreetAddress:
            return .fullStreetAddress
        case .streetAddressLine1:
            return .streetAddressLine1
        case .streetAddressLine2:
            return .streetAddressLine2
        case .addressCity:
            return .addressCity
        case .addressState:
            return .addressState
        case .addressCityAndState:
            return .addressCityAndState
        case .sublocality:
            return .sublocality
        case .countryName:
            return .countryName
        case .postalCode:
            return .postalCode
        case .telephoneNumber:
            return .telephoneNumber
        case .emailAddress:
            return .emailAddress
        case .URL:
            return .URL
        case .creditCardNumber:
            return .creditCardNumber
        case .username:
            return .username
        case .password:
            return .password
        case .newPassword:
            return .newPassword
        case .oneTimeCode:
            return .oneTimeCode
        }
    }
    
    init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "name":
            self = .name
        case "namePrefix":
            self = .namePrefix
        case "givenName":
            self = .givenName
        case "middleName":
            self = .middleName
        case "familyName":
            self = .familyName
        case "nameSuffix":
            self = .nameSuffix
        case "nickname":
            self = .nickname
        case "jobTitle":
            self = .jobTitle
        case "organizationName":
            self = .organizationName
        case "location":
            self = .location
        case "fullStreetAddress":
            self = .fullStreetAddress
        case "streetAddressLine1":
            self = .streetAddressLine1
        case "streetAddressLine2":
            self = .streetAddressLine2
        case "addressCity":
            self = .addressCity
        case "addressState":
            self = .addressState
        case "addressCityAndState":
            self = .addressCityAndState
        case "sublocality":
            self = .sublocality
        case "countryName":
            self = .countryName
        case "postalCode":
            self = .postalCode
        case "telephoneNumber":
            self = .telephoneNumber
        case "emailAddress":
            self = .emailAddress
        case "URL":
            self = .URL
        case "creditCardNumber":
            self = .creditCardNumber
        case "username":
            self = .username
        case "password":
            self = .password
        case "newPassword":
            self = .newPassword
        case "oneTimeCode":
            self = .oneTimeCode
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
#endif
