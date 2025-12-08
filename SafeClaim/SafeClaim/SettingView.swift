import SwiftUI
import Supabase

struct SettingsView: View {
    let onLogout: () -> Void

    @State private var isLoggingOut = false
    @State private var errorMessage: String?

    @State private var showSupportAlert = false
    @State private var showPrivacyAlert = false

    var body: some View {
        Form {
            // MARK: - Account section
            Section(header: Text("Account")) {
                HStack {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 32))
                        .foregroundColor(.orange)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Signed in")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text("SafeClaim user")
                            .font(.headline)
                    }
                }
            }

            // MARK: - App section
            Section(header: Text("App")) {
                Toggle(isOn: .constant(true)) {
                    Text("Notifications")
                }
                .disabled(true)

                Toggle(isOn: .constant(false)) {
                    Text("Use cellular data")
                }
                .disabled(true)
            }

            // MARK: - Support
            Section(header: Text("Support")) {
                Button {
                    showSupportAlert = true
                } label: {
                    Label("Contact Support", systemImage: "envelope")
                }

                Button {
                    showPrivacyAlert = true
                } label: {
                    Label("Privacy Policy", systemImage: "doc.text.magnifyingglass")
                }
            }

            // MARK: - Logout
            Section {
                Button(role: .destructive) {
                    Task { await handleLogout() }
                } label: {
                    if isLoggingOut {
                        HStack {
                            ProgressView()
                            Text("Logging out…")
                        }
                    } else {
                        Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }

            if let errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .navigationTitle("Settings")
        // Contact support alert
        .alert("Contact Support", isPresented: $showSupportAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please email us at mmunich@fordham.edu.")
        }
        // Privacy policy alert
        .alert("Coming Soon", isPresented: $showPrivacyAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("The privacy policy will be available in a future update.")
        }
    }

    // MARK: - Logout logic

    @MainActor
    private func handleLogout() async {
        isLoggingOut = true
        errorMessage = nil
        defer { isLoggingOut = false }

        let client = SupabaseManager.shared.client

        do {
            try await client.auth.signOut()
            onLogout()
        } catch {
            print("❌ Logout error:", error.localizedDescription)
            errorMessage = error.localizedDescription
        }
    }
}
