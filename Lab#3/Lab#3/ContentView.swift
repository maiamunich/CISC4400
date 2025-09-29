//
//  ContentView.swift
//  randomCards
//

import SwiftUI

struct ContentView: View {
    
    @State private var card1:String = "card1"
    @State private var card2:String = "card2"
    @State private var card3:String = "card3"
    @State private var card4:String = "card4"
    
    @State private var resultMessage:String = ""
    
    var body: some View {
        VStack {
            HStack {
                Image(card1)
                    .resizable()
                
                Image(card2)
                    .resizable()
            } // end HStack
            
            HStack {
                Image(card3)
                    .resizable()
                
                Image(card4)
                    .resizable()
            } // end HStack
            
            Button(action: {
                //
                // Swift Code-generate random number between 1 and 13
                //
                
                var randomNumber:Int = 0
                for i in 1...4 {
                    
                    if i == 1 {
                        randomNumber = Int.random(in: 1...13)
                        card1 = "card" + String(randomNumber)
                    }
                    else if i == 2 {
                        randomNumber = Int.random(in: 1...13)
                        card2 = "card" + String(randomNumber)
                    }
                    else if i == 3 {
                        randomNumber = Int.random(in: 1...13)
                        card3 = "card" + String(randomNumber)
                    }
                    else if i == 4 {
                        randomNumber = Int.random(in: 1...13)
                        card4 = "card" + String(randomNumber)
                    }
                    
                    resultMessage = "High :" + "\n" +
                                    "Low  :" + "\n" +
                                    "Freq :"
                } // end for loop
            }, label: {
                Text("RANDOM")
                    .padding()
                    .foregroundColor(Color.green)
                    .font(.largeTitle)
                
            }) // end button
            
            Text(resultMessage)
                .frame(width: 275, height: 70, alignment: .leading)
                .background(Color.green)
                .foregroundColor(Color.black)
            
        } // end VStack
        
    } // end body
    
} // end struct


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


