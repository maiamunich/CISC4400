import SwiftUI

struct SideMenu: View {
    @Binding var currentScreen: MainAppView.Screen
    @Binding var isOpen: Bool
    let onLogout: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Menu")
                .font(.title2.bold())
                .padding(.top, 40)

            Button {
                withAnimation(.easeInOut) {
                    currentScreen = .claims
                    isOpen = false
                }
            } label: {
                Label("Make a Claim", systemImage: "doc.text.fill")
            }

            Button {
                withAnimation(.easeInOut) {
                    currentScreen = .insurance
                    isOpen = false
                }
            } label: {
                Label("Insurance Info", systemImage: "shield.fill")
            }

            Button {
                withAnimation(.easeInOut) {
                    currentScreen = .vault
                    isOpen = false
                }
            } label: {
                Label("Vault", systemImage: "lock.rectangle")
            }
            
            Button {
                withAnimation(.easeInOut) {
                    currentScreen = .settings
                    isOpen = false
                }
            } label: {
                Label("Settings", systemImage: "gearshape.fill")
            }

            Divider()
                .padding(.vertical, 8)

            Button(role: .destructive) {
                withAnimation(.easeInOut) {
                    isOpen = false
                }
                onLogout()
            } label: {
                Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(
            Color(.systemBackground)
                .shadow(radius: 8)
        )
    }
}
