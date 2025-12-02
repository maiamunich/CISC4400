import SwiftUI

struct SebastianView: View {
    @State private var info = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Image(systemName: "tortoise.fill").font(.system(size: 46))
                if UIImage(named: "sebastian") != nil {
                    Image("sebastian").resizable().scaledToFit().frame(maxWidth: 320)
                }
                Text(info)
                    .frame(width: 300, height: 120, alignment: .leading)
                    .background(Color.green).foregroundColor(.black)
                Link("Learn more about Sebastian",
                     destination: URL(string: "https://disney.fandom.com/wiki/Sebastian")!)
                    .font(.headline)
            }
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Sebastian")
        .onAppear {
            info = "Sebastian (The Little Mermaid) is King Triton’s court composer—rule-following but warm-hearted, with iconic musical moments."
        }
    }
}

#Preview { NavigationStack { SebastianView() } }
