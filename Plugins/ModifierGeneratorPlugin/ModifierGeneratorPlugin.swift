//
//  BuiltinRegistryGeneratorPlugin.swift
//
//
//  Created by Carson Katri on 4/18/23.
//

import PackagePlugin
import Foundation

@main
struct ModifierGeneratorPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let tool = try context.tool(named: "ModifierGenerator")
        let output = context.pluginWorkDirectoryURL.appending(path: "GeneratedModifiers.swift")
        
//        target.directoryURL.path(percentEncoded: false)
        let arguments: [String] = [output.path(percentEncoded: false)]
        
        return [
            .buildCommand(
                displayName: tool.name,
                executable: tool.url,
                arguments: arguments,
//                environment: ProcessInfo.processInfo.environment,
//                environment: ["SDKROOT": "/Applications/Xcode-16-3.app/Contents/Developer/Platforms/WatchSimulator.platform/Developer/SDKs/WatchSimulator.sdk"],
//                environment: ["SDKROOT": "/Applications/Xcode-16-3.app/Contents/Developer/Platforms/AppleTVSimulator.platform/Developer/SDKs/AppleTVSimulator.sdk"],
                environment: ["SDKROOT": "/Applications/Xcode-16-3.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator18.4.sdk"],
                inputFiles: [],
                outputFiles: [output]
            )
        ]
    }
}
