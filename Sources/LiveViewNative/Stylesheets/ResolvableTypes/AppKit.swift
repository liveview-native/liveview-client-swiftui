//
//  AppKit.swift
//  LiveViewNative
//
//  Created by Carson Katri on 2/26/25.
//

#if os(macOS)
import AppKit
import LiveViewNativeCore
import LiveViewNativeStylesheet

extension NSTextContentType {
    @ASTDecodable("NSTextContentType")
    enum Resolvable: StylesheetResolvable, @preconcurrency Decodable, @preconcurrency AttributeDecodable {
        case username
        case password
        case oneTimeCode
        case newPassword
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
        case creditCardName
        case creditCardGivenName
        case creditCardMiddleName
        case creditCardFamilyName
        case creditCardSecurityCode
        case creditCardExpiration
        case creditCardExpirationMonth
        case creditCardExpirationYear
        case creditCardType
        case shipmentTrackingNumber
        case flightNumber
        case dateTime
        case birthdate
        case birthdateDay
        case birthdateMonth
        case birthdateYear
    }
}

extension NSTextContentType.Resolvable {
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> NSTextContentType {
        switch self {
        case .username:
            return .username
        case .password:
            return .password
        case .oneTimeCode:
            return .oneTimeCode
        default:
            if #available(macOS 14.0, *) {
                switch self {
                case .newPassword:
                    return .newPassword
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
                case .creditCardName:
                    return .creditCardName
                case .creditCardGivenName:
                    return .creditCardGivenName
                case .creditCardMiddleName:
                    return .creditCardMiddleName
                case .creditCardFamilyName:
                    return .creditCardFamilyName
                case .creditCardSecurityCode:
                    return .creditCardSecurityCode
                case .creditCardExpiration:
                    return .creditCardExpiration
                case .creditCardExpirationMonth:
                    return .creditCardExpirationMonth
                case .creditCardExpirationYear:
                    return .creditCardExpirationYear
                case .creditCardType:
                    return .creditCardType
                case .shipmentTrackingNumber:
                    return .shipmentTrackingNumber
                case .flightNumber:
                    return .flightNumber
                case .dateTime:
                    return .dateTime
                case .birthdate:
                    return .birthdate
                case .birthdateDay:
                    return .birthdateDay
                case .birthdateMonth:
                    return .birthdateMonth
                case .birthdateYear:
                    return .birthdateYear
                default:
                    fatalError()
                }
            } else {
                fatalError("'\(self)' is not supported in this version of macOS")
            }
        }
    }
    
    init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "username":
            self = .username
        case "password":
            self = .password
        case "oneTimeCode":
            self = .oneTimeCode
        default:
            if #available(macOS 14, *) {
                switch attribute?.value {
                case "newPassword":
                    self = .newPassword
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
                case "creditCardName":
                    self = .creditCardName
                case "creditCardGivenName":
                    self = .creditCardGivenName
                case "creditCardMiddleName":
                    self = .creditCardMiddleName
                case "creditCardFamilyName":
                    self = .creditCardFamilyName
                case "creditCardSecurityCode":
                    self = .creditCardSecurityCode
                case "creditCardExpiration":
                    self = .creditCardExpiration
                case "creditCardExpirationMonth":
                    self = .creditCardExpirationMonth
                case "creditCardExpirationYear":
                    self = .creditCardExpirationYear
                case "creditCardType":
                    self = .creditCardType
                case "shipmentTrackingNumber":
                    self = .shipmentTrackingNumber
                case "flightNumber":
                    self = .flightNumber
                case "dateTime":
                    self = .dateTime
                case "birthdate":
                    self = .birthdate
                case "birthdateDay":
                    self = .birthdateDay
                case "birthdateMonth":
                    self = .birthdateMonth
                case "birthdateYear":
                    self = .birthdateYear
                default:
                    throw AttributeDecodingError.badValue(Self.self)
                }
            } else {
                throw AttributeDecodingError.badValue(Self.self)
            }
        }
    }
}
#endif
