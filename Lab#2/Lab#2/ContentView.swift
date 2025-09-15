//
//  ContentView.swift
//  Lab#2
//
//  Created by Maia Munich on 9/12/25.
//

import SwiftUI

struct ContentView: View {
    @State var companyName: String = ""
    var body: some View {
        ZStack {
            Color(.purple)
                .ignoresSafeArea()
            
            VStack{
                Text("Data Entry Form")
                    .font(.largeTitle)
                TextField("Enter Company Name", text:$companyName)
                    .padding()
                    .font(.largeTitle)
                Button {
                    Task{
                        validateInputData()
                    }
                }label:{
                    Text("SUBMIT IT HERE BITCH")
                        .padding()
                        .foregroundColor(.black)
                        .background()
                } //end button
            } // End VStack
        } //End ZStack
    } //End Body
    func validateInputData(){
        if companyName.count < 5 {
            print ("Company Name is Invalid!")
            return
        }
        
        print( "all okay!")
    }
#Preview {
        ContentView()
}
