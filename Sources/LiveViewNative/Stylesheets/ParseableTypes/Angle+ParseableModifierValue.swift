//
//  Angle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

extension Angle: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                Radians.parser(in: context).map({ Self.radians($0.radians) })
                Degrees.parser(in: context).map({ Self.degrees($0.degrees) })
            }
        }
    }
    
    @ParseableExpression
    struct Radians {
        static let name = "radians"
        
        let radians: Double
        
        init(_ radians: Double) {
            self.radians = radians
        }
    }
    
    @ParseableExpression
    struct Degrees {
        static let name = "degrees"
        
        let degrees: Double
        
        init(_ degrees: Double) {
            self.degrees = degrees
        }
    }
}
