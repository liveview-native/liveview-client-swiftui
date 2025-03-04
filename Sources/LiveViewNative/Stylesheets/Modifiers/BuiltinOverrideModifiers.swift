//
//  BuiltinOverrideModifiers.swift
//  LiveViewNative
//
//  Created by Carson.Katri on 2/27/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

enum BuiltinOverrideModifiers<R: RootRegistry>: ViewModifier, @preconcurrency Decodable {
    #if os(iOS) || os(macOS) || os(visionOS)
    case fileImporter(FileImporterModifier<R>)
    #endif
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        #if os(iOS) || os(macOS) || os(visionOS)
        if let fileImporter = try? container.decode(FileImporterModifier<R>.self) {
            self = .fileImporter(fileImporter)
            return
        }
        #endif
        
        throw BuiltinRegistryModifierError.unknownModifier
    }
    
    func body(content: Content) -> some View {
        switch self {
        #if os(iOS) || os(macOS) || os(visionOS)
        case let .fileImporter(modifier):
            content.modifier(modifier)
        #endif
        default:
            content
        }
    }
}
