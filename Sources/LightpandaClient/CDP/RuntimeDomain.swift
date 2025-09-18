extension CDP {
    public struct Runtime {
        // Methods
        
        public struct Enable: CDP.Method {
            public static let method = "Runtime.enable"
            
            public struct Response: Decodable, Sendable {}
        }
        
        public struct AddBinding: CDP.Method {
            public static let method = "Runtime.addBinding"
            
            public let name: String
            public let executionContextName: String
            
            public struct Response: Decodable, Sendable {}
        }
        
        public struct RunIfWaitingForDebugger: CDP.Method {
            public static let method = "Runtime.runIfWaitingForDebugger"
            
            public struct Response: Decodable, Sendable {}
        }
    }
}
