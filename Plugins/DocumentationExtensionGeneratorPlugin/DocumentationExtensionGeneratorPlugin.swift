import PackagePlugin
import Foundation

@main
struct DocumentationExtensionGeneratorPlugin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: try context.tool(named: "DocumentationExtensionGenerator").path.string)
        
        let target = context.package.targets.first(where: { $0.name == "LiveViewNative" })! as! SourceModuleTarget
        let viewFiles = target.sourceFiles
            .filter({ $0.path.string.starts(with: target.directory.appending("Views").string) })
            .filter({ $0.type == .source })
            .map(\.path)
        let modifierFiles = target.sourceFiles
            .filter({ $0.path.string.starts(with: target.directory.appending("Modifiers").string) })
            .filter({ $0.type == .source })
            .map(\.path)
        
        process.arguments = arguments
            + viewFiles
                .reduce(into: [String]()) { partialResult, path in
                    partialResult.append("--view")
                    partialResult.append(path.string)
                }
            + modifierFiles
            .reduce(into: [String]()) { partialResult, path in
                partialResult.append("--modifier")
                partialResult.append(path.string)
            }

        try process.run()
        process.waitUntilExit()
    }
}
