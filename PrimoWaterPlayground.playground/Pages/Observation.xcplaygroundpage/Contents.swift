//: [Previous](@previous)

import Foundation



import Observation

@Observable
final class UserProfile: Sendable {
    var name: String = "Guest"
    var score: Int = 0
}




struct Jack : Sendable {
    
    var user = UserProfile()
    
    
    func startTracking() {
        withObservationTracking {
            // 1. Access the properties you want to observe here
            print("Current score is: \(user.score)")
        } onChange: {
            // 2. This closure runs BEFORE the change actually happens
            print("Score is about to change! .... new value: \(user.score)")
            
            // 3. IMPORTANT: Observation is "one-shot."
            // To keep observing, you must call this function again recursively.
            DispatchQueue.main.async {
                startTracking()
            }
        }
    }
    
    
    
 }


