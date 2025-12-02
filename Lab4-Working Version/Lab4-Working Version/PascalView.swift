//
//  PascalView.swift
//  Lab4-Working Version
//
//  Created by Maia Munich on 10/11/25.
//

import SwiftUI

struct PascalView: View {
    @State private var info = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Image(systemName: "paintpalette.fill").font(.system(size: 46))
                Image("Pascal")
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
        .navigationTitle("Pascal")
        .onAppear {
            info = "Pascal (Tangled) is Rapunzel’s chameleon confidant—tiny but fierce, often the moral compass with superb side-eye."
        }
    }
}

#Preview { NavigationStack { PascalView() } }
