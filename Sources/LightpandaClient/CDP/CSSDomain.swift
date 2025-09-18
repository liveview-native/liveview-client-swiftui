extension CDP {
    public struct CSS {
        // Methods
        
        public struct Enable: CDP.Method {
            public static let method = "CSS.enable"
            
            public struct Response: Decodable, Sendable {}
        }
    }
}
