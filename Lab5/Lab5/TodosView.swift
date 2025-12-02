//
//  TodosView.swift
//  Lab5
//
//  Created by Maia Munich on 10/17/25.
//

import SwiftUI

struct Todo: Decodable {
    var userId:      Int
    var id:          Int
    var title:       String
    var completed:   Bool
}

struct TodosView: View {
    @State private var todos = [Todo]()
    
    var body: some View {
        NavigationView {
            List(todos, id: \.id) { t in
                VStack (alignment: .leading) {
                    Text(String(t.id))
                        .font(.headline)
                        .foregroundColor(.cyan)
                    Text(t.title)
                        .font(.body)
                        .foregroundColor(.indigo)
                    Text(String(t.completed))
                        .font(.body)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Todo List")
            .task {
                await fetchTodoData()
            }
        }
    }
    
    
    func fetchTodoData() async {
        // create the URL
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {
            print("Hey Man, THIS URL DOES NOT WORK!")
            return
        }
        
        // fetch the data
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // decode that data
            if let decodedResponse = try? JSONDecoder().decode([Todo].self, from: data) {
                todos = decodedResponse
            }
        } catch {
            print("Bad news ... This data is not valid :-(")
        }
        
        // ecode the data
    }
}


struct TodosView_Previews: PreviewProvider {
    static var previews: some View {
        TodosView()
    }
}








