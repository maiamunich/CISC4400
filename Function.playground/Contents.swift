import UIKit

//var greeting = "Hello, playground"

func printMsg(){
    print("We are in Manhattan!")
}


func combineFirstAndLast(first: String, last: String) -> String {
    return first + " " + last
}

let f = "George"
let l = "Washington"

var fullName = combineFirstAndLast(first: f, last: l)
print( "the Full name is " , fullName)
printMsg()
