//: [Previous](@previous)

import Foundation
import PlaygroundSupport


PlaygroundPage.current.needsIndefiniteExecution = true



struct User {
    var id: Int
    var name: String
}

var array = ["Anna", "Atl", "Bill", "Carla", "Donna", "Caitlyn", "Bobby", "Aimee"]
var animals = ["Dog", "Cat", "Bird", "Dog", "Bird", "Cat", "Dog"]
var fruits = [1: "apple", 2:"banana", 3:"cherry", 6: "cherry", 7: "apple", 4: "banana"]
var scores = [3,4,5,3]

var users = [User(id: 1, name: "Smith"),
             User(id: 2, name: "Jenny"),
             User(id: 1, name: "Jones"),
             User(id: 4, name: "Kenson"),
             User(id: 2, name: "Pitt"),
             User(id: 6, name: "Jones"),
             User(id: 4, name: "Pitt")
]

var users1 = [User(id: 1, name: "Smith"),
             User(id: 2, name: "Jenny"),
             User(id: 3, name: "Jones"),
             User(id: 4, name: "Smith"),
             User(id: 5, name: "Pitt"),
             User(id: 6, name: "Jones"),
             User(id: 7, name: "Pitt")
]





/// 3.  Bubble Sort

func sortBubble(array: inout [Int]) {
    let count = array.count
    for i in 0..<count {      //0, 1, 2, 3
        for j in 0..<count-1-i {  // 0, 1, 2
            if array[j] > array[j+1] {
                array.swapAt(j,j+1)
            }
        }
    }
}

var arrSort = [14, 4, 9, 2]
sortBubble(array: &arrSort)
print(arrSort)



















PlaygroundPage.current.finishExecution()





