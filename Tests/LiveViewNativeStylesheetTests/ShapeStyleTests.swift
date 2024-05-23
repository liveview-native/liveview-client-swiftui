//
//  ShapeStyleTests.swift
//
//
//  Created by Carson Katri on 1/16/24.
//

import XCTest
import SwiftUI
@testable import LiveViewNativeStylesheet
@testable import LiveViewNative

extension XCTestCase {
    func testParserEqual<T>(
        _ ast: String,
        _ value: T
    ) where T: Equatable, T: ParseableModifierValue {
        XCTAssertEqual(
            try T.parser(in: .init()).parse(ast),
            value
        )
    }
    func testParser<T>(
        _ ast: String,
        as t: T.Type = T.self
    ) where T: ParseableModifierValue {
        XCTAssertNoThrow(try T.parser(in: .init()).parse(ast))
    }
}

extension XCTestCase {
    func testParserShapeStyle<T>(
        _ ast: String,
        _ value: T
    ) where T: Equatable, T: ParseableModifierValue {
        testParserEqual(ast, value)
        testParser(ast, as: AnyShapeStyle.self)
    }
    
    @_disfavoredOverload
    func testParserShapeStyle<T>(
        _ ast: String,
        _ value: T
    ) where T: ParseableModifierValue {
        testParser(ast, as: AnyShapeStyle.self)
    }
}

final class ShapeStyleTests: XCTestCase {
    func testColor() {
        // static members
        testParserShapeStyle(
            #"{:., [], [:Color, :pink]}"#,
            Color.pink
        )
        testParserShapeStyle(
            #"{:., [], [nil, :pink]}"#,
            Color.pink
        )
        // inits
        testParserShapeStyle(
            #"{:Color, [], [{:., [], [nil, :sRGB]}, [red: 0.4627, green: 0.8392, blue: 1.0]]}"#,
            Color(.sRGB, red: 0.4627, green: 0.8392, blue: 1.0)
        )
        testParserShapeStyle(
            #"{:Color, [], [{:., [], [nil, :sRGB]}, [white: 0.5, opacity: 0.5]]}"#,
            Color(.sRGB, white: 0.5, opacity: 0.5)
        )
        testParserShapeStyle(
            #"{:Color, [], [[hue: 1, saturation: 0.5, brightness: 0.25, opacity: 0.75]]}"#,
            Color(hue: 1, saturation: 0.5, brightness: 0.25, opacity: 0.75)
        )
        testParserShapeStyle(
            #"{:Color, [], [[red: 0.852, green: 0.646, blue: 0.847]]}"#,
            Color(red: 0.852, green: 0.646, blue: 0.847)
        )
        // modifiers
        testParserShapeStyle(
            #"{:., [], [nil, {:., [], [:pink, {:opacity, [], [0.5]}]}]}"#,
            Color.pink.opacity(0.5)
        )
        testParserShapeStyle(
            #"{:., [], [:Color, {:., [], [:pink, {:opacity, [], [0.5]}]}]}"#,
            Color.pink.opacity(0.5)
        )
        testParserShapeStyle(
            #"{:., [], [{:Color, [], [{:., [], [nil, :displayP3]}, [red: 0.4627, green: 0.8392, blue: 1.0]]}, {:opacity, [], [0.25]}]}"#,
            Color(.displayP3, red: 0.4627, green: 0.8392, blue: 1.0).opacity(0.25)
        )
    }
    
