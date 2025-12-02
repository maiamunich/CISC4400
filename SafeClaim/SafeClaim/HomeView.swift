import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Welcome to SafeClaim")
                .font(.title.bold())

            NavigationLink {
                ClaimView()
            } label: {
                Label("Make a Claim", systemImage: "doc.text.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
            }

            NavigationLink {
                InsuranceView()
            } label: {
                Label("Insurance Info", systemImage: "shield.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
            }

            NavigationLink {
                SettingsView()
            } label: {
                Label("Settings", systemImage: "gearshape.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Home")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView()
        }
    }
}
