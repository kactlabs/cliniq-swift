import Foundation

/// Enum representing various validation errors that can occur during authentication
enum ValidationError: Error, Equatable, LocalizedError {
    /// Email format is incorrect
    case invalidEmail
    
    /// Password doesn't meet strength requirements
    case weakPassword
    
    /// Password confirmation doesn't match the original password
    case passwordMismatch
    
    /// Email is already registered in the system
    case userExists
    
    /// Login credentials are incorrect
    case invalidCredentials
    
    /// Empty or missing required field
    case emptyField(String)
    
    /// Custom validation error with message
    case custom(String)
    
    /// User-friendly error descriptions
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address"
        case .weakPassword:
            return "Password must be at least 8 characters long"
        case .passwordMismatch:
            return "Passwords do not match"
        case .userExists:
            return "An account with this email already exists"
        case .invalidCredentials:
            return "Invalid email or password"
        case .emptyField(let fieldName):
            return "\(fieldName) is required"
        case .custom(let message):
            return message
        }
    }
    
    /// Localized description for the error
    var localizedDescription: String {
        return errorDescription ?? "An unknown error occurred"
    }
}