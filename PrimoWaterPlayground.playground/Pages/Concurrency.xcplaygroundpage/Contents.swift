//: [Previous](@previous)

import Foundation
import PlaygroundSupport








/*

actor ImageDownloader {
    // 1. This is isolated mutable state
    var downloadCount = 0
    
    // 2. This method is forced OUTSIDE the actor's protection
    nonisolated func printStatus() {
        // ❌ COMPILER ERROR: Actor-isolated property 'downloadCount'
        // cannot be referenced from a non-isolated context
        print("Current downloads: \(downloadCount)")
        
        // ❌ COMPILER ERROR: Actor-isolated property 'downloadCount'
        // cannot be mutated from a non-isolated context
        downloadCount += 1
    }
}

*/












/*
// Above code Fixed

actor ImageDownloader {
    // 1. Immutable state (Safe to read from anywhere)
    let maxConcurrentDownloads = 4
    
    // 2. Mutable state (Protected)
    var downloadCount = 0
    
    // 3. Non-isolated method
    nonisolated func printConfiguration() {
        //  ALLOWED: Reading a 'let' constant is inherently thread-safe
        print("Max allowed: \(maxConcurrentDownloads)")
    }
    
    // 4. Non-isolated method using async/await
    nonisolated func incrementAsync(downloader: ImageDownloader) async {
        //  ALLOWED: Using 'await' safely hops back into the isolation domain
        await downloader.incrementCount()
    }
    
    func incrementCount() {
        downloadCount += 1
    }
}


*/







/// Passing Unsafe data
///
/// // A normal class with mutable state. NOT thread-safe.
class UserProfile {
    var name: String = "Guest"
}

actor ProfileManager {
    var activeProfile = UserProfile()

    // 1. This function leaves the actor's safe thread zone
    nonisolated func processProfile(profile: UserProfile) {
        // 2. This code runs on the caller's unpredictable thread
        print(profile.name)
    }

    func triggerProcess() {
        // ❌ SWIFT 6 COMPILER ERROR:
        // Passing argument of non-sendable type 'UserProfile' outside
        // of actor-isolated context may introduce data races
        processProfile(profile: activeProfile)
    }
}









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
