import SwiftUI

/// Registration view for creating new accounts
struct RegisterView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Binding var showRegister: Bool
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    
    // Brand colors
    private let primaryTeal = Color(red: 0.2, green: 0.6, blue: 0.5)
    private let lightTeal = Color(red: 0.4, green: 0.75, blue: 0.65)
    private let backgroundGradientTop = Color(red: 0.85, green: 0.95, blue: 0.93)
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [backgroundGradientTop, Color.white]),
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Logo section
                    logoSection
                    
                    // Tab selector
                    tabSelector
                    
                    // Welcome text
                    welcomeSection
                    
                    // Form fields
                    formSection
                    
                    // Create Account button
                    createAccountButton
                    
                    // Or sign up with
                    socialSignUpSection
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    // MARK: - Logo Section
    private var logoSection: some View {
        VStack(spacing: 8) {
            // Robot mascot
            Image(systemName: "person.crop.circle.badge.checkmark")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(primaryTeal)
                .padding(.top, 40)
            
            // ClinIQ text
            HStack(spacing: 0) {
                Text("Clin")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(primaryTeal)
                Text("IQ")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(lightTeal)
            }
        }
        .padding(.bottom, 24)
    }
    
    // MARK: - Tab Selector
    private var tabSelector: some View {
        HStack(spacing: 0) {
            // Create Account tab (selected)
            Text("Create Account")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(primaryTeal)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .overlay(
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(primaryTeal),
                    alignment: .bottom
                )
            
            // Log In tab
            Button(action: { showRegister = false }) {
                Text("Log In")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
        }
        .padding(.bottom, 24)
    }
    
    // MARK: - Welcome Section
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Get Started")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
            
            Text("Create an account to access all features of ClinIQ.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 24)
    }
    
    // MARK: - Form Section
    private var formSection: some View {
        VStack(spacing: 16) {
            // Email field
            VStack(alignment: .leading, spacing: 4) {
                Text("Email")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(.leading, 12)
                
                TextField("", text: $email)
                    .textFieldStyle(PlainTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(primaryTeal, lineWidth: 1.5)
                    )
            }
            
            // Password field
            VStack(alignment: .leading, spacing: 4) {
                Text("Password")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(.leading, 12)
                
                HStack {
                    if isPasswordVisible {
                        TextField("", text: $password)
                            .textFieldStyle(PlainTextFieldStyle())
                    } else {
                        SecureField("", text: $password)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    
                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                
                Text("Password must be at least 8 characters")
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                    .padding(.leading, 12)
            }
            
            // Confirm Password field
            VStack(alignment: .leading, spacing: 4) {
                Text("Confirm Password")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(.leading, 12)
                
                HStack {
                    if isConfirmPasswordVisible {
                        TextField("", text: $confirmPassword)
                            .textFieldStyle(PlainTextFieldStyle())
                    } else {
                        SecureField("", text: $confirmPassword)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    
                    Button(action: { isConfirmPasswordVisible.toggle() }) {
                        Image(systemName: isConfirmPasswordVisible ? "eye" : "eye.slash")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
            
            // Error message
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.system(size: 12))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.bottom, 24)
    }
    
    // MARK: - Create Account Button
    private var createAccountButton: some View {
        Button(action: {
            Task {
                await viewModel.register(
                    email: email,
                    password: password,
                    confirmPassword: confirmPassword
                )
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(primaryTeal)
                    .frame(height: 50)
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Create Account")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
        }
        .disabled(viewModel.isLoading)
        .padding(.bottom, 16)
    }
    
    // MARK: - Social Sign Up
    private var socialSignUpSection: some View {
        VStack(spacing: 12) {
            Text("Or sign up with")
                .font(.system(size: 12))
                .foregroundColor(.gray)
            
            // Google button
            Button(action: {}) {
                HStack {
                    Image(systemName: "g.circle.fill")
                        .foregroundColor(.red)
                    Text("Continue with Google")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
            
            // Apple button
            Button(action: {}) {
                HStack {
                    Image(systemName: "apple.logo")
                        .foregroundColor(.black)
                    Text("Continue with Apple")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }
}

#Preview {
    RegisterView(viewModel: AuthViewModel(), showRegister: .constant(true))
}
