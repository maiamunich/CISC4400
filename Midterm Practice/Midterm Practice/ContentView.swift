//
//  ContentView.swift
//  Midterm Practice
//
//  Created by Maia Munich on 10/23/25.
//

import SwiftUI

struct ContentView: View {
    // Local, view-owned state
    @State private var rating: Int = 4
    @State private var isFavorite: Bool = false
    @State private var isExpanded: Bool = false

    var body: some View {
        ZStack{
            Color(.mint)
                .ignoresSafeArea()
            
            VStack (alignment: .leading, spacing: 20) {
                Image("face")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(16)
                
                HStack {
                    Text("Halloween Makeup")
                        .font(.title)
                        .bold()
                    
                    // Favorite toggle button using @State
                    Button {
                        isFavorite.toggle()
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(isFavorite ? .orange : .secondary)
                            .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    // Rating stack using @State
                    VStack {
                        HStack(spacing: 2) {
                            ForEach(1...5, id: \.self) { index in
                                Button {
                                    rating = index
                                } label: {
                                    Image(systemName: symbolForStar(at: index))
                                }
                                .buttonStyle(.plain)
                                .foregroundStyle(.orange)
                                .accessibilityLabel("Set rating to \(index)")
                            }
                        }
                        
                        Text("(Review 400)")
                    }
                    .foregroundStyle(.orange)
                    .font(.caption)
                }
                
                // Expandable description using @State
                Group {
                    if isExpanded {
                        Text("Fun Makeup to do for Halloween. This look uses safe, skin-friendly products and is great for parties, photos, and trick-or-treating. Tap 'Show less' to collapse.")
                    } else {
                        Text("Fun Makeup to do for Halloween.")
                    }
                }
                
                Button(isExpanded ? "Show less" : "Show more") {
                    isExpanded.toggle()
                }
                .font(.caption)
                
                HStack{
                    Image(systemName: "fork.knife")
                    Image(systemName: "binoculars.fill")
                }
                .foregroundStyle(.gray)
                .font(.caption)
            }
            .padding()
            .background() {
                Rectangle()
                    .foregroundStyle(.pink)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(radius: 15)
            }
            .padding()
        }
    }
    
    // Helper to choose star symbol based on current rating
    private func symbolForStar(at index: Int) -> String {
        if rating >= index {
            return "star.fill"
        } else {
            return "star"
        }
    }
}

#Preview {
    ContentView()
}
