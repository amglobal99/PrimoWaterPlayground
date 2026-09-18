//: [Previous](@previous)

import Foundation
import PlaygroundSupport



struct Team {
    
    let id: Int = 11
    var name: String = "test"
    
    
    @concurrent
    func updateName(newName: String) async -> Self {
        var copy = self
        copy.name = newName
        return copy
    }
    
}





let miami = Team()



let new = await miami.updateName(newName: "jelly")

print(new)
















/*
actor Counter {
    private var value: Int = 0
    
    func updateCount() {
        value += 11
    }
    
    func getValue() -> Int {
        return value
    }
    
}




let counter = Counter()





Task {
    await counter.updateCount()
    
    let v = await counter.getValue()
    
    print("the value is \(v)")
}


*/


























/*

actor ScoreTracker {
    var highScore: Int = 0
    
    
    func updateScore(newScore: Int) {
        if newScore > highScore {
            highScore = newScore
        }
    }
}


let tracker = ScoreTracker()




Task {
    
    await withTaskGroup(of: Void.self) { group in
        
        for i in 1...5 {
            group.addTask {
                await tracker.updateScore(newScore: i*10)
            }
        }
        
    }
    
    let finalScore = await tracker.highScore
    print("The final score: \(finalScore)")

    PlaygroundPage.current.finishExecution()
    
}


*/












/*
func downloadProfilePic() async throws -> String {
    try await Task.sleep(for: .seconds(1))
    return "📷 ProfilePic.png"
}

func downloadSettings() async throws -> String {
    try await Task.sleep(for: .seconds(2))
    return "⚙️ UserSettings loaded"
}

Task {
    print("Starting concurrent downloads...")
    
    // Both start downloading at the same time
    async let pic = downloadProfilePic()
    async let settings = downloadSettings()
    
    // We await both results together
    let results = try await (pic, settings)
    print("Download finished: \(results.0), \(results.1)")
    
    PlaygroundPage.current.finishExecution()
}


*/








/*

// Tells the playground to run indefinitely so background tasks complete
PlaygroundPage.current.needsIndefiniteExecution = true

func fetchUserData() async throws -> String {
    try await Task.sleep(for: .seconds(2))
    return "Alice"
}

Task {
    do {
        print("Fetching user...")
        let user = try await fetchUserData()
        print("Welcome, \(user)!")
    } catch {
        print("Error: \(error)")
    }
    
    // Cleanly ends the indefinite execution once the Task finishes
    PlaygroundPage.current.finishExecution()
}

*/
