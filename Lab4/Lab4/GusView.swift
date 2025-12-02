import SwiftUI

struct GusView: View {
    @State private var info = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Image(systemName: "circle.grid.2x1.left.filled").font(.system(size: 46))
                if UIImage(named: "gus") != nil {
                    Image("gus").resizable().scaledToFit().frame(maxWidth: 320)
                }
                Text(info)
                    .frame(width: 300, height: 120, alignment: .leading)
                    .background(Color.green).foregroundColor(.black)
                Link("Learn more about Gus-Gus",
                     destination: URL(string: "https://disney.fandom.com/wiki/Gus_(Cinderella)")!)
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
