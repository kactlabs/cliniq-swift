import SwiftUI

/// Container view that switches between login and registration
struct AuthenticationView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var showRegister: Bool = false
    
    var body: some View {
        Group {
            if showRegister {
                RegisterView(viewModel: viewModel, showRegister: $showRegister)
            } else {
                LoginView(viewModel: viewModel, showRegister: $showRegister)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showRegister)
    }
}

#Preview {
    AuthenticationView(viewModel: AuthViewModel())
}
