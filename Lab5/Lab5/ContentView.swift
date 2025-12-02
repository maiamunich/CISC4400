import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                // 1) JSON URL  ------------
                NavigationLink(destination: CurrencyView()) {
                    Text("World Currency Abbreviations")
                        .font(.title3)
                        .padding(.bottom, 15)
                }

                // 2) JSON URL  ------------
                NavigationLink(destination: TodosView()) {
                    Text("TO DO LIST")
                        .font(.title3)
                        .padding(.bottom, 15)
                }

                // 3) NEW JSON URL  ------------  (changed here)
                NavigationLink(destination: PokemonView()) {
                    Text("Pokémon (PokéAPI)")
                        .font(.title3)
                        .padding(.bottom, 15)
                }

                // 4) NEW JSON URL  ------------
                NavigationLink(destination: CatFactView()) {
                    Text("Random Cat Fact")
                        .font(.title3)
                        .padding(.bottom, 15)
                }

                // 5) NEW JSON URL  ------------
                NavigationLink(destination: SpaceXLatestView()) {
                    Text("SpaceX Latest Launch")
                        .font(.title3)
                        .padding(.bottom, 15)
                }
            }
            .navigationTitle("JSON SAMPLE URLs")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View { ContentView() }
}
