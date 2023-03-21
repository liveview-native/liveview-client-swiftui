import PackagePlugin
import Foundation

@main
struct DocumentationExtensionGeneratorPlugin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: try context.tool(named: "DocumentationExtensionGenerator").path.string)
        process.arguments = arguments

        try process.run()
        process.waitUntilExit()
    }
}
