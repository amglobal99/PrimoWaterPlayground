//: [Previous](@previous)

import Foundation
import UIKit


func printMessage() async -> [String] {
    
    return await withTaskGroup(of: String.self) { group in
        group.addTask { "Hello"}
        group.addTask {"NAmee" }
        group.addTask { "Someth"}
        
        var final: [String] = []
        for await value in group {
            final.append(value)
        }

        return final
    }
}



Task{
     let p = await printMessage()
     print("\(p)")
}
