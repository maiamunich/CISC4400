import SwiftUI
import Supabase
import Auth

@main
struct SafeClaimApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .onOpenURL { url in
                    SupabaseManager.shared.client.auth.handle(url)
                    print("Received deep link:", url.absoluteString)
                }
        }
    }
}
