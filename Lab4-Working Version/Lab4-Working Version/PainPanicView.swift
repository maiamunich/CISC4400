//
//  PainPanicView.swift
//  Lab4-Working Version
//
//  Created by Maia Munich on 10/11/25.
//

import SwiftUI

struct PainPanicView: View {
    @State private var info = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Image(systemName: "bolt.fill").font(.system(size: 46))
                Image("PainPanic")
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
        .navigationTitle("Pain & Panic")
        .onAppear {
            info = "Pain & Panic (Hercules) are Hades’ chaotic minions—bumbling, funny, and always in over their heads."
        }
    }
}

#Preview { NavigationStack { PainPanicView() } }
