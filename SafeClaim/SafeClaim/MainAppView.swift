import SwiftUI

struct MainAppView: View {
    enum Screen {
        case claims
        case insurance
        case settings
    }

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
                        SettingsView()
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
                    isOpen: $isMenuOpen
                )
                .frame(width: 260)
                .transition(AnyTransition.move(edge: .leading))
            }
        }
    }
}

// MARK: - Side menu

struct SideMenu: View {
    @Binding var currentScreen: MainAppView.Screen
    @Binding var isOpen: Bool

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
                    currentScreen = .settings
                    isOpen = false
                }
            } label: {
                Label("Settings", systemImage: "gearshape.fill")
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

// MARK: - Simple placeholder so .settings compiles

struct SettingsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Settings")
                .font(.title.bold())
            Text("Settings coming soon.")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Settings")
    }
}
