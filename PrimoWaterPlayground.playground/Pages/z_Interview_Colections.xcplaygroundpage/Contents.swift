//: [Previous](@previous)

import Foundation


struct Product {
    let id: String
    let name: String
}

let products = [
    Product(id: "A1", name: "Laptop"),
    Product(id: "B2", name: "Mouse"),
    Product(id: "A1", name: "Upgraded Laptop"), // Duplicate ID
    Product(id: "C1", name: "IBM Laptop"),
    Product(id: "B2", name: "Compaq"),
    Product(id: "D1", name: "Lenova")
]

/// common elemenst in the two arays are   4, 8
var array1 = [4, 11, 7, 23, 11, 8, 7]
var array2 = [1, 8, 4, 7, 8, 4, 14]
var names = ["alice", "bobby","carly","beena","anna", "benny", "betty", "carl", "dina"]
var dict: [Int: String] = [2:"g", 5:"t", 11: "r", 3:"p", 12:"w", 4:"e", 22: "q"]



/*
/// 1. get array modfiied removing duplicates and keeping order


func combine(array: [Int] ) -> [Int] {
    var seen: Set<Int> = []
    var filtered : [Int] = array.filter { seen.insert($0).inserted  }
    return filtered
}

let ans = combine(array: array1)
print(ans)

func removeDup(array: [Int]) -> [Int] {
    var alreadySeen: Set<Int> = []
    var result: [Int] = []
    for element in array {
        if !alreadySeen.contains(element){
            result.append(element)
        }
        alreadySeen.insert(element)
    }
    return result
}

let ans2 = removeDup(array: array1)
print(ans2)






///2 . check which elements in second are present in first array

func checkDups(array1: [Int], array2: [Int]) -> [Int] {
    var result: [Int] = []
    var setForArray1 = Set(array1)
    var setForArray2 = Set(array2)
    
    result = Array(setForArray2.intersection(setForArray1) )
    
    return result
}

let newAns = checkDups(array1: array1, array2: array2)
print(newAns)






/// 3.  Bubble Sort

func sortBubble(array: inout [Int]) {
    let count = array.count
    for i in 0..<count {
        for j in 0..<count-1-i {
            if array[j] > array[j+1] {
                array.swapAt(j,j+1)
            }
        }
    }
}

var arrSort = [14, 4, 9,2, 11,6]
sortBubble(array: &arrSort)
print(arrSort)




/// 4.
//MARK: - TWO SUM
/// From an array find the FIRSt 2 indexes of elements that add up to a given target number
/// let's say given target is    9
/// we want the answer to be indexes ----> 1, 4

var twoSum = [4, 2, 5, 1, 7, 3, 9, 10]

func twoSum(array: [Int], target: Int) -> [(Int, Int)] {
    var indexes: [(Int, Int)] = []
    //var seen: Set<Int> = []
    let count = array.count
    
    for i in 0..<count {
        for j in i+1..<count {
            if (array[i] + array[j]) == target {
                indexes.append((i,j))
                return indexes
            }
        }
    }
    
    return indexes
    
}

let ans = twoSum(array: twoSum, target: 9)
print(ans)





/// 5 ..... convert array into a Dictionary. Key will be first character in each string

var names1 = ["alice", "bobby","carly","beena","anna", "benny", "betty", "carl", "dina"]


let namesByLetter: [Character: [String]] = names1.reduce(into: [:]) { dictionary, name in
    let firstChar: Character = name.first!
    dictionary[firstChar, default: []].append(name)
}

print(namesByLetter)


*/



/*

/// 5.  convert array into dictioanry
let products2 = [
    Product(id: "A1", name: "Laptop"),
    Product(id: "B2", name: "Mouse"),
    Product(id: "A1", name: "Upgraded Laptop"), // Duplicate ID
    Product(id: "C1", name: "IBM Laptop"),
    Product(id: "B2", name: "Compaq"),
    Product(id: "D1", name: "Lenova")
]



let dict1 = Dictionary(grouping: products, by: { $0.id})
print(dict1)

var newArr = [4, 12, 6, 2, 9, 12, 1, 4]
let pairs = newArr.map { ($0, ())}
let dict2 = Dictionary(pairs, uniquingKeysWith: { (_, new) in new } )
print(dict2)



var arr11 = [("one",1), ("two", 2_), ("three",3),("four",4)]
let dict11 = Dictionary(uniqueKeysWithValues: arr11)
print(dict11)


var uniqArr = Array(Set(newArr))
var pairs2 = uniqArr.map { ($0,())}
let dict22 = Dictionary(uniqueKeysWithValues: pairs2)
print(dict22)


*/


let products2 = [
    Product(id: "A1", name: "Laptop"),
    Product(id: "B2", name: "Mouse"),
    Product(id: "A1", name: "Upgraded Laptop"), // Duplicate ID
    Product(id: "C1", name: "IBM Laptop"),
    Product(id: "B2", name: "Compaq"),
    Product(id: "D1", name: "Lenova")
]


var array11 = [4, 11, 7, 23, 11, 4, 8, 23, 7]
var array22 = [1, 8, 4, 7, 8, 4, 14]
var names33 = ["alice", "bobby","carly","beena","anna", "benny", "betty", "carl", "dina"]
var dict7: [Int: String] = [2:"g", 5:"t", 11: "r", 3:"p", 12:"w", 4:"e", 22: "q"]

let dict88 = Dictionary(uniqueKeysWithValues: names33.map{($0, $0.count) } )
print(dict88)

let pairs33 = names33.map {($0, ())}
let dict99 = Dictionary(pairs33, uniquingKeysWith: { (current, new ) in new })
