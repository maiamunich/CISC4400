import UIKit

func countMultiplesOf10(numbers: Int...) -> Int {
    var result = 0
    
    for number in numbers {
        if number % 10 == 0 {
            result += 1
        }
    }
    return result
}

let count = countMultiplesOf10(numbers: 5, 10, 15, 20, 25, 30, 25, 40)
print(count) // 4
