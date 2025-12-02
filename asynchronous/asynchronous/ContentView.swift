//

// ContentView.swift

// asyncImage_Fall_2025

//

// Created by Nick Kounavelis on 10/7/25.

//



import SwiftUI



struct ContentView: View {

   // Example URL

   let imageUrl = URL(string: "https://storm.cis.fordham.edu/~mmunich/Pictures/art.jpeg")!

            

   var body: some View {

     //

     // first async picture

     //

     AsyncImage(url: imageUrl) { phase in

      switch phase {

        case .empty:

         // Placeholder while loading

         ProgressView()

         

        case .success(let image):

         // Display the loaded image

         image

           .resizable()

           //.scaledToFit()

         

        case .failure:

         // Handle error, e.g., display a system icon

         Image(systemName: "exclamationmark.triangle.fill")

           .foregroundColor(.red)

         

        @unknown default:

         // Fallback for future cases

         EmptyView()

      } // end switch

       

     }

     .frame(width: 350, height: 350)

     .background(Color.gray.opacity(0.2))

     .cornerRadius(10)

     

  } // end body

   

} // struct



#Preview {

  ContentView()

}

