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
        guard let target = target as? SourceModuleTarget else { return [] }
        let tool = try context.tool(named: "BuiltinRegistryGenerator")
        let output = context.pluginWorkDirectory.appending("BuiltinRegistry+Views.swift")
        let viewFiles = target.sourceFiles
            .filter({ $0.path.string.starts(with: target.directory.appending("Views").string) })
            .filter({ $0.type == .source })
            .map(\.path)
        let modifierFiles = target.sourceFiles
            .filter({ $0.path.string.starts(with: target.directory.appending("Modifiers").string) })
            .filter({ $0.type == .source })
            .map(\.path)
        return [
            .buildCommand(
                displayName: tool.name,
                executable: tool.path,
                arguments: [target.directory.string, output.string] +
                    viewFiles
                        .reduce(into: [String]()) { partialResult, path in
                            partialResult.append("--view")
                            partialResult.append(path.string)
                        }
                    + modifierFiles
                    .reduce(into: [String]()) { partialResult, path in
                        partialResult.append("--modifier")
                        partialResult.append(path.string)
                    },
                environment: [:],
                inputFiles: viewFiles + modifierFiles,
                outputFiles: [output]
            )
        ]
    }
}
