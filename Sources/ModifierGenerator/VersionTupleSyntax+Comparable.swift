import SwiftSyntax

extension VersionTupleSyntax: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        guard let lhsMajor = Int(lhs.major.text),
              let rhsMajor = Int(rhs.major.text)
        else { return false }
        let lhsMinor = lhs.components.compactMap({ Int($0.number.text) })
        let rhsMinor = rhs.components.compactMap({ Int($0.number.text) })
        return lhsMajor < rhsMajor || (lhsMajor == rhsMajor && zip(lhsMinor, rhsMinor).allSatisfy({ $0 < $1 }))
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        guard let lhsMajor = Int(lhs.major.text),
              let rhsMajor = Int(rhs.major.text)
        else { return false }
        let lhsMinor = lhs.components.compactMap({ Int($0.number.text) })
        let rhsMinor = rhs.components.compactMap({ Int($0.number.text) })
        return lhsMajor == rhsMajor && lhsMinor == rhsMinor
    }
}