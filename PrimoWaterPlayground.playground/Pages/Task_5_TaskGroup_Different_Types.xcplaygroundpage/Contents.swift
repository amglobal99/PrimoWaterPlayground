//: [Previous](@previous)

import Foundation


struct User {
    var username: String
    var favotites: Set<Int>
    var messages: [String]
}


enum FetchResult {
    case username(String)
    case favorites(Set<Int>)
    case messages([String])
}



func loadUser() async -> User {
    
    return await withTaskGroup(of: FetchResult.self) { group in
        
        group.addTask {
            return .username("sheila")
        }
        
        group.addTask {
            let fav: Set<Int> = [3, 5, 7]
            return .favorites(fav)
        }
        
        group.addTask {
            return .messages(["d","k","r"])
        }
        
        var uname: String = ""
        var favr: Set<Int> = []
        var msg: [String] = []
        
        for await value in group {
            switch value {
            case .username(let name):
                uname = name
            case .favorites(let f):
                favr = f
            case .messages(let m):
                msg = m
            }
        }
        
        return User(username: uname, favotites: favr, messages: msg)
    }
}



Task {
    let u = await loadUser()
    print("user is: \(u)")
}
