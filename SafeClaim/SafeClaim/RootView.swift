import SwiftUI
import Supabase
import Auth

struct RootView: View {
    @State private var isAuthenticated: Bool = false

    var body: some View {
        NavigationStack {
            if isAuthenticated {
                HomeView()
            } else {
                CoverView {
                    // Called when AuthView says “user is logged in”
                    isAuthenticated = true
                }
            }
        }
    }
}
