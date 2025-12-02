import SwiftUI

struct CoverView: View {
    /// Called when the user successfully authenticates
    let onAuthenticated: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.orange.opacity(0.9),
                    Color.orange.opacity(0.6),
                    Color.blue.opacity(0.7)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 250, height: 250)

                    Image("icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                }
                
                VStack(spacing: 8) {
                    Text("SafeClaim")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Secure, simple, and transparent insurance claims.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    NavigationLink {
                        AuthView(
                            startInLoginMode: false,
                            onAuthenticated: onAuthenticated
                        )
                    } label: {
                        Text("Get Started")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(Color.orange)
                            .cornerRadius(14)
                            .shadow(radius: 4, y: 2)
                    }
                    
                    NavigationLink {
                        AuthView(
                            startInLoginMode: true,
                            onAuthenticated: onAuthenticated
                        )
                    } label: {
                        Text("I already have an account")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
    }
}

// Previews
struct CoverView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CoverView {
                // preview
            }
        }
    }
}
