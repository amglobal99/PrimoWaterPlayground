//: [Previous](@previous)

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true



//MARK: - With ERROR

enum NetworkError: Error {
    case noData
}

// 1. The legacy callback-based function
func fetchUserData(completion: @escaping @Sendable (Result<String, Error>) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
        // Simulating a successful data fetch
        completion(.success("User Profile Data"))
    }
}

// 2. Modern async wrapper using withCheckedThrowingContinuation
func getUserData() async throws -> String {
    try await withCheckedThrowingContinuation { continuation in
        fetchUserData { result in
            switch result {
            case .success(let data):
                // Resume exactly once returning the value
                continuation.resume(returning: data)
            case .failure(let error):
                // Resume exactly once throwing the error
                continuation.resume(throwing: error)
            }
        }
    }
}

 // 3. How you call it
 do {
     let data = try await getUserData()
 } catch {
     print(error)
 }






















//MARK: -  Example wirhout ERROR

// 1. The legacy callback-based function
func fetchUserAge(userID: String, completion: @escaping @Sendable (Int) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
        completion(25) // Always returns an integer
    }
}

// 2. Modern async wrapper using withCheckedContinuation
func getUserAge(userID: String) async -> Int {
    await withCheckedContinuation { continuation in
        fetchUserAge(userID: userID) { age in
            // Resume exactly once with the returning value
            continuation.resume(returning: age)
        }
    }
}


// 3. How you call it
 let age = await getUserAge(userID: "123")
 print(age)

PlaygroundPage.current.finishExecution()
