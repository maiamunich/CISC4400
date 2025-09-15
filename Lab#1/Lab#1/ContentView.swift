//
//  ContentView.swift
//  Lab#1
//
//  Created by Maia Munich on 9/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Image("MyPicture1")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        VStack {
            Text("Crying Sky")
                .font(.title2).bold()
                .foregroundStyle(.black.opacity(0.8))
                .padding(.top, 8)
            Spacer()
            
            HStack(spacing: 16){
                VStack(spacing: 8){
                    Image(systemName: "moon.stars.fill")
                        .resizable().scaledToFit()
                        .frame(width: 70, height: 70)
                        .padding(12)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    Text("Moon")
                        .font(.caption).bold()
                }
                VStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .resizable().scaledToFit()
                        .frame(width: 70, height: 70)
                        .padding(12)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    Text("Star")
                        .font(.caption).bold()
                }

                VStack(spacing: 8) {
                        Image(systemName:"cloud.moon.fill")
                            .resizable().scaledToFit()
                            .frame(width: 70, height: 70)
                            .padding(12)
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        Text("Night")
                            .font(.caption).bold()
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            // Bottom
            Text("Footer or instructions go here")
                .font(.footnote)
                .foregroundStyle(.black.opacity(0.8))
                .padding(.bottom, 12)
            }
            // Make the foregound fill the screen so Spacers can push top/bottom
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }

#Preview { ContentView() }
