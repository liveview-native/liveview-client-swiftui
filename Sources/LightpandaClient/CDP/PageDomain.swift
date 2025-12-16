extension CDP {
    public struct Page {
        // Methods
        
        public struct Enable: CDP.Method {
            public static let method = "Page.enable"
            
            public struct Response: Decodable, Sendable {}
        }
        
        public struct Navigate: CDP.Method {
            public static let method = "Page.navigate"
            
            public let url: String
            
            public struct Response: Decodable, Sendable {
                let frameId: String
            }
        }
        
        public struct SetLifecycleEventsEnabled: CDP.Method {
            public static let method = "Page.setLifecycleEventsEnabled"
            
            public let enabled: Bool
            
            public struct Response: Decodable, Sendable {}
        }
        
        public struct Reload: CDP.Method {
            public static let method = "Page.reload"
            
            public init() {}
            
            public struct Response: Decodable, Sendable {}
        }
        
        // Events
        
        public struct LoadEventFired: Decodable, Sendable {
            public let timestamp: Double
        }
    }
}
