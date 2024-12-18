//
//  BuiltinRegistryGeneratorPlugin.swift
//
//
//  Created by Carson Katri on 4/18/23.
//

import PackagePlugin
import Foundation

@main
struct BuiltinRegistryGeneratorPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        guard let target = target as? SwiftSourceModuleTarget else { return [] }
        let tool = try context.tool(named: "BuiltinRegistryGenerator")
        let output = context.pluginWorkDirectoryURL.appending(path: "BuiltinRegistry+Views.swift")
        let viewFiles = target.sourceFiles
            .filter({ $0.url.pathComponents.starts(with: target.directoryURL.appending(path: "Views").pathComponents) })
            .filter({ $0.type == .source })
            .map(\.url)
        let modifierFiles = target.sourceFiles
            .filter({ $0.url.lastPathComponent == "_GeneratedModifiers.swift" })
            .filter({ $0.type == .source })
            .map(\.url)
        let arguments: [String] = [target.directoryURL.path(percentEncoded: false), output.path(percentEncoded: false)] +
        viewFiles
            .reduce(into: [String]()) { partialResult, url in
                partialResult.append("--view")
                partialResult.append(url.path(percentEncoded: false))
            }
        + modifierFiles
        .reduce(into: [String]()) { partialResult, url in
            partialResult.append("--modifier")
            partialResult.append(url.path(percentEncoded: false))
        }
        print(viewFiles)
        print(modifierFiles)
        print(arguments)
        return [
            .buildCommand(
                displayName: tool.name,
                executable: tool.url,
                arguments: arguments,
                environment: [:],
                inputFiles: viewFiles + modifierFiles,
                outputFiles: [output]
            )
        ]
    }
}
