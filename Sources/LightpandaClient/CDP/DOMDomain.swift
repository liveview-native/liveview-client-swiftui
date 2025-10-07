extension CDP {
    public struct DOM {
        // Methods
        
        public struct Enable: CDP.Method {
            public static let method = "DOM.enable"
            
            public struct Response: Decodable, Sendable {}
        }
        
        public struct GetDocument: CDP.Method {
            public static let method = "DOM.getDocument"
            
            public let depth: Int?
            public let pierce: Bool?
            
            public init(depth: Int?, pierce: Bool?) {
                self.depth = depth
                self.pierce = pierce
            }
            
            public struct Response: Decodable, Sendable {
                public let root: Node
            }
        }
        
        // Events
        
        public struct CharacterDataModified: Decodable, Sendable {
            /// Id of the node that has changed.
            public let nodeId: Node.ID
            /// New text value.
            public let characterData: String
        }
        
        public struct ChildNodeInserted: Decodable, Sendable {
            /// Id of the parent node.
            public let parentNodeId: Node.ID
            /// Id of the previous child node.
            public let previousNodeId: Node.ID?
            /// The node data
            public let node: Node
        }
        
        // Types
        
        public struct Node: Decodable, Identifiable, Sendable {
            public typealias NodeId = Int
            public typealias BackendNodeId = Int
            
            public let nodeId: NodeId
            public let parentId: NodeId?
            public let backendNodeId: BackendNodeId
            public let nodeType: NodeType
            public let nodeName: String
            public let localName: String
            public let nodeValue: String
            public let childNodeCount: Int?
            public let children: [Node]?
            public let attributes: [String]?
            public let documentURL: String?
            public let baseURL: String?
            public let publicId: String?
            public let systemId: String?
            public let internalSubset: String?
            public let xmlVersion: String?
            public let name: String?
            public let value: String?
            
            public var id: NodeId {
                nodeId
            }
        }
    }
}
