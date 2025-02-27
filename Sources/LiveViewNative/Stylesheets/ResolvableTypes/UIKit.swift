//
//  UIKit.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

#if canImport(UIKit)
import UIKit
import LiveViewNativeStylesheet
import LiveViewNativeCore

#if os(iOS) || os(tvOS) || os(visionOS)
extension UITextContentType {
    @ASTDecodable("UITextContentType")
    enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case namePrefix
        case name
        case nameSuffix
        case givenName
        case middleName
        case familyName
        case nickname
        case organizationName
        case jobTitle
        case location
        case fullStreetAddress
        case streetAddressLine1
        case streetAddressLine2
        case addressCity
        case addressCityAndState
        case addressState
        case postalCode
        case sublocality
        case countryName
        case username
        case password
        case newPassword
        case oneTimeCode
        case emailAddress
        case telephoneNumber
        case cellularEID
        case cellularIMEI
        case creditCardNumber
        case creditCardExpiration
        case creditCardExpirationMonth
        case creditCardExpirationYear
        case creditCardSecurityCode
        case creditCardType
        case creditCardName
        case creditCardGivenName
        case creditCardMiddleName
        case creditCardFamilyName
        case birthdate
        case birthdateDay
        case birthdateMonth
        case birthdateYear
        case dateTime
        case flightNumber
        case shipmentTrackingNumber
    }
}

extension UITextContentType.Resolvable {
    func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> UITextContentType where R : RootRegistry {
        switch self {
        case .namePrefix:
            return .namePrefix
        case .name:
            return .name
        case .nameSuffix:
            return .nameSuffix
        case .givenName:
            return .givenName
        case .middleName:
            return .middleName
        case .familyName:
            return .familyName
        case .nickname:
            return .nickname
        case .organizationName:
            return .organizationName
        case .jobTitle:
            return .jobTitle
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
        case .addressCityAndState:
            return .addressCityAndState
        case .addressState:
            return .addressState
        case .postalCode:
            return .postalCode
        case .sublocality:
            return .sublocality
        case .countryName:
            return .countryName
        case .username:
            return .username
        case .password:
            return .password
        case .newPassword:
            return .newPassword
        case .oneTimeCode:
            return .oneTimeCode
        case .emailAddress:
            return .emailAddress
        case .telephoneNumber:
            return .telephoneNumber
        case .cellularEID:
            if #available(iOS 17.4, tvOS 17.4, *) {
                return .cellularEID
            } else {
                fatalError()
            }
        case .cellularIMEI:
            if #available(iOS 17.4, tvOS 17.4, *) {
                return .cellularIMEI
            } else {
                fatalError()
            }
        case .creditCardNumber:
            if #available(iOS 17, tvOS 17, *) {
                return .creditCardNumber
            } else {
                fatalError()
            }
        case .creditCardExpiration:
            if #available(iOS 17, tvOS 17, *) {
                return .creditCardExpiration
            } else {
                fatalError()
            }
        case .creditCardExpirationMonth:
            if #available(iOS 17, tvOS 17, *) {
                return .creditCardExpirationMonth
            } else {
                fatalError()
            }
        case .creditCardExpirationYear:
            if #available(iOS 17, tvOS 17, *) {
                return .creditCardExpirationYear
            } else {
                fatalError()
            }
        case .creditCardSecurityCode:
            if #available(iOS 17, tvOS 17, *) {
                return .creditCardSecurityCode
            } else {
                fatalError()
            }
        case .creditCardType:
            if #available(iOS 17, tvOS 17, *) {
                return .creditCardType
            } else {
                fatalError()
            }
        case .creditCardName:
            if #available(iOS 17, tvOS 17, *) {
                return .creditCardName
            } else {
                fatalError()
            }
        case .creditCardGivenName:
            if #available(iOS 17, tvOS 17, *) {
                return .creditCardGivenName
            } else {
                fatalError()
            }
        case .creditCardMiddleName:
            if #available(iOS 17, tvOS 17, *) {
                return .creditCardMiddleName
            } else {
                fatalError()
            }
        case .creditCardFamilyName:
            if #available(iOS 17, tvOS 17, *) {
                return .creditCardFamilyName
            } else {
                fatalError()
            }
        case .birthdate:
            if #available(iOS 17, tvOS 17, *) {
                return .birthdate
            } else {
                fatalError()
            }
        case .birthdateDay:
            if #available(iOS 17, tvOS 17, *) {
                return .birthdateDay
            } else {
                fatalError()
            }
        case .birthdateMonth:
            if #available(iOS 17, tvOS 17, *) {
                return .birthdateMonth
            } else {
                fatalError()
            }
        case .birthdateYear:
            if #available(iOS 17, tvOS 17, *) {
                return .birthdateYear
            } else {
                fatalError()
            }
        case .dateTime:
            return .dateTime
        case .flightNumber:
            return .flightNumber
        case .shipmentTrackingNumber:
            return .shipmentTrackingNumber
        }
    }
}

