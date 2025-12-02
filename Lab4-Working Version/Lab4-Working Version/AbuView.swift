//
//  AbuView.swift
//  Lab4-Working Version
//
//  Created by Maia Munich on 10/11/25.
//

import SwiftUI

struct AbuView: View {
    @State private var info = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Image(systemName: "leaf.fill").font(.system(size: 46))
                Image("Abu")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 320)
                Text(info)
                    .frame(width: 300, height: 120, alignment: .leading)
                    .background(Color.green).foregroundColor(.black)
                    .font(.headline)
            }
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Abu")
        .onAppear {
            info = "Abu (Aladdin) is the quick-fingered monkey—mischievous, loyal to a fault, and always ready for an adventure."
        }
    }
}

#Preview { NavigationStack { AbuView() } }
