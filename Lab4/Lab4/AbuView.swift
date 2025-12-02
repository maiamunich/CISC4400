import SwiftUI

struct AbuView: View {
    @State private var info = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Image(systemName: "leaf.fill").font(.system(size: 46))
                if UIImage(named: "abu") != nil {
                    Image("abu").resizable().scaledToFit().frame(maxWidth: 320)
                }
                Text(info)
                    .frame(width: 300, height: 120, alignment: .leading)
                    .background(Color.green).foregroundColor(.black)
                Link("Learn more about Abu",
                     destination: URL(string: "https://disney.fandom.com/wiki/Abu")!)
                    .font(.headline)
            }
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Abu")
        .onAppear {
            info = "Abu (Aladdin) is the quick-fingered monkey—mischievous, loyal to a fault, and always ready for an adventure."
        }
    }
}

#Preview { NavigationStack { AbuView() } }
