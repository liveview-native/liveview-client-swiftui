extension CDP {
    public struct Inspector {
        // Methods
        
        public struct Enable: CDP.Method {
            public static let method = "Inspector.enable"
            
            public struct Response: Decodable, Sendable {}
        }
    }
}
