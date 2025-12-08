import SwiftUI

struct MainAppView: View {
    enum Screen {
        case claims
        case insurance
        case settings
        case vault
    }

    let onLogout: () -> Void   // 👈 needed by RootView

    @State private var currentScreen: Screen = .claims
    @State private var isMenuOpen: Bool = false

    var body: some View {
        ZStack {
            // Main navigation area
            NavigationStack {
                Group {
                    switch currentScreen {
                    case .claims:
                        ClaimView()
                    case .insurance:
                        InsuranceView()
                    case .settings:
                        SettingsView(onLogout: onLogout)
                    case.vault:
                        VaultView()
                    }
                }
                .toolbar {
                    // Hamburger button on every page
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            withAnimation(.easeInOut) {
                                isMenuOpen.toggle()
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal")
                        }
                    }

                    ToolbarItem(placement: .principal) {
                        Text("SafeClaim")
                            .font(.headline)
                    }
                }
            }

            // Dimmed background when menu is open
            if isMenuOpen {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            isMenuOpen = false
                        }
                    }
            }

            // Side menu
            if isMenuOpen {
                SideMenu(
                    currentScreen: $currentScreen,
                    isOpen: $isMenuOpen,
                    onLogout: onLogout
                )
                .frame(width: 260)
                .transition(.move(edge: .leading))
            }
        }
    }
}
