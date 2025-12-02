//
//  GusView.swift
//  Lab4-Working Version
//
//  Created by Maia Munich on 10/11/25.
//
import SwiftUI

struct GusView: View {
    @State private var info = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Image(systemName: "circle.grid.2x1.left.filled")
                    .font(.system(size: 46))

                Image("Gus")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 320)

                // Keep Text inside the VStack
                Text(info)
                    .frame(width: 300, alignment: .leading)
                    .padding(.vertical, 8)
                    .background(Color.green)
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true) 
                    .font(.headline)
            }
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Gus-Gus")
        .onAppear {
            info = "Gus-Gus (Cinderella) is the lovable mouse with a big appetite and bigger heart—comic mishaps, loyal friend to Cindy."
        }
    }
}

#Preview { NavigationStack { GusView() } }
