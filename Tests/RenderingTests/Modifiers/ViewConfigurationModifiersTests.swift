//
//  ViewConfigurationModifiersTests.swift
//  
//
//  Created by murtza on 16/05/2023.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class ViewConfigurationModifiersTests: XCTestCase {
    func testViewRedactedModifier() throws {
        try assertMatch(
            #"""
            <VStack modifiers=[{&quot;reason&quot;:&quot;placeholder&quot;,&quot;type&quot;:&quot;redacted&quot;}]>
               <Text>Title</Text>
               <Text>Sub Title</Text>
            </VStack>
            """#
        ) {
            VStack(){
                Text("Title")
                Text("Sub Title")
            }.redacted(reason: .placeholder)
        }
    }
}
