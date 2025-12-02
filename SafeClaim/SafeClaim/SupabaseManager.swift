import SwiftUI
import Supabase

final class SupabaseManager {
    static let shared = SupabaseManager()

    let client: SupabaseClient

    private init() {
        let url = URL(string: "https://putncdycfznfcykssveo.supabase.co")!
        let key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB1dG5jZHljZnpuZmN5a3NzdmVvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3NjUxMjIsImV4cCI6MjA3OTM0MTEyMn0.vp8SOQIIM2zdiSZt8KHEv7kC_sjV7Q-xSu809n-i0r8"
        client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: key
        )
    }
}
