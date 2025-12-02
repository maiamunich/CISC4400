//
//  ContentView.swift
//  Lab4-Working Version
//
//  Created by Maia Munich on 10/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.lightGray).ignoresSafeArea()
                VStack(spacing: 22) {
                    NavigationLink("Timon") { TimonView() }.navButtonStyle()
                    NavigationLink("Pascal") { PascalView() }.navButtonStyle()
                    NavigationLink("Gus-Gus") { GusView() }.navButtonStyle()
                    NavigationLink("Mushu") { MushuView() }.navButtonStyle()
                    NavigationLink("Abu") { AbuView() }.navButtonStyle()
                    NavigationLink("Sebastian") { SebastianView() }.navButtonStyle()
                    NavigationLink("Pain & Panic") { PainPanicView() }.navButtonStyle()
                    NavigationLink("Ray") { RayView() }.navButtonStyle()
                }
                .padding(.horizontal, 16)
                .navigationTitle("Disney Side Characters")
            }
        }
    }
}

fileprivate extension View {
    func navButtonStyle() -> some View {
        self.font(.title2)
            .foregroundColor(.black)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview { ContentView() }
