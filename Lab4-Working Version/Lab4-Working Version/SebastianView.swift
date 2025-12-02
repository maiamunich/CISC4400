//
//  SebastianView.swift
//  Lab4-Working Version
//
//  Created by Maia Munich on 10/11/25.
//

import SwiftUI

struct SebastianView: View {
    @State private var info = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Image(systemName: "tortise.fill").font(.system(size: 46))
                Image("Sebastian")
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
        .navigationTitle("Sebastian")
        .onAppear {
            info = "Sebastian (The Little Mermaid) is King Triton’s court composer—rule-following but warm-hearted, with iconic musical moments."
        }
    }
}

#Preview { NavigationStack { SebastianView() } }