    func testGradient() {
        // AnyGradient
        testParserShapeStyle(
            #"{:., [], [:Color, {:., [], [:red, :gradient]}]}"#,
            Color.red.gradient
        )
        testParserShapeStyle(
            #"{:., [], [:Color, {:., [], [:pink, {:., [], [{:opacity, [], [0.5]}, :gradient]}]}]}"#,
            Color.pink.opacity(0.5).gradient
        )
        // Gradient
        testParserShapeStyle(
            #"{:Gradient, [], [[colors: [{:., [], [nil, :red]}, {:., [], [nil, :blue]}]]]}"#,
            Gradient(colors: [.red, .blue])
        )
        testParserShapeStyle(
            #"{:Gradient, [], [[stops: [{:., [], [:Gradient, {:Stop, [], [[color: {:., [], [nil, :red]}, location: 0.5]]}]}, {:., [], [:Gradient, {:Stop, [], [[color: {:., [], [nil, :blue]}, location: 1]]}]}]]]}"#,
            Gradient(stops: [Gradient.Stop(color: .red, location: 0.5), Gradient.Stop(color: .blue, location: 1)])
        )
        // angularGradient
        testParserShapeStyle(
            #"{:., [], [nil, {:angularGradient, [], [{:., [], [:Color, {:., [], [:red, :gradient]}]}, [center: {:., [], [nil, :center]}, startAngle: {:., [], [nil, :zero]}, endAngle: {:., [], [nil, {:degrees, [], [270]}]}]]}]}"#,
            AnyShapeStyle(AngularGradient.angularGradient(Color.red.gradient, startAngle: .zero, endAngle: .degrees(270)))
        )
        testParserShapeStyle(
            #"{:AngularGradient, [], [[gradient: {:Gradient, [], [[stops: [{:., [], [:Gradient, {:Stop, [], [[color: {:., [], [nil, :red]}, location: 0.5]]}]}, {:., [], [:Gradient, {:Stop, [], [[color: {:., [], [nil, :blue]}, location: 1]]}]}]]]}, center: {:., [], [nil, :center]}, startAngle: {:., [], [nil, :zero]}, endAngle: {:., [], [nil, {:degrees, [], [270]}]}]]}"#,
            AngularGradient(gradient: Gradient(stops: [Gradient.Stop(color: .red, location: 0.5), Gradient.Stop(color: .blue, location: 1)]), center: .center, startAngle: .zero, endAngle: .degrees(270))
        )
        // conicGradient
        testParserShapeStyle(
            #"{:., [], [nil, {:conicGradient, [], [{:., [], [:Color, {:., [], [:red, :gradient]}]}, [center: {:., [], [nil, :center]}, angle: {:., [], [nil, {:degrees, [], [270]}]}]]}]}"#,
            AnyShapeStyle(AngularGradient.conicGradient(Color.red.gradient, center: .center, angle: .degrees(270)))
        )
        testParserShapeStyle(
            #"{:AngularGradient, [], [[gradient: {:Gradient, [], [[stops: [{:., [], [:Gradient, {:Stop, [], [[color: {:., [], [nil, :red]}, location: 0.5]]}]}, {:., [], [:Gradient, {:Stop, [], [[color: {:., [], [nil, :blue]}, location: 1]]}]}]]]}, center: {:., [], [nil, :center]}, angle: {:., [], [nil, {:degrees, [], [270]}]}]]}"#,
            AngularGradient(gradient: Gradient(stops: [Gradient.Stop(color: .red, location: 0.5), Gradient.Stop(color: .blue, location: 1)]), center: .center, angle: .degrees(270))
        )
        // ellipticalGradient
        testParserShapeStyle(
            #"{:., [], [nil, {:ellipticalGradient, [], [{:., [], [:Color, {:., [], [:red, :gradient]}]}, [center: {:., [], [nil, :center]}, startRadiusFraction: 0, endRadiusFraction: 1]]}]}"#,
            AnyShapeStyle(EllipticalGradient.ellipticalGradient(Color.red.gradient, center: .center, startRadiusFraction: 0, endRadiusFraction: 1))
        )
        testParserShapeStyle(
            #"{:EllipticalGradient, [], [[gradient: {:Gradient, [], [[stops: [{:., [], [:Gradient, {:Stop, [], [[color: {:., [], [nil, :red]}, location: 0.5]]}]}, {:., [], [:Gradient, {:Stop, [], [[color: {:., [], [nil, :blue]}, location: 1]]}]}]]]}, center: {:., [], [nil, :center]}, startRadiusFraction: 0, endRadiusFraction: 1]]}"#,
            EllipticalGradient(gradient: Gradient(stops: [Gradient.Stop(color: .red, location: 0.5), Gradient.Stop(color: .blue, location: 1)]), center: .center, startRadiusFraction: 0, endRadiusFraction: 1)
        )
        // linearGradient
        testParserShapeStyle(
            #"{:., [], [nil, {:linearGradient, [], [{:., [], [:Color, {:., [], [:red, :gradient]}]}, [startPoint: {:., [], [nil, :leading]}, endPoint: {:., [], [nil, :trailing]}]]}]}"#,
            AnyShapeStyle(LinearGradient.linearGradient(Color.red.gradient, startPoint: .leading, endPoint: .trailing))
        )
        testParserShapeStyle(
            #"{:LinearGradient, [], [[gradient: {:Gradient, [], [[stops: [{:., [], [:Gradient, {:Stop, [], [[color: {:., [], [nil, :red]}, location: 0.5]]}]}, {:., [], [:Gradient, {:Stop, [], [[color: {:., [], [nil, :blue]}, location: 1]]}]}]]]}, startPoint: {:., [], [nil, :leading]}, endPoint: {:., [], [nil, :trailing]}]]}"#,
            LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: .red, location: 0.5), Gradient.Stop(color: .blue, location: 1)]), startPoint: .leading, endPoint: .trailing)
        )
        // radialGradient
        testParserShapeStyle(
            #"{:., [], [nil, {:radialGradient, [], [{:., [], [:Color, {:., [], [:red, :gradient]}]}, [center: {:., [], [nil, :center]}, startRadius: 0.5, endRadius: 1]]}]}"#,
            AnyShapeStyle(RadialGradient.radialGradient(Color.red.gradient, center: .center, startRadius: 0.5, endRadius: 1))
        )
        testParserShapeStyle(
            #"{:RadialGradient, [], [[gradient: {:Gradient, [], [[stops: [{:., [], [:Gradient, {:Stop, [], [[color: {:., [], [nil, :red]}, location: 0.5]]}]}, {:., [], [:Gradient, {:Stop, [], [[color: {:., [], [nil, :blue]}, location: 1]]}]}]]]}, center: {:., [], [nil, :center]}, startRadius: 0.5, endRadius: 1]]}"#,
            RadialGradient(gradient: Gradient(stops: [Gradient.Stop(color: .red, location: 0.5), Gradient.Stop(color: .blue, location: 1)]), center: .center, startRadius: 0.5, endRadius: 1)
        )
    }
    
    func testHierarchical() {
        testParserShapeStyle(
            #"{:., [], [nil, :tertiary]}"#,
            HierarchicalShapeStyle.tertiary
        )
        if #available(macOS 14.0, iOS 17, watchOS 10, tvOS 17, visionOS 1, *) {
            testParserShapeStyle(
                #"{:., [], [:Color, {:., [], [:red, :quaternary]}]}"#,
                AnyShapeStyle(Color.red.quaternary)
            )
        }
    }
    
    func testMaterial() {
        if #available(iOS 15, macOS 12, tvOS 15, watchOS 10, visionOS 1, *) {
            testParserShapeStyle(
                #"{:., [], [nil, :regularMaterial]}"#,
                AnyShapeStyle(Material.regularMaterial)
            )
            testParserShapeStyle(
                #"{:., [], [nil, :ultraThickMaterial]}"#,
                AnyShapeStyle(Material.ultraThickMaterial)
            )
        }
    }
    
    func testImagePaint() {
        testParserShapeStyle(
            #"{:., [], [nil, {:image, [], [{:Image, [], ["test"]}, [sourceRect: {:CGRect, [], [[x: 0, y: 0, width: 1, height: 1]]}, scale: 1]]}]}"#,
            AnyShapeStyle(.image(Image("test"), sourceRect: CGRect(x: 0, y: 0, width: 1, height: 1), scale: 1))
        )
        testParserShapeStyle(
            #"{:ImagePaint, [], [[image: {:Image, [], ["test"]}, sourceRect: {:CGRect, [], [[x: 0, y: 0, width: 1, height: 1]]}, scale: 1]]}"#,
            ImagePaint(image: Image("test"), sourceRect: CGRect(x: 0, y: 0, width: 1, height: 1), scale: 1)
        )
    }
    
    func testSemanticStyles() {
        testParserShapeStyle(
            #"{:., [], [nil, :foreground]}"#,
            AnyShapeStyle(.foreground)
        )
        testParserShapeStyle(
            #"{:., [], [nil, :background]}"#,
            AnyShapeStyle(.background)
        )
        #if !os(watchOS)
        testParserShapeStyle(
            #"{:., [], [nil, :selection]}"#,
            AnyShapeStyle(.selection)
        )
        #endif
        testParserShapeStyle(
            #"{:., [], [nil, :tint]}"#,
            AnyShapeStyle(.tint)
        )
        if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, visionOS 1, *) {
            testParserShapeStyle(
                #"{:., [], [nil, :separator]}"#,
                AnyShapeStyle(.separator)
            )
            testParserShapeStyle(
                #"{:., [], [nil, :placeholder]}"#,
                AnyShapeStyle(.placeholder)
            )
            testParserShapeStyle(
                #"{:., [], [nil, :link]}"#,
                AnyShapeStyle(.link)
            )
            testParserShapeStyle(
                #"{:., [], [nil, :fill]}"#,
                AnyShapeStyle(.fill)
            )
        }
        if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
            testParserShapeStyle(
                #"{:., [], [nil, :windowBackground]}"#,
                AnyShapeStyle(.windowBackground)
            )
        }
    }
    
    func testStyleModifiers() {
        testParserShapeStyle(
            #"{:., [], [nil, {:blendMode, [], [{:., [], [nil, :multiply]}]}]}"#,
            AnyShapeStyle(.blendMode(.multiply))
        )
        testParserShapeStyle(
            #"{:., [], [nil, {:opacity, [], [0.5]}]}"#,
            AnyShapeStyle(.opacity(0.5))
        )
        testParserShapeStyle(
            #"{:., [], [nil, {:shadow, [], [{:., [], [nil, {:drop, [], [[color: {:Color, [], [{:., [], [nil, :sRGBLinear]}, [white: 0, opacity: 0.33]]}, radius: 5, x: 0, y: 0]]}]}]}]}"#,
            AnyShapeStyle(.shadow(.drop(color: Color(.sRGBLinear, white: 0, opacity: 0.33), radius: 5, x: 0, y: 0)))
        )
        
        testParserShapeStyle(
            #"{:., [], [nil, {:., [], [:foreground, {:blendMode, [], [{:., [], [nil, :multiply]}]}]}]}"#,
            AnyShapeStyle(.foreground.blendMode(.multiply))
        )
        testParserShapeStyle(
            #"{:., [], [nil, {:., [], [:foreground, {:opacity, [], [0.5]}]}]}"#,
            AnyShapeStyle(.foreground.opacity(0.5))
        )
        testParserShapeStyle(
            #"{:., [], [nil, {:shadow, [], [{:., [], [nil, {:drop, [], [[color: {:Color, [], [{:., [], [nil, :sRGBLinear]}, [white: 0, opacity: 0.33]]}, radius: 5, x: 0, y: 0]]}]}]}]}"#,
            AnyShapeStyle(.foreground.shadow(.inner(color: Color(.sRGBLinear, white: 0, opacity: 0.55), radius: 5, x: 0, y: 0)))
        )
    }
}
