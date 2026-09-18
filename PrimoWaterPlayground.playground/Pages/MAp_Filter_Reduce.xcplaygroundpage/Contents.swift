//: [Previous](@previous)

import Foundation

struct User {
    var name: String
    var age: Int
}

struct Person {
    let name: String
    let age: Int
    let monthly: Double
    let users: Int
}

var arr = [5,7,3]
var names: [String] = ["abc","def","tuv","jkyt","lmn"]
var teams = ["dallas", "seattle", "sanfran", "detroit", "miami", "sioux", "milan", "los angeles"]
var users = [User(name: "a", age: 10),
             User(name: "b", age: 20),
             User(name: "c", age: 30),
             User(name: "g", age: 50),
             User(name: "v", age: 60)]

var dict1: [String: [Int] ] = ["a": [4,7], "g":[8,5], "w": [11, 5]]
var set1: Set<Int> = [4,6,1,3]


let people = [
    Person(name: "Alice", age: 30, monthly: 1.00, users: 10),
    Person(name: "Bob", age: 25, monthly: 1.00, users: 10),
    Person(name: "Charlie", age: 30, monthly: 1.00, users: 10),
    Person(name: "David", age: 25, monthly: 1.00, users: 10),
    Person(name: "Anna", age: 35, monthly: 1.00, users: 10),
    Person(name: "Carla", age: 35, monthly: 1.00, users: 10),
    Person(name: "Bina", age: 25, monthly: 1.00, users: 10),
    Person(name: "Donna", age: 30, monthly: 1.00, users: 10),
    Person(name: "Ahana", age: 35, monthly: 1.00, users: 10),
    Person(name: "Caitlyn", age: 25, monthly: 1.00, users: 10),
]


































/*

/// reduce array into a single Dictionary  ["B": ["d","e","k"], "E": ["e","y","p"]]

var ans: [Character: [String]] = teams.reduce(into: [:]) { (dictionary, team) -> Void in
    let firstChar = team.first!
    dictionary[firstChar, default: []].append(team)
}


print(ans)



var ans = arr.reduce(0) { (total, num) -> Int in
    return total + num
}


print(ans)




var ans1 = names.reduce("") { (result, str) -> String in
   return result + "--" + String(str)
}









var new3: [User] = users.reduce(into: []) { (result: inout [User], user: User) -> Void in
    if user.age > 30 {
        result.append(user)
    }
}












var new2 = users.filter { (user: User) -> Bool in
    if user.age > 20 {
        return true
    }
    return false
}



var new1 = users.map { (user: User) -> User in
    var updatedUser = user
    updatedUser.age += 10
    return updatedUser
    
}


*/
