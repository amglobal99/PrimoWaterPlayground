//: [Previous](@previous)

import Foundation



// MARK: - 1. Safe Data Transfer with Sendable

// This struct is safe to pass between threads because all its properties are immutable and Sendable (String and Double).
struct TransactionHistory: Sendable {
    let transactionId: String
    let amount: Double
    let type: String
}

// MARK: - 2. Protecting State with an Actor

// The actor ensures that only one task can modify or read its state at any given time.
actor BankAccount {
    
    private var balance: Double = 0.0
    private var history: [TransactionHistory] = []
    
    let accountHolder: String
    
    init(accountHolder: String) {
        self.accountHolder = accountHolder
    }
    
    // Internal state modifications are completely safe and synchronous inside the actor
    func deposit(amount: Double) {
        balance += amount
        let record = TransactionHistory(transactionId: UUID().uuidString, amount: amount, type: "Deposit")
        history.append(record)
        print("💰 [\(accountHolder)] Deposited $\(amount). New Balance: $\(balance)")
    }
    
    func withdraw(amount: Double) -> Bool {
        guard balance >= amount else {
            print("❌ [\(accountHolder)] Failed withdrawal of $\(amount). Insufficient funds!")
            return false
        }
        balance -= amount
        let record = TransactionHistory(transactionId: UUID().uuidString, amount: amount, type: "Withdrawal")
        history.append(record)
        print("💸 [\(accountHolder)] Withdrew $\(amount). New Balance: $\(balance)")
        return true
    }
    
    // Returns a Sendable array, guaranteeing thread safety to the caller
    func getHistory() -> [TransactionHistory] {
        return history
    }
}




// MARK: - 3. Putting it into Action (Concurrency)


// We use a Task to run asynchronous code in the playground
Task {
    let myAccount = BankAccount(accountHolder: "Alice")
    
    // Constant properties (let) on an actor can be accessed synchronously
    print("Account created for: \(myAccount.accountHolder)")
    
    // Simulating concurrent deposits and withdrawals using a task group
    await withTaskGroup(of: Void.self) { group in
        
        // Concurrent Deposit Task
        group.addTask {
            // 'await' is required because we are crossing into the actor's isolated context
            await myAccount.deposit(amount: 100.0)
        }
        
        // Concurrent Withdrawal Task
        group.addTask {
            _ = await myAccount.withdraw(amount: 40.0)
        }
        
        // Another Concurrent Deposit Task
        group.addTask {
            await myAccount.deposit(amount: 50.0)
        }
    }
    
    // Fetching data after all concurrent tasks finish
    let history = await myAccount.getHistory()
    print("\n--- Final Statement ---")
    for item in history {
        print("\(item.type): $\(item.amount) (ID: \(item.transactionId))")
    }
}



















/*

// MARK: - 1. The Sendable Model

// This struct is implicitly Sendable because it only contains value types (String, Int).
// It can be safely copied and sent across concurrency boundaries.
struct UserProfile: Sendable {
    let id: Int
    let name: String
}



// MARK: - 2. The Actor

// The actor protects its mutable state ('activeUsers').
// Only one task can access or modify this state at any given time, preventing data races.
actor ChatRoomManager {
    private var activeUsers: [Int: UserProfile] = [:]
    
    // Changing actor state must happen inside the actor
    func join(user: UserProfile) {
        activeUsers[user.id] = user
        print("👤 \(user.name) joined the room.")
    }
    
    // Reading actor state is asynchronous from the outside
    func getUserCount() -> Int {
        return activeUsers.count
    }
}



// MARK: - 3. Concurrency in Action
// We use a Task to run asynchronous code in our playground.
Task {
    let manager = ChatRoomManager()
    
    // Create Sendable data packets
    let alice = UserProfile(id: 1, name: "Alice")
    let bob = UserProfile(id: 2, name: "Bob")
    
    // Simulating concurrent access from two separate tasks.
    // 'await' is required because entering the actor handles potential queues.
    await withTaskGroup(of: Void.self) { group in
        group.addTask {
            // Safe to pass 'alice' here because UserProfile is Sendable
            await manager.join(user: alice)
        }
        
        group.addTask {
            // Safe to pass 'bob' here because UserProfile is Sendable
            await manager.join(user: bob)
        }
    }
    
    // Reading the final state safely
    let count = await manager.getUserCount()
    print("✨ Total users in chat room: \(count)")
}



*/
