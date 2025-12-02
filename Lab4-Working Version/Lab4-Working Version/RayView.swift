//
//  RayView.swift
//  Lab4-Working Version
//
//  Created by Maia Munich on 10/11/25.
//

import SwiftUI
struct RayView: View {
    @State private var info = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Image(systemName: "sparkles").font(.system(size: 46))

                Image("Ray")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 320)

                Text(info)
                    .frame(width: 300, height: 120, alignment: .leading)
                    .background(Color.green)
                    .foregroundColor(.black)
                    .font(.headline)
            }
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Ray")
        .onAppear {
            info = "Ray (The Princess and the Frog) is the Cajun firefly—joyful, romantic, and the literal light of the bayou."
        }
    }
}

#Preview { NavigationStack { RayView() } }
