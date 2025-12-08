import SwiftUI
import Supabase

struct RootView: View {
    @State private var isAuthenticated = false

    var body: some View {
        NavigationStack {
            if isAuthenticated {
                MainAppView(onLogout: {
                    print("🔴 RootView: user logged out")
                    isAuthenticated = false
                })
            } else {
                CoverView(onAuthenticated: {
                    print("✅ RootView: onAuthenticated called")
                    isAuthenticated = true
                })
            }
        }
    }
}
