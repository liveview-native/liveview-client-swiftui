import PackagePlugin
import Foundation

@main
struct SortDocumentationJSONPlugin: CommandPlugin {
    static let codeSyntaxTransformations = [
        "ex": "elixir",
        "heex": "html"
    ]

    func performCommand(context: PluginContext, arguments: [String]) throws {
        let url = URL(fileURLWithPath: context.package.directory.appending(["docs"]).string, isDirectory: true)
        for fileURL in FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey])! {
            guard let fileURL = fileURL as? URL,
                  fileURL.pathExtension == "json",
                  let isRegularFile = try fileURL.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile,
                  isRegularFile
            else { continue }
            let object = try JSONSerialization.jsonObject(with: try Data(contentsOf: fileURL))
            if var object = object as? [String:Any] {
                // Transform "syntax" keys for file references.
                if var references = object["references"] as? [String:[String:Any]] {
                    for (file, value) in references {
                        guard let syntax = value["syntax"] as? String else { continue }
                        references[file]?["syntax"] = Self.codeSyntaxTransformations[syntax] ?? syntax
                    }
                    object["references"] = references
                }
                try JSONSerialization.data(withJSONObject: object, options: [.sortedKeys, .prettyPrinted]).write(to: fileURL)
            } else {
                try JSONSerialization.data(withJSONObject: object, options: [.sortedKeys, .prettyPrinted]).write(to: fileURL)
            }
        }
    }
}
