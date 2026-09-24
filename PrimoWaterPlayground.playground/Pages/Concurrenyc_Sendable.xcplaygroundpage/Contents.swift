//: [Previous](@previous)

import Foundation


//MARK: -  ************************* SENDABLE *******************



class User {
    var score = 0
}


/// We have this function which will do a ASYNC background thread call and Execute the closure.
/// The closure MUST be SENADABLE

func performConcurrentWork(operation: @escaping @Sendable () -> Void) {
    DispatchQueue.global().async {
        operation()
    }
}


func example() {
    let name = "Alice" // String is a value type (Sendable)
    
    performConcurrentWork {
        // This is perfectly safe!
        print("Hello, \(name)")
    }
}



func badExample() {
    var totalCount = 0
    let player = User()
    
    performConcurrentWork {
        // ❌ ERROR: Mutation of captured var 'totalCount' in a @Sendable closure
        totalCount += 1
        
        // ❌ ERROR: Capture of non-sendable type 'User' in a @Sendable closure
        player.score += 10
    }
}












/*
 /// Example # 2
 
 /// Working example .... shows that even if a class is not Sendable ..
 /// But if you mark it with @MainActor , then it gets the actor protection .... and it can be pased out
 
 
 /// Passing a non-Sendable class into a Task or across an actor boundary triggers a compile-time error in Swift 6 strict concurrency checking


 /*

 ### How to Fix It
  * mark class with @MainActor
 * Make the class conform to `Sendable` (if it contains immutable state or internal synchronization).
 * Convert the class into an `actor`.
 * Use ownership transfer modifiers like `sending` if passing the object so that the original context relinquishes access.

 */


 //MARK: - Actor

 actor DataManager {
     var profile: UserProfile?

     // ❌ Error: Non-sendable type 'UserProfile' in parameter of actor-isolated method
     func updateProfile(_ newProfile: UserProfile) async {
         profile = newProfile
         
        // await profile?.updateName(to: "Bob")
     }
     
     
     
     
 }



 //MARK: - Main Actor

   
 func performTask() {  // 1. Unisolated context
     let profile = UserProfile()
     let manager = DataManager()

     // 2. Task Inherits unisolated context -> Runs on background pool
     // 3. Tries to pass 'profile' across a boundary
     Task {
         // ❌ Error: Capturing 'profile' (a non-Sendable class) in a @Sendable closure
         // ❌ Error: Passing argument of non-sendable type 'UserProfile' across isolation boundaries
         await manager.updateProfile(profile)
         //print(await profile.name)
     }
 }



 //MARK: - Class

 @MainActor
 class UserProfile {
     var name: String = "Alice"
     
     // A helper function to modify the state safely within the Main Actor context
     func updateName(to newName: String) {
         self.name = newName
     }
 }

 */
