import SwiftUI

struct TimonView: View {
    @State private var info = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Image(systemName: "pawprint.fill").font(.system(size: 46))

                if UIImage(named: "timon") != nil {
                    Image("timon").resizable().scaledToFit().frame(maxWidth: 320)
                }

                Text(info)
                    .frame(width: 300, height: 120, alignment: .leading)
                    .background(Color.green)
                    .foregroundColor(.black)

                Link("Learn more about Timon",
                     destination: URL(string: "https://disney.fandom.com/wiki/Timon")!)
                    .font(.headline)
            }
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Timon")
        .onAppear {
            info = "Timon the meerkat (The Lion King) is half of the Hakuna Matata duo—fast-talking, loyal, and comic relief with real heart."
        }
    }
}
#Preview { NavigationStack { TimonView() } }
