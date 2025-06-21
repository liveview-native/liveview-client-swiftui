//
//  AppAddonPlugin.swift
//  LiveViewNative
//
//  Created by Carson Katri on 3/6/25.
//

import PackagePlugin
import Foundation

@main
struct AutoAddonPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: any Target) async throws -> [Command] {
        let tool = try context.tool(named: "AutoAddon")
        let inputFiles = target.sourceModule?.sourceFiles
            .filter({
                (try? String(contentsOf: $0.url, encoding: .utf8))?
                    .contains("@LiveElement")
                    ?? false
            })
            .map(\.url)
            ?? []
        let outputFile = context.pluginWorkDirectoryURL.appending(path: "AutoAddon.swift")
        
        return [
            .buildCommand(
                displayName: "Auto Addon",
                executable: tool.url,
                arguments: [
                    target.name,
                    outputFile.absoluteString
                ] + inputFiles.map(\.absoluteString),
                environment: [:],
                inputFiles: inputFiles,
                outputFiles: [outputFile]
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension AutoAddonPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let tool = try context.tool(named: "AutoAddon")
        let inputFiles = target.inputFiles
            .filter({
                (try? String(contentsOf: $0.url, encoding: .utf8))?
                    .contains("@LiveElement")
                    ?? false
            })
            .map(\.url)
        let outputFile = context.pluginWorkDirectoryURL.appending(path: "AutoAddon.swift")
        
        return [
            .buildCommand(
                displayName: "Auto Addon",
                executable: tool.url,
                arguments: [
                    target.displayName,
                    outputFile.absoluteString
                ] + inputFiles.map(\.absoluteString),
                environment: [:],
                inputFiles: inputFiles,
                outputFiles: [outputFile]
            )
        ]
    }
}
#endif
