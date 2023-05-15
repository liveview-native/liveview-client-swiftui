//
//  DrawingAndGraphicsModifiersTests.swift
//  
//
//  Created by Carson Katri on 5/3/23.
//

import XCTest
import SwiftUI
import LiveViewNative

@MainActor
final class DrawingAndGraphicsModifiersTests: XCTestCase {
    func testRotationEffect() throws {
        try assertMatch(
            #"""
            <Rectangle fill-color="system-red" modifiers="[{&quot;anchor&quot;:null,&quot;angle&quot;:0.7853981633974483,&quot;type&quot;:&quot;rotation_effect&quot;}]" />
            """#,
            size: .init(width: 100, height: 100)
        ) {
            Rectangle()
                .fill(.red)
                .rotationEffect(.degrees(45))
        }
    }
    
    func testTint() throws {
        try assertMatch(
            #"""
            <Button modifiers='[{"type": "tint", "color": {"string": "system-red"}}]'>Hello</Button>
            """#
        ) {
            Button("Hello") {}
                .tint(.red)
        }
    }

    func testBlendMode() throws {
        try assertMatch(
            #"""
            <VStack>
                <Color name="system-red" modifiers='[{"blend_mode":"normal","type":"blend_mode"}]' />
                <Color name="system-red" modifiers='[{"blend_mode":"darken","type":"blend_mode"}]' />
                <Color name="system-red" modifiers='[{"blend_mode":"multiply","type":"blend_mode"}]' />
                <Color name="system-red" modifiers='[{"blend_mode":"color_burn","type":"blend_mode"}]' />
                <Color name="system-red" modifiers='[{"blend_mode":"plus_darker","type":"blend_mode"}]' />
                <Color name="system-red" modifiers='[{"blend_mode":"lighten","type":"blend_mode"}]' />
                <Color name="system-red" modifiers='[{"blend_mode":"screen","type":"blend_mode"}]' />
                <Color name="system-red" modifiers='[{"blend_mode":"color_dodge","type":"blend_mode"}]' />
                <Color name="system-red" modifiers='[{"blend_mode":"plus_lighter","type":"blend_mode"}]' />
                <Color name="system-red" modifiers='[{"blend_mode":"overlay","type":"blend_mode"}]' />
            </VStack>
            <VStack>
                <Color name="system-red" modifiers='[{"blend_mode":"soft_light","type":"blend_mode"}]' />
                <Color name="system-red" modifiers='[{"blend_mode":"hard_light","type":"blend_mode"}]' />
                <Color name="system-red" modifiers='[{"blend_mode":"difference","type":"blend_mode"}]' />
                <Color name="system-red" modifiers='[{"blend_mode":"exclusion","type":"blend_mode"}]' />
                <Color name="system-red" modifiers='[{"blend_mode":"hue","type":"blend_mode"}]' />
                <Color name="system-red" modifiers='[{"blend_mode":"saturation","type":"blend_mode"}]' />
                <Color name="system-red" modifiers='[{"blend_mode":"color","type":"blend_mode"}]' />
                <Color name="system-red" modifiers='[{"blend_mode":"luminosity","type":"blend_mode"}]' />
                <Color name="system-red" modifiers='[{"blend_mode":"source_atop","type":"blend_mode"}]' />
                <Color name="system-red" modifiers='[{"blend_mode":"destination_over","type":"blend_mode"}]' />
            </VStack>
            <VStack>
                <Color name="system-red" modifiers='[{"blend_mode":"destination_out","type":"blend_mode"}]' />
            </VStack>
            """#
        ) {
            VStack {
                Color(.systemRed)
                    .blendMode(.normal)
                Color(.systemRed)
                    .blendMode(.darken)
                Color(.systemRed)
                    .blendMode(.multiply)
                Color(.systemRed)
                    .blendMode(.colorBurn)
                Color(.systemRed)
                    .blendMode(.plusDarker)
                Color(.systemRed)
                    .blendMode(.lighten)
                Color(.systemRed)
                    .blendMode(.screen)
                Color(.systemRed)
                    .blendMode(.colorDodge)
                Color(.systemRed)
                    .blendMode(.plusLighter)
                Color(.systemRed)
                    .blendMode(.overlay)
            }
            VStack {
                Color(.systemRed)
                    .blendMode(.softLight)
                Color(.systemRed)
                    .blendMode(.hardLight)
                Color(.systemRed)
                    .blendMode(.difference)
                Color(.systemRed)
                    .blendMode(.exclusion)
                Color(.systemRed)
                    .blendMode(.hue)
                Color(.systemRed)
                    .blendMode(.saturation)
                Color(.systemRed)
                    .blendMode(.color)
                Color(.systemRed)
                    .blendMode(.luminosity)
                Color(.systemRed)
                    .blendMode(.sourceAtop)
                Color(.systemRed)
                    .blendMode(.destinationOver)
            }
            VStack{
                Color(.systemRed)
                    .blendMode(.destinationOut)
            }
        }
    }
}
