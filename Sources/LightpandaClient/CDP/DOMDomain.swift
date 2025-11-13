extension CDP {
    struct DOM {
        // Methods
        
        struct Enable: CDP.Method {
            static let method = "DOM.enable"
            
            struct Response: Decodable, Sendable {}
        }
        
        struct GetDocument: CDP.Method {
            static let method = "DOM.getDocument"
            
            let depth: Int?
            let pierce: Bool?
            
            init(depth: Int?, pierce: Bool?) {
                self.depth = depth
                self.pierce = pierce
            }
            
            struct Response: Decodable, Sendable {
                let root: Node
            }
        }
        
        struct ResolveNode: CDP.Method {
            static let method = "DOM.resolveNode"
            
            let nodeId: NodeId?
            let backendId: BackendNodeId?
            let objectGroup: String?
            let executionContextId: Runtime.ExecutionContextId?
            
            init(nodeId: NodeId?, backendId: BackendNodeId?, objectGroup: String?, executionContextId: Runtime.ExecutionContextId?) {
                self.nodeId = nodeId
                self.backendId = backendId
                self.objectGroup = objectGroup
                self.executionContextId = executionContextId
            }
            
            struct Response: Decodable, Sendable {
                let object: Runtime.RemoteObject
            }
        }
        
        // Events
        
        struct CharacterDataModified: Decodable, Sendable {
            /// Id of the node that has changed.
            let nodeId: Node.ID
            /// New text value.
            let characterData: String
        }
        
        struct ChildNodeInserted: Decodable, Sendable {
            /// Id of the parent node.
            let parentNodeId: Node.ID
            /// Id of the previous child node.
            let previousNodeId: Node.ID?
            /// The node data
            let node: Node
        }
        
        struct ChildNodeRemoved: Decodable, Sendable {
            /// Id of the parent node.
            let parentNodeId: Node.ID
            /// Id of the node that has been removed.
            let nodeId: Node.ID
        }
        
        // Types
        
        struct Node: Decodable, Identifiable, Sendable {
            let nodeId: NodeId
            let parentId: NodeId?
            let backendNodeId: BackendNodeId
            let nodeType: NodeType
            let nodeName: String
            let localName: String
            let nodeValue: String
            let childNodeCount: Int?
            let children: [Node]?
            let attributes: [String]?
            let documentURL: String?
            let baseURL: String?
            let publicId: String?
            let systemId: String?
            let internalSubset: String?
            let xmlVersion: String?
            let name: String?
            let value: String?
            
            var id: NodeId {
                nodeId
            }
        }
        
        typealias NodeId = Int
        typealias BackendNodeId = Int
    }
}