extension UITextContentType.Resolvable: @preconcurrency AttributeDecodable {
    init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "namePrefix":
            self = .namePrefix
        case "name":
            self = .name
        case "nameSuffix":
            self = .nameSuffix
        case "givenName":
            self = .givenName
        case "middleName":
            self = .middleName
        case "familyName":
            self = .familyName
        case "nickname":
            self = .nickname
        case "organizationName":
            self = .organizationName
        case "jobTitle":
            self = .jobTitle
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
        case "addressCityAndState":
            self = .addressCityAndState
        case "addressState":
            self = .addressState
        case "postalCode":
            self = .postalCode
        case "sublocality":
            self = .sublocality
        case "countryName":
            self = .countryName
        case "username":
            self = .username
        case "password":
            self = .password
        case "newPassword":
            self = .newPassword
        case "oneTimeCode":
            self = .oneTimeCode
        case "emailAddress":
            self = .emailAddress
        case "telephoneNumber":
            self = .telephoneNumber
        case "cellularEID":
            self = .cellularEID
        case "cellularIMEI":
            self = .cellularIMEI
        case "creditCardNumber":
            self = .creditCardNumber
        case "creditCardExpiration":
            self = .creditCardExpiration
        case "creditCardExpirationMonth":
            self = .creditCardExpirationMonth
        case "creditCardExpirationYear":
            self = .creditCardExpirationYear
        case "creditCardSecurityCode":
            self = .creditCardSecurityCode
        case "creditCardType":
            self = .creditCardType
        case "creditCardName":
            self = .creditCardName
        case "creditCardGivenName":
            self = .creditCardGivenName
        case "creditCardMiddleName":
            self = .creditCardMiddleName
        case "creditCardFamilyName":
            self = .creditCardFamilyName
        case "birthdate":
            self = .birthdate
        case "birthdateDay":
            self = .birthdateDay
        case "birthdateMonth":
            self = .birthdateMonth
        case "birthdateYear":
            self = .birthdateYear
        case "dateTime":
            self = .dateTime
        case "flightNumber":
            self = .flightNumber
        case "shipmentTrackingNumber":
            self = .shipmentTrackingNumber
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
#endif

#if os(iOS) || os(tvOS) || os(visionOS)
extension UIKeyboardType {
    @ASTDecodable("UIKeyboardType")
    enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case `default`
        case asciiCapable
        case numbersAndPunctuation
        case URL
        case numberPad
        case phonePad
        case namePhonePad
        case emailAddress
        case decimalPad
        case twitter
        case webSearch
        case asciiCapableNumberPad
    }
}

extension UIKeyboardType.Resolvable {
    func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> UIKeyboardType where R : RootRegistry {
        switch self {
        case .default:
            return .default
        case .asciiCapable:
            return .asciiCapable
        case .numbersAndPunctuation:
            return .numbersAndPunctuation
        case .URL:
            return .URL
        case .numberPad:
            return .numberPad
        case .phonePad:
            return .phonePad
        case .namePhonePad:
            return .namePhonePad
        case .emailAddress:
            return .emailAddress
        case .decimalPad:
            return .decimalPad
        case .twitter:
            return .twitter
        case .webSearch:
            return .webSearch
        case .asciiCapableNumberPad:
            return .asciiCapableNumberPad
        }
    }
}

extension UIKeyboardType: @preconcurrency AttributeDecodable {
    public init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "default":
            self = .default
        case "asciiCapable":
            self = .asciiCapable
        case "numbersAndPunctuation":
            self = .numbersAndPunctuation
        case "URL":
            self = .URL
        case "numberPad":
            self = .numberPad
        case "phonePad":
            self = .phonePad
        case "namePhonePad":
            self = .namePhonePad
        case "emailAddress":
            self = .emailAddress
        case "decimalPad":
            self = .decimalPad
        case "twitter":
            self = .twitter
        case "webSearch":
            self = .webSearch
        case "asciiCapableNumberPad":
            self = .asciiCapableNumberPad
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
#endif

#endif
