//
//  Annotations.swift
//  JSONStylesheet
//
//  Created by Carson Katri on 9/24/24.
//

/// Metadata associated with an ``ASTNode``.
///
/// This is encoded as a map with the keys `file`, `line`, `module`, and `source`.
public struct Annotations: Codable, Hashable, Sendable, CustomDebugStringConvertible {
    /// The file the node appears in.
    public let file: String?
    /// The line number this node is on.
    public let line: Int?
    /// The module this node is part of.
    public let module: String?
    /// The source code this node represented.
    public let source: String?
    
    public init() {
        self.file = nil
        self.line = nil
        self.module = nil
        self.source = nil
    }
    
    public init(file: String?, line: Int?, module: String?, source: String?) {
        self.file = file
        self.line = line
        self.module = module
        self.source = source
    }
    
    public var debugDescription: String {
        #"""
        \#(source ?? "unknown source")
        \#(module ?? "UnknownModule") \#(file ?? "unknown_file"):\#(line ?? 1)
        """#
    }
}
