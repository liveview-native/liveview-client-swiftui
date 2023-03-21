//
//  Executable.swift
//  
//
//  Created by Carson Katri on 3/21/23.
//

import Foundation

/// A type that represents a command that can be called with arguments.
@dynamicMemberLookup
@dynamicCallable
struct Executable {
    let executableURL: URL
    let currentDirectoryURL: URL
    let isXcodeBuildStyle: Bool
    
    init(_ name: String, currentDirectoryURL: URL, isXcodeBuildStyle: Bool = false) {
        let bin = URL(filePath: "/usr/bin/\(name)")
        let brew = URL(filePath: "/opt/homebrew/bin/\(name)")
        self.executableURL = FileManager.default.fileExists(atPath: bin.path(percentEncoded: false)) ? bin : brew
        self.currentDirectoryURL = currentDirectoryURL
        self.isXcodeBuildStyle = isXcodeBuildStyle
    }
    
    subscript(dynamicMember subCommand: String) -> ArgumentSet {
        .init(parent: self, arguments: [subCommand])
    }
    
    func execute(_ argumentSet: ArgumentSet) throws {
        #if os(macOS)
        let process = Process()
        process.executableURL = executableURL
        process.currentDirectoryURL = currentDirectoryURL
        process.arguments = argumentSet.arguments

        try process.run()
        process.waitUntilExit()
        
        guard process.terminationReason == .exit && process.terminationStatus == 0 else {
            throw ExecutableError("\(process.terminationReason):\(process.terminationStatus)")
        }
        #endif
    }
    
    struct ExecutableError: LocalizedError {
        let errorDescription: String?
        
        init(_ message: String) {
            self.errorDescription = message
        }
    }
    
    func dynamicallyCall(withArguments args: [String]) throws {
        try ArgumentSet(parent: self, arguments: []).dynamicallyCall(withArguments: args)
    }
    
    func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, String>) throws {
        try ArgumentSet(parent: self, arguments: []).dynamicallyCall(withKeywordArguments: args)
    }
    
    @dynamicCallable
    @dynamicMemberLookup
    struct ArgumentSet {
        let parent: Executable
        let arguments: [String]
        
        func dynamicallyCall(withArguments args: [String]) throws {
            try parent.execute(.init(parent: parent, arguments: arguments + args))
        }
        
        func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, String>) throws {
            try parent.execute(.init(parent: parent, arguments: arguments + args.flatMap({
                if parent.isXcodeBuildStyle {
                    if $0.key == $0.key.uppercased() {
                        return ["\($0.key)=\($0.value == "" ? "\"\"" : $0.value)"]
                    } else {
                        return ["-\($0.key)", $0.value]
                    }
                } else {
                    return ["--\($0.key)", $0.value]
                }
            })))
        }
        
        subscript(dynamicMember subCommand: String) -> Self {
            .init(parent: parent, arguments: arguments + [subCommand])
        }
    }
}
