import SwiftUI

struct MushuView: View {
    @State private var info = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Image(systemName: "flame.fill").font(.system(size: 46))
                if UIImage(named: "mushu") != nil {
                    Image("mushu").resizable().scaledToFit().frame(maxWidth: 320)
                }
                Text(info)
                    .frame(width: 300, height: 120, alignment: .leading)
                    .background(Color.green).foregroundColor(.black)
                Link("Learn more about Mushu",
                     destination: URL(string: "https://disney.fandom.com/wiki/Mushu")!)
                    .font(.headline)
            }
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Mushu")
        .onAppear {
            info = "Mushu (Mulan) is the pint-sized guardian dragon—sarcastic, brave when it counts, and fiercely protective of Mulan."
        }
    }
}

#Preview { NavigationStack { MushuView() } }
