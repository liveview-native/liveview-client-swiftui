import PackagePlugin
import Foundation

@main
struct SortDocumentationJSONPlugin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) throws {
        let url = URL(fileURLWithPath: context.package.directory.appending(["docs"]).string, isDirectory: true)
        for fileURL in FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey])! {
            guard let fileURL = fileURL as? URL,
                  fileURL.pathExtension == "json",
                  let isRegularFile = try fileURL.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile,
                  isRegularFile
            else { continue }
            let object = try JSONSerialization.jsonObject(with: try Data(contentsOf: fileURL))
            try JSONSerialization.data(withJSONObject: object, options: [.sortedKeys, .prettyPrinted]).write(to: fileURL)
        }
    }
}
