//
//  PokemonView.swift
//  Lab5
//
//  Created by Maia Munich on 10/17/25.
//

import SwiftUI

// MARK: - Models
struct PokemonListResponse: Decodable {
    let results: [PokemonEntry]
}

struct PokemonEntry: Decodable, Identifiable {
    var id: String { name }   // use name as a stable id
    let name: String
    let url: String
}

// MARK: - View
struct PokemonView: View {
    @State private var pokemon: [PokemonEntry] = []
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            Group {
                if let msg = errorMessage {
                    Text(msg).foregroundColor(.red)
                } else {
                    List(pokemon) { p in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(p.name.capitalized)
                                .font(.headline)
                                .foregroundColor(.cyan)
                            Text(p.url)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Pokémon (first 50)")
            .task { await fetchPokemon() }
        }
    }

    // MARK: - Networking
    func fetchPokemon() async {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=50") else {
            errorMessage = "Bad URL"; return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(PokemonListResponse.self, from: data)
            pokemon = decoded.results
        } catch {
            errorMessage = "Failed to load: \(error.localizedDescription)"
        }
    }
}

struct PokemonView_Previews: PreviewProvider {
    static var previews: some View { PokemonView() }
}
