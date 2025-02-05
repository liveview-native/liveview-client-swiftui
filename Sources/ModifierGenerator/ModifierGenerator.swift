import ArgumentParser
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftParser

@main
struct ModifierGenerator: ParsableCommand {
    /// The path used as the output file.
    @Argument(transform: { URL(filePath: $0) })
    private var output: URL
    
    /// The header included before any generated file output.
    static let header = #"""
    // Note: This file is auto-generated from the `ModifierGeneratorPlugin`.
    import SwiftUI
    import Spatial
    import LiveViewNativeStylesheet
    
    """#
    
    func run() throws {
        // remove the SDK part of the path.
        // /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX15.2.sdk
        // /Applications/Xcode.app/Contents/Developer/Platforms/
        guard let sdkRoot = ProcessInfo.processInfo.environment["SDKROOT"]
            .flatMap({
                URL(filePath: $0)
                    .deletingLastPathComponent()
                    .deletingLastPathComponent()
                    .deletingLastPathComponent()
                    .deletingLastPathComponent()
            })
        else { throw ModifierGeneratorError.missingSDKROOT }
        
        // get the `.swiftinterface` files from the XROS SDK.
        let swiftUICoreInterface = sdkRoot.appending(path: "XROS.platform/Developer/SDKs/XROS.sdk/System/Library/Frameworks/SwiftUICore.framework/Modules/SwiftUICore.swiftmodule/arm64e-apple-xros.swiftinterface")
        let swiftUIInterface = sdkRoot.appending(path: "XROS.platform/Developer/SDKs/XROS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64e-apple-xros.swiftinterface")
        
        // walk the SwiftUICore interface file.
        let swiftUICoreGenerator = StyleDefinitionGenerator(moduleName: "SwiftUICore")
        let swiftUICoreSource = Parser.parse(source: try String(contentsOf: swiftUICoreInterface, encoding: .utf8))
        swiftUICoreGenerator.walk(swiftUICoreSource)
        
        // walk the SwiftUI interface file, adding onto the modifiers from walking SwiftUICore.
        let swiftUIGenerator = StyleDefinitionGenerator(moduleName: "SwiftUI")
        swiftUIGenerator.modifiers = swiftUICoreGenerator.modifiers // this makes sure modifiers with the same name in SwiftUICore and SwiftUI are merged and not duplicated.
        let swiftUISource = Parser.parse(source: try String(contentsOf: swiftUIInterface, encoding: .utf8))
        swiftUIGenerator.walk(swiftUISource)
        
        // merge all modifier decoders
        let sortedModifiers = swiftUIGenerator.modifiers.sorted(by: { $0.key < $1.key })
        let modifiersOutput = sortedModifiers
            .map { $0.value.formatted().description }
            .joined(separator: "\n")
        
        // merge all type decoders
        var decoderOutputs = swiftUICoreGenerator.decoderExtensions.mapValues({ $0.map({ $0.formatted().description }).joined(separator: "\n") })
        decoderOutputs.merge(swiftUIGenerator.decoderExtensions.mapValues({ $0.map({ $0.formatted().description }).joined(separator: "\n") })) {
            [$0, $1].joined(separator: "\n")
        }
        
        // write the output
        var outputContents = ""
        
        outputContents += Self.header
        
        for (name, decoder) in decoderOutputs {
            guard modifiersOutput.contains(name) || decoderOutputs.filter({ $0.key != name }).values.contains(where: { $0.contains(name) })
            else { continue } // this type is not used by any modifiers or other decoders
            outputContents += decoder + "\n"
        }
        
        outputContents += modifiersOutput
        
        // create the `BuiltinModifier` type
        outputContents += "\n"
        
        // chunk the modifiers into smaller groups (so each one uses less memory on the stack)
        let chunkSize = 14
        let modifierList = sortedModifiers.map(\.key)
        let modifierChunks: [[String]] = stride(from: 0, to: modifierList.count, by: chunkSize).map {
            Array(modifierList[$0..<min($0 + chunkSize, modifierList.count)])
        }
        for (index, chunk) in modifierChunks.enumerated() {
            outputContents += try makeBuiltinModifierChunk("_BuiltinModifier__Chunk\(index)", chunk)
                .formatted()
                .description
            outputContents += "\n"
        }
        // aggregate of all modifier chunks
        outputContents += makeBuiltinModifier(modifierChunks).formatted().description
        
        
        try outputContents.write(to: output, atomically: true, encoding: .utf8)
    }
}

enum ModifierGeneratorError: Error {
    /// The `SDKROOT` environment variable is missing.
    case missingSDKROOT
}
