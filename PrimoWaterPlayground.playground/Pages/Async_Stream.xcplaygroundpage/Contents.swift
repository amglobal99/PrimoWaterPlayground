//: [Previous](@previous)

import Foundation
import SwiftUI

import PlaygroundSupport
import CoreLocation


PlaygroundPage.current.needsIndefiniteExecution = true














/*
//MARK: -  Example # 1 .... Simple AsyncStream

// Use an actor to safely manage shared state across tasks without @MainActor
actor KitchenManager {
    
    var stream: AsyncStream<Int>
    var myContinuation: AsyncStream<Int>.Continuation?
    private var productionTask: Task<Void, Never>?
    
    
    init() {
        let (stream, continuation) = AsyncStream.makeStream(of: Int.self)
        self.stream = stream
        self.myContinuation = continuation
    }
    
    
    func runKitchen() async {
        productionTask = Task { [weak self] in
            for i in 1...5 {
                guard !Task.isCancelled else {
                    print("Production task was cancelled!")
                    break
                }
                print("adding \(i) to stream")
                try? await Task.sleep(for: .seconds(1))
                await self?.yield(i)
            }
        } //Task
    } // func
    
    
    
    
    // Safely yields values to the continuation
    func yield(_ value: Int) {
        myContinuation?.yield(value)
    }
    
    // Safely finishes the stream
    func finish() {
        myContinuation?.finish()
    }
    
    // Stores the production task so it can be canceled later
    func setProductionTask(_ task: Task<Void, Never>) {
        self.productionTask = task
    }
    
    // Cancels the active production task
    func cancelProduction() {
        productionTask?.cancel()
    }
    
    
    
} //actor





// Global execution task
let myTask = Task { @MainActor in
    print("I am starting")
    let manager = KitchenManager()
    await manager.runKitchen()
    
    // Consumption loop
    for await num in await manager.stream {
        print("I received \(num)")
        if num == 3 {
            print("leaving early ...")
            await manager.cancelProduction()
            break
        }
    }
    
    
    await manager.myContinuation?.finish()
    
    PlaygroundPage.current.finishExecution()
}


 
 */




























/*

// ************* SAME EXAMPLE USING ORDER INSTEAD OF INT

// Real-world data structure representing a restaurant order
struct FoodOrder {
    let id: Int
    let name: String
    let tableNumber: Int
}

actor KitchenManager {
    private var orderContinuation: AsyncStream<FoodOrder>.Continuation?
    private var orderGeneratorTask: Task<Void, Never>?
    
    func startKitchenService() async {
        let orderStream = makeOrderStream()
        
        // Background Task: Simulates POS system receiving orders from servers/apps
        let generatorTask = Task { [weak self] in
            let menuItems = ["Margherita Pizza", "Truffle Fries", "Wagyu Burger", "Spaghetti Carbonara", "Caesar Salad"]
            
            for i in 1...5 {
                guard !Task.isCancelled else {
                    print("🍳 Kitchen Closed: Stopped receiving new orders.")
                    break
                }
                
                let newOrder = FoodOrder(id: 100 + i, name: menuItems[i - 1], tableNumber: Int.random(in: 1...20))
                print("🔔 New Ticket: Sending \(newOrder.name) (Order #\(newOrder.id)) to the kitchen.")
                
                // Simulate a delay between customers placing orders
                try? await Task.sleep(for: .seconds(1.5))
                
                await self?.receiveOrder(newOrder)
            }
            
            await self?.closeOrderStream()
        }
        
        setGeneratorTask(generatorTask)
        
        // Main Consumption Loop: The chefs processing tickets as they arrive
        for await order in orderStream {
            print("👨‍🍳 Chef: Cooking Order #\(order.id) (\(order.name)) for Table \(order.tableNumber)...")
            
            // Real-world cancellation condition: Kitchen hits an emergency capacity limit
            if order.id == 103 {
                print("🚨 Kitchen Alert: Gas line issue! Closing kitchen early...")
                stopAcceptingOrders()
                break
            }
        }
    }
    
    // Safely creates the stream and captures its continuation
    private func makeOrderStream() -> AsyncStream<FoodOrder> {
        let (stream, continuation) = AsyncStream.makeStream(of: FoodOrder.self)
        self.orderContinuation = continuation
        return stream
    }
    
    // Forwards a new order to the stream
    private func receiveOrder(_ order: FoodOrder) {
        orderContinuation?.yield(order)
    }
    
    // Formally ends the stream when no more orders are coming
    private func closeOrderStream() {
        orderContinuation?.finish()
    }
    
    private func setGeneratorTask(_ task: Task<Void, Never>) {
        self.orderGeneratorTask = task
    }
    
    // Cancels the background order generation task
    func stopAcceptingOrders() {
        orderGeneratorTask?.cancel()
    }
}

// Global execution
Task {
    print("⏰ Restaurant Opening Shift Started")
    let manager = KitchenManager()
    await manager.startKitchenService()
    print("🧹 Shift ended.")
}






*/










































/*

//MARK:  - Very Simple Example ***************************



func makeNumberStream() -> AsyncStream<Int> {
    
    let myStream = AsyncStream<Int> { continuation in
        // 2. The continuation is Sendable, allowing us to spin up a concurrent Task safely
        Task {
            for i in 1...5 {
                try? await Task.sleep(for: .seconds(3))
            
                continuation.yield(i)
            }
            
            // 4. Always finish the stream when done to break the consumer's loop
            continuation.finish()
        }
        
        // 5. Handle stream termination/cancellation clean up if needed
        continuation.onTermination = { termination in
            switch termination {
            case .finished:
                print("Stream ended naturally.")
            case .cancelled:
                print("Consumer cancelled the task reading the stream.")
            @unknown default:
                break
            }
        }
    } //AsyncStream
    
    return myStream
}



func runStreamExample() async {
    print("Starting stream...")
    let numberStream = makeNumberStream()
    
    // The loop awaits every new value and terminates automatically when finish() is called
    for await number in numberStream {
        print("Received element: \(number)")
    }
    
    print("Stream processing complete.")
}






 /// To run this in a non-async context (like a SwiftUI button action):
 Task {
     await runStreamExample()
 }




*/
