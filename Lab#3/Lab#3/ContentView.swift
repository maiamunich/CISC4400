//
//  ContentView.swift
//  randomCards
//

//

import SwiftUI

struct ContentView: View {
    @State private var slot1:String = "cutie1"
    @State private var slot2:String = "cutie2"
    @State private var slot3:String = "cutie3"
    @State private var slot4:String = "cutie4"
    @State private var slot5:String = "cutie5"
    @State private var slot6:String = "cutie6"
    @State private var slot7:String = "cutie7"
    @State private var slot8:String = "cutie8"

    
    @State private var resultMessage:String = ""
    
    var body: some View {
        VStack {
            HStack {
                Image(slot1).resizable().scaledToFit()
                Image(slot2).resizable().scaledToFit()
            } // end HStack
            
            HStack {
                Image(slot3).resizable().scaledToFit()
                Image(slot4).resizable().scaledToFit()
            } // end HStack
            
            HStack {
                Image(slot5).resizable().scaledToFit()
                Image(slot6).resizable().scaledToFit()
            } // end HStack
            HStack {
                Image(slot7).resizable().scaledToFit()
                Image(slot8).resizable().scaledToFit()
            } // end HStack
            
            Button(action: {
                //
                // Swift Code-generate random number between 1 and 13
                //
                var cardsArray = [Int]()
                cardsArray.removeAll()
                
              // var randomNumber:Int = 0
                for i in 1...8{
                
                    let r = Int.random (in: 1...8)
                
                    if i == 1 {
                        slot1 = "cutie\(r)";cardsArray.append(r)
                    }
                    else if i == 2 {
                        slot2 = "cutie\(r)";cardsArray.append(r)

                    }
                    
                    else if i == 3 {
                        slot3 = "cutie\(r)";cardsArray.append(r)

                    }
                    else if i == 4 {
                        slot4 = "cutie\(r)";cardsArray.append(r)

                    }
                    else if i == 5 {
                        slot5 = "cutie\(r)";cardsArray.append(r)

                    }
                    else if i == 6 {
                        slot6 = "cutie\(r)";cardsArray.append(r)

                    }
                    else if i == 7 {
                        slot7 = "cutie\(r)";cardsArray.append(r)

                    }
                    else{
                        slot8 = "cutie\(r)";cardsArray.append(r)
                    }
                } // end for loop
                
                let maximumCard:Int = cardsArray.max() ?? 0
                let minimumCard:Int = cardsArray.min() ?? 0
                
                let maxStr = String(maximumCard)
                let minStr = String(minimumCard)

                // Build the message in two statements (no trailing '+')
                resultMessage = "High : " + maxStr + "\n"
                resultMessage += "Low : " + minStr + "\n"
                
            
            }, label: {
                Text("RANDOM")
                    .padding()
                    .foregroundColor(Color.purple)
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


