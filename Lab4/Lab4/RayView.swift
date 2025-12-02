import SwiftUI
struct RayView: View {
    @State private var info = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Image(systemName: "sparkles").font(.system(size: 46))

                if UIImage(named: "ray") != nil {
                    Image("ray").resizable().scaledToFit().frame(maxWidth: 320)
                }

                Text(info)
                    .frame(width: 300, height: 120, alignment: .leading)
                    .background(Color.green)
                    .foregroundColor(.black)

                Link("Learn more about Ray",
                     destination: URL(string: "https://disney.fandom.com/wiki/Ray_%28The_Princess_and_the_Frog%29")!)
                    .font(.headline)
            }
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Ray")
        .onAppear {
            info = "Ray (The Princess and the Frog) is the Cajun firefly—joyful, romantic, and the literal light of the bayou."
        }
    }
}

#Preview { NavigationStack { RayView() } }
