//
//  CatFactView.swift
//  Lab5
//
//  Created by Maia Munich on 10/17/25.
//

import SwiftUI

struct CatFactResponse: Decodable {
    let fact: String
    let length: Int
}

struct CatFactView: View {
    @State private var fact: String = "Loading…"

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text(fact)
                    .font(.body)
                    .padding()

                Button("Fetch New Fact") {
                    Task { await fetchFact() }
                }
                .padding(.top, 8)

                Spacer()
            }
            .padding()
            .navigationTitle("Cat Fact")
            .task { await fetchFact() }
        }
    }

    func fetchFact() async {
        guard let url = URL(string: "https://catfact.ninja/fact") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decoded = try? JSONDecoder().decode(CatFactResponse.self, from: data) {
                fact = decoded.fact
            } else {
                fact = "Could not decode fact."
            }
        } catch {
            fact = "Network error: \(error.localizedDescription)"
        }
    }
}

struct CatFactView_Previews: PreviewProvider {
    static var previews: some View { CatFactView() }
}
