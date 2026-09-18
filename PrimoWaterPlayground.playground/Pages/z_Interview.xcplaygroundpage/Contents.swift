//: [Previous](@previous)

import Foundation










/*

//MARK: - Dictionary

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
             User(id: 4, name: "Kenson"),
             User(id: 5, name: "Pitt"),
             User(id: 6, name: "Jones"),
             User(id: 7, name: "Pitt")
]


/// get totals from simple array
let scoreTotal = scores.reduce(0) { $0 + $1}
print(scoreTotal)

let scoreTotal1 = scores.reduce(0) { result, score in
     return result + score
}
print(scoreTotal1)


/// convert arrasy to dictionary use first letter as key
let dictByLetter: [Character: [String]] = array.reduce(into: [:]) { dictionary, element in
    let first = element.first!
    return dictionary[first, default: []].append(element)
}
print(dictByLetter)


/// convert array to dictionary using a property from struct
let dictByUserID: [Int: [User]] = users.reduce(into: [:]){ dictionary, user in
    return dictionary[user.id, default: []].append(user)
}

for (key,value) in dictByUserID {
    print("key = \(key)")
    for val in value {
        print("value = \(val.name)")
    }
}



/// create dictionary from arry of structs ... group by a property
let dictByUserIDGrouping = Dictionary(grouping: users, by: {$0.id})
print("*************************************")
for (k,v) in dictByUserIDGrouping {
    print("key= \(k)")
    for vv in v {
        print("\(vv.name)")
    }
}



/// create Dictionary using this option
let userDictionary = Dictionary(uniqueKeysWithValues: users1.map { ($0.id, $0) })
print(userDictionary[1]?.name)




var dict1 = [1:"abby",3:"kate"]
var dict2 = [2:"abby",3:"gina",4:"mike"]


let new = dict1.merging(dict2) { (current,new) in new}
print(new)







//MARK: - ARRAYS

/// create a new array in same order but removing the duplicates
var arr = [7,11,4,7,12, 11,9,5]

func removeDuplicates(arr: [Int]) -> [Int] {
    var result: [Int] = []
    var alreadySeen: [Int] = []
    for i in arr {
        if !alreadySeen.contains(i) {
            result.append(i)
        }
        alreadySeen.append(i)
    }
    return result
}


let rem = removeDuplicates(arr: arr)
print(rem)

  


  /// Option II .... Remove Duplicates ... maintain order
var arr2 = [4,7,11,4,7,12, 11,9,5]
var seen: Set<Int> = []
var filteredArr = arr2.filter { seen.insert($0).inserted     }
print(filteredArr)






















//MARK: - SORT

func insertionSort(_ array: inout [Int]) {
    for i in 1..<array.count {
        
        let key = array[i]
        var j = i - 1
        print("i = \(i) key= \(key)  j= \(j)")
        
        
        while j >= 0 && array[j] > key  {
            print("   replacing \(array[j+1]) with \(array[j]))")
            array[j+1] = array[j]
            j -= 1
        }
        
        print("      setting \(array[j+1]) with \(key)")
        array[j+1] = key
        
    }
    
}

 


//var numbers = [8,11,4,19,2]
//insertionSort(&numbers)
//print(numbers)
//






 /// BUBBLE SORT
 
 
func bubbleSort(numbers: inout [Int])  {
    let count = numbers.count
    for i in 0..<count { /// if array is 4 items, it proceses all  0, 1, 2, 3
        print("i = \(i)  j count= \(count-1-i)")
        for j in 0..<count-1-i {
            print("    j = \(j)")
            if numbers[j] > numbers[j+1] {
                numbers.swapAt(j, j+1)
            }
        }
    }
}


var num = [11,98,7,22,8]


bubbleSort(numbers: &num)

print("********************")
print( num)


*/






//MARK: - GENERIC



/*
struct Stack<Element> {
    var items: [Element] = []
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    mutating func pop() -> Element? {
        return items.popLast()
    }
    
}




var strStack = Stack<String>()
print(strStack)



var intStack = Stack<Int>()

intStack.push(1)
intStack.push(2)
intStack.push(3)

intStack.pop()

 
 print(intStack)


 */





//MARK: - TWO SUM
/// From an array find the first 2 indexes of elements that add up to a given target number

/*
 unc twoSum(_ nums: [Int], _ target: Int) -> [Int] {
     // Stores [Value: Index]
     var visitedNumbers = [Int: Int]()
     
     for (currentIndex, currentNum) in nums.enumerated() {
         // Calculate the required number needed to reach the target
         let complement = target - currentNum
         
         // Check if the required number was already seen
         if let matchingIndex = visitedNumbers[complement] {
             return [matchingIndex, currentIndex]
         }
         
         // Save the current number and its index for future iterations
         visitedNumbers[currentNum] = currentIndex
     }
     
     // Return empty array if no pair matches the target
     return []
 }

 // Example Usage:
 let numbers = [2, 7, 11, 15]
 let targetSum = 9
 let result = twoSum(numbers, targetSum)
 print(result)
 */






//MARK: - TWo SUm

/*
var arr = [3,7,11,8,11,4,7,12]


func removeDuplictaes(_ arr: [Int]) -> [Int] {
    var result: [Int] = []
    var alreadySeen: [Int] = []
    
    for i in arr {
        if !alreadySeen.contains(i) {
            result.append(i)
            
        }
        
        alreadySeen.append(i)
    }
    
    return result
    
}



let ans = removeDuplictaes(arr)

print(ans)

*/



//MARK: - Unique Tuples

/*

var arr = [3,2,4,1]
let items = ["A","E", "B", "E", "C"]



func uniquePairs<T: Hashable>(_ array: [T]) -> [(T, T)] {
    var result: [(T, T)] = []
    var seen: Set<Set<T>> = []
    let count = array.count
    
    guard count > 1 else { return result }
    
    for i in 0..<count {
        for j in (i + 1)..<count {
            let pairSet: Set<T> = [array[i], array[j]]
            // If the array has duplicate values, pairSet might have a count of 1 (e.g., if array[i] == array[j])
            // Or if you only want unique item pairs:
            if !seen.contains(pairSet) {
                seen.insert(pairSet)
                result.append((array[i], array[j]))
            }
        }
    }
    
    return result
}




// Example usage:
let pairs =  uniquePairs(items)
print(pairs)


*/
