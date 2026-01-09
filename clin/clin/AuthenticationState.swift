import Foundation

/// Enum representing the current authentication state of the application
enum AuthenticationState: Equatable {
    /// No user is currently logged in
    case unauthenticated
    
    /// Authentication process is in progress (login/register)
    case authenticating
    
    /// User is successfully authenticated with user data
    case authenticated(User)
    
    /// Computed property to check if user is authenticated
    var isAuthenticated: Bool {
        switch self {
        case .authenticated:
            return true
        case .unauthenticated, .authenticating:
            return false
        }
    }
    
    /// Computed property to get the current user if authenticated
    var currentUser: User? {
        switch self {
        case .authenticated(let user):
            return user
        case .unauthenticated, .authenticating:
            return nil
        }
    }
    
    /// Computed property to check if authentication is in progress
    var isLoading: Bool {
        switch self {
        case .authenticating:
            return true
        case .unauthenticated, .authenticated:
            return false
        }
    }
}