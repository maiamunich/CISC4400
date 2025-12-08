import SwiftUI
import Supabase

struct AuthView: View {
    let onAuthenticated: () -> Void

    @Environment(\.dismiss) private var dismiss
    
    @State private var isLoginMode: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    @State private var isLoading: Bool = false
    @State private var authError: String?
    @State private var successMessage: String?

    init(startInLoginMode: Bool = false,
         onAuthenticated: @escaping () -> Void) {
        self.onAuthenticated = onAuthenticated
        _isLoginMode = State(initialValue: startInLoginMode)
    }

    var body: some View {
        VStack(spacing: 24) {
            // Title
            VStack(spacing: 4) {
                Text(isLoginMode ? "Welcome back" : "Create an account")
                    .font(.system(size: 28, weight: .bold))

                Text(
                    isLoginMode
                    ? "Log in to manage your SafeClaim account."
                    : "Sign up to file and track claims securely, and get important news"
                )
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            }
            .padding(.top, 32)

            // Segmented control
            Picker("", selection: $isLoginMode) {
                Text("Log In").tag(true)
                Text("Sign Up").tag(false)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            // Form
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Email")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    TextField("you@example.com", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Password")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    SecureField("Enter your password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }

                if !isLoginMode {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Confirm Password")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        SecureField("Re-enter your password", text: $confirmPassword)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal)

            // Primary button
            Button {
                Task {
                    await handleAuth()
                }
            } label: {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    Text(isLoginMode ? "Log In" : "Sign Up")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .disabled(isLoading)

            // Error / success messages
            if let authError {
                Text(authError)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
            } else if let successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
                    .font(.footnote)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
            }

            if isLoginMode {
                Button {
                    print("Forgot password tapped")
                } label: {
                    Text("Forgot your password?")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.orange)
                }
                .padding(.top, 4)
            }

            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("SafeClaim")
                    .font(.headline)
            }
        }
    }

    // MARK: - Password validation (sign up only)

    func isPasswordValid(_ password: String) -> Bool {
        guard password.count >= 10 else { return false }
        let uppercase = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*")
        let lowercase = NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*")
        let digit = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*")
        let special = NSPredicate(format: "SELF MATCHES %@", ".*[^A-Za-z0-9].*")
        return uppercase.evaluate(with: password)
            && lowercase.evaluate(with: password)
            && digit.evaluate(with: password)
            && special.evaluate(with: password)
    }

    // MARK: - Auth logic

    @MainActor
    func handleAuth() async {
        authError = nil
        successMessage = nil

        guard !email.isEmpty, !password.isEmpty else {
            authError = "Please fill in all fields."
            return
        }

        if !isLoginMode {
            if !isPasswordValid(password) {
                authError = """
                Password must be at least 10 characters long,
                contain one uppercase letter, one lowercase letter,
                one number, and one special character.
                """
                return
            }

            if password != confirmPassword {
                authError = "Passwords do not match."
                return
            }
        }

        isLoading = true
        defer { isLoading = false }

        let client = SupabaseManager.shared.client

        do {
            if isLoginMode {
                print("➡️ Attempting Supabase signIn")
                _ = try await client.auth.signIn(
                    email: email,
                    password: password
                )
                print("✅ Login succeeded")

                // 1) Tell RootView "user is authenticated"
                onAuthenticated()

                // 2) Pop AuthView off the NavigationStack (like tapping the back arrow)
                dismiss()
            } else {
                print("➡️ Attempting Supabase signUp")
                _ = try await client.auth.signUp(
                    email: email,
                    password: password
                )
                successMessage = "Account created! Please check your email."
            }

        } catch {
            print("❌ Auth error:", error.localizedDescription)
            authError = error.localizedDescription
        }
    }
}
