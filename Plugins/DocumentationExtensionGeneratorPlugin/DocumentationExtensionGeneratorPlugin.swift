import PackagePlugin
import Foundation

@main
struct DocumentationExtensionGeneratorPlugin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) throws {
        let process = Process()
        process.executableURL = try context.tool(named: "DocumentationExtensionGenerator").url
        
        let target = context.package.targets.first(where: { $0.name == "LiveViewNative" })! as! SwiftSourceModuleTarget
        let viewFiles = target.sourceFiles
            .filter({ $0.url.pathComponents.starts(with: target.directoryURL.appending(path: "Views").pathComponents) })
            .filter({ $0.type == .source })
            .map(\.url)
        
        process.arguments = arguments
            + viewFiles
                .reduce(into: [String]()) { partialResult, url in
                    partialResult.append("--view")
                    partialResult.append(url.path())
                }

        try process.run()
        process.waitUntilExit()
    }
}
