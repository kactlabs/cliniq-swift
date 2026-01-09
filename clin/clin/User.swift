import Foundation

/// User model representing an authenticated user in the ClinIQ system
struct User: Identifiable, Codable, Equatable {
    /// Unique identifier for the user
    let id: UUID
    
    /// User's email address (used as username)
    let email: String
    
    /// Account creation timestamp
    let createdAt: Date
    
    /// Initialize a new user with email
    /// - Parameter email: The user's email address
    init(email: String) {
        self.id = UUID()
        self.email = email
        self.createdAt = Date()
    }
    
    /// Initialize a user with all properties (for decoding)
    /// - Parameters:
    ///   - id: Unique identifier
    ///   - email: User's email address
    ///   - createdAt: Account creation date
    init(id: UUID, email: String, createdAt: Date) {
        self.id = id
        self.email = email
        self.createdAt = createdAt
    }
}