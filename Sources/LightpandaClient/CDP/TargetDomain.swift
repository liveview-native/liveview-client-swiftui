extension CDP {
    public struct Target {
        // Methods
        
        public struct CreateTarget: CDP.Method {
            public static let method = "Target.createTarget"
            
            public let url: String
            public let browserContextId: String?
            
            public struct Response: Decodable, Sendable {
                let targetId: String
            }
        }
        
        public struct CreateBrowserContext: CDP.Method {
            public static let method = "Target.createBrowserContext"
            
            public struct Response: Decodable, Sendable {
                let browserContextId: String
            }
        }
        
        public struct SetAutoAttach: CDP.Method {
            public static let method = "Target.setAutoAttach"
            
            public let autoAttach: Bool
            public let flatten: Bool
            public let waitForDebuggerOnStart: Bool
            
            public struct Response: Decodable, Sendable {}
        }
        
        public struct SetDiscoverTargets: CDP.Method {
            public static let method = "Target.setDiscoverTargets"
            
            public let discover: Bool
            
            public struct Response: Decodable, Sendable {}
        }
        
        // Events
        
        public struct TargetCreated: Decodable, Sendable {
            public let targetInfo: TargetInfo
        }
        
        // Types
        
        public struct TargetInfo: Decodable, Sendable {
            public let url: String
            public let title: String
            public let targetId: String
            public let attached: Bool
            public let type: String
            public let canAccessOpener: Bool
            public let browserContextId: String
        }
    }
}
