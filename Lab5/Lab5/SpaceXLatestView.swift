//
//  SpaceXLatestView.swift
//  Lab5
//
//  Created by Maia Munich on 10/17/25.
//

import SwiftUI

struct SpaceXLaunch: Decodable {
    let name: String
    let dateUtc: Date
    let success: Bool?
}

struct SpaceXLatestView: View {
    @State private var launch: SpaceXLaunch?
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 12) {
                if let launch = launch {
                    Text(launch.name)
                        .font(.title3)
                        .foregroundColor(.cyan)

                    Text("Date (UTC): \(formatted(date: launch.dateUtc))")
                        .foregroundColor(.indigo)

                    Text("Success: \(launch.success == true ? "Yes" : "No / Unknown")")
                        .foregroundColor(.red)
                } else if let msg = errorMessage {
                    Text(msg)
                        .foregroundColor(.red)
                } else {
                    Text("Loading…")
                }
                Spacer()
            }
            .padding()
            .navigationTitle("SpaceX Latest")
            .task { await fetchLatest() }
        }
    }

    func fetchLatest() async {
        guard let url = URL(string: "https://api.spacexdata.com/v4/launches/latest") else {
            errorMessage = "Bad URL"; return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let dec = JSONDecoder()
            dec.keyDecodingStrategy = .convertFromSnakeCase
            dec.dateDecodingStrategy = .iso8601
            launch = try dec.decode(SpaceXLaunch.self, from: data)
        } catch {
            errorMessage = "Failed to load: \(error.localizedDescription)"
        }
    }

    func formatted(date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm:ss"
        f.timeZone = TimeZone(secondsFromGMT: 0)
        return f.string(from: date)
    }
}

struct SpaceXLatestView_Previews: PreviewProvider {
    static var previews: some View { SpaceXLatestView() }
}
