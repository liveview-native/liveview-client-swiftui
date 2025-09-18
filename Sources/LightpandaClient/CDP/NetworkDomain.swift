extension CDP {    
    public struct Network {
        // Methods
        
        public struct Enable: CDP.Method {
            public static let method = "Network.enable"
            
            public let maxPostDataSize: Int
            public let reportDirectSocketTraffic: Bool
            
            public struct Response: Decodable, Sendable {}
        }
    }
}
