import PackagePlugin
import Foundation

@main
struct TutorialRepoGeneratorPlugin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: try context.tool(named: "TutorialRepoGenerator").path.string)
        process.arguments = arguments

        try process.run()
        process.waitUntilExit()
        
        guard process.terminationReason == .exit && process.terminationStatus == 0 else {
            let problem = "\(process.terminationReason):\(process.terminationStatus)"
            Diagnostics.error(problem)
            return
        }
    }
}
