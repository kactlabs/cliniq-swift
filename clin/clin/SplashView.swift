import SwiftUI

/// Splash/Welcome screen with robot mascot and Get Started button
struct SplashView: View {
    @Binding var showGetStarted: Bool
    
    // Brand colors
    private let primaryTeal = Color(red: 0.2, green: 0.75, blue: 0.7)
    private let moonWhite = Color(red: 0.98, green: 0.98, blue: 0.96)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Moon white background
                moonWhite
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Robot doctor mascot image - centered and large
                    Image("cliniq_mascot")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.85)
                        .frame(maxHeight: geometry.size.height * 0.65)
                        .frame(maxWidth: .infinity)
                        .padding(.top, geometry.size.height * 0.08)
                    
                    Spacer()
                    
                    // Get Started Button
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showGetStarted = true
                        }
                    }) {
                        Text("Get Started")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(primaryTeal)
                            )
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 40)
                }
            }
        }
    }
}

#Preview {
    SplashView(showGetStarted: .constant(false))
}
