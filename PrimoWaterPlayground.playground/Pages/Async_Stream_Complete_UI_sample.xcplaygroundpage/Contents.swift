//: [Previous](@previous)

import Foundation

//// ************** JUST CREATE A NEW PROJECT AND PASTE THIS IN A NEW FILE *******

import SwiftUI

enum MyError:  Error {
    case ShiftFinished
}


struct KitchenViewStream: View {
    
    @State private var manager = RestaurantManager()
    @State private var nextTableNumber = 1
    
    var body: some View {
        NavigationStack {
            List(manager.activeOrders) { order in
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Table \(order.tableNumber)")
                            .font(.headline)
                        Text("Status: \(order.status)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        ProgressView(value: order.progress)
                            .animation(.linear, value: order.progress)
                    }
                    Spacer()
                    if order.status == "Cooking 🔥" || order.status == "Pending🧑‍🍳" {
                        Button(role: .destructive) {
                            manager.cancelOrder(id: order.id)
                        } label: {
                            Image(systemName: "multiply.circle.fill")
                                .font(.title2)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Manual Kitchen")
            .toolbar {
                // Button that mimics real-time ordering actions
                Button {
                    manager.addOrderManually(tableNumber: nextTableNumber)
                    nextTableNumber += 1 // Increment for the next tap simulation
                } label: {
                    Label("Send Order T\(nextTableNumber)", systemImage: "plus.app.fill")
                }
            }
        }
    }
} //end struct KitchenViewStream











//MARK: - Restaurant Manager


@Observable
@MainActor
final class RestaurantManager {
    
    // 1. Keep a reference to the task
    private var pipelineTask: Task<Void, any Error>?

    var activeOrders: [OrderState] = []
    private var runningTasks: [UUID: Task<Void, Never>] = [:]
    private let kitchen = Kitchen()
    
    // 1. Store the stream's continuation as a private property
    private var orderContinuation: AsyncStream<Order>.Continuation?
    
    // 2. Initialize the pipeline loop once when the manager is created
    init() {
        startOrderPipeline()
    }
    
    
    //MARK: - Start Order Pipeline
    
    
    //MARK: - Option 1 ... run taks concurrently
    private func startOrderPipeline() {
        let incomingStream = AsyncStream<Order> { continuation in
            self.orderContinuation = continuation
        }
        
       /// THIS IS THE OUTSIDE UNSTRUCTURED TASK
        pipelineTask = Task {
            try await withThrowingTaskGroup(of: Void.self) { group in
                
                // 1. Stream handling child task
                group.addTask {
                    // MOVE THE GROUP OUTSIDE THE LOOP
                    await withDiscardingTaskGroup { discardingGroup in
                        for await order in incomingStream {
                            let orderID = order.id
                            
                            await self.appendInitialOrderState(order)
                            
                            // This now spawns concurrently and immediately continues the loop
                          _ =  discardingGroup.addTaskUnlessCancelled {
                                print("Jack: added task for order \(orderID)")
                                await self.processOrder(order)
                            }
                        } // for loop
                    } // discardingGroup ends only when stream ends or is cancelled
                } // group.addTask
                
                // 2. This child task will now execute immediately in parallel
                group.addTask {
                    try await Task.sleep(for: .seconds(25))
                    print("Jack: ******* Sleep OVER ***********")
                    //throw MyError.ShiftFinished
                }
                
                // 3. Monitor the group. If the error throws, it bubbles up here
                try await group.next()
                print("Jack: will cancel all groups tasks")
                group.cancelAll()
            }
        } // Task
    } // end func
    
    
    
    
    
    
    
    private func appendInitialOrderState(_ order: Order) async {
        let initialState = OrderState(id: order.id, tableNumber: order.tableNumber, status: "Pending🧑‍🍳", progress: 0.0)
        //self.activeOrders.append(initialState)
        
        await MainActor.run { // Ensure UI mutations are safe
            self.activeOrders.append(initialState)
        }
    }

    
    
    private func endShift(using continuation: AsyncStream<Order>.Continuation?) {
        continuation?.finish()
    }
    
    
    // 3. Cancel the task explicitly when the object dies
    isolated deinit {
        pipelineTask?.cancel()
    }
    
    
    

    //MARK: - Process Order
    
    
    
    /// called from **startOrderPipeline() **   which is where we create the ** ASYNC Stream **
    private func processOrder(_ order: Order) async {
        updateStatus(for: order.id, to: "Cooking 🔥", progress: 0.1)
        print("Jack: processOrder - working on tabel number: \(order.tableNumber)")
        
        do {
            /// create throwing group to process all ITEMS in the Order
            try await withThrowingTaskGroup(of: Void.self) { group in
                
                for item in order.items {
                    /// ** ADD THE TASK **
                    let added =  group.addTaskUnlessCancelled {
                        print("Jack: processOrder - will start to cook \(item.name)")
                        try await self.kitchen.cookItem(item) { progress in
                            // Item reporting progress safely back to MainActor view model
                            await self.updateProgress(orderID: order.id, itemProgress: progress, totalItems: order.items.count)
                            print("Jack: processOrder - Completed \(item.name) at table:  \(order.tableNumber)")
                        }
                    } // add task
                    
                    guard added else {
                        print("   Jack: ***** will throw cancel error from guard")
                        throw CancellationError()
                    }
                } // for loop
                
                // updateStatus(for: order.id, to: "Ready 🛎️", progress: 1.0)
                // runningTasks.removeValue(forKey: order.id)
                
            } //end group
            
        } catch is CancellationError {
            print("Jack: processOrder - I see a cancellation!")
            updateStatus(for: order.id, to: "Cancelled ❌", progress: 0.0)
        } catch {
            updateStatus(for: order.id, to: "Error ⚠️", progress: 0.0)
        }
    } ///end func
    
    
    
    

    
    
    
    
    
    
    //MARK: -  Add Manual order
    
    // 4. Expose a public function for your SwiftUI Button to trigger
    func addOrderManually(tableNumber: Int) {
        let burger = MenuItem(name: "Wagyu Burger", preparationTime: 10.0)
        let fries = MenuItem(name: "Truffle Fries", preparationTime: 10.0)
        let shake = MenuItem(name: "Chocolate Shake", preparationTime: 10.0)
        
        let newOrder = Order(tableNumber: tableNumber, items: [burger, fries, shake])
        
        // Push the order directly into the active AsyncStream loop
        orderContinuation?.yield(newOrder)
    }
    
    
    
    
    
    //MARK: - Cancel
    
    // Safe UI cancellation trigger
    /// called when you tap X on each row
    func cancelOrder(id: UUID) {
        print("Jack: will cancel order ....")
        runningTasks[id]?.cancel()
        runningTasks.removeValue(forKey: id)
        
        
        pipelineTask?.cancel()
    }
    
    
    // MARK: - State Mutators (MainActor guaranteed)
    
    /// caled from
    private func updateStatus(for id: UUID, to status: String, progress: Double) {
        if let index = activeOrders.firstIndex(where: { $0.id == id }) {
           print("Jack: .... updateStatus() to: \(status)")
            activeOrders[index].status = status
            activeOrders[index].progress = progress
        }
    }
    
    
    
    
    /// called from **processOrder**
    private func updateProgress(orderID: UUID, itemProgress: Double, totalItems: Int) {
        print("Jack: .... updateProgress - for: \(orderID) to  \(itemProgress.description)")
        if let index = activeOrders.firstIndex(where: { $0.id == orderID }) {
            //print("Jack: .... updateProgress - in if block")
            // Aggregate child progress loops mathematically for smooth bar progression
            let currentProgress = activeOrders[index].progress
            let incrementalProgress = (itemProgress / Double(totalItems)) * 0.1
            let x = min(0.95, currentProgress + incrementalProgress)
            
            print("Jack: .... updateProgress - curent: \(currentProgress) increm: \(incrementalProgress) setting new value to \(x)")
           // activeOrders[index].progress = min(0.95, currentProgress + incrementalProgress)
            
            
            activeOrders[index].progress = min(0.95, itemProgress)
        
        }
    }
    
    
    
    
} // end class RestaurantManager











// MARK: - 2. Kitchen Actor

actor Kitchen {
    
    /// Simulates cooking a single item with cooperative cancellation
    /// uses a completion handler to send updated completion value
    /// called from **processOrder()**
    func cookItem(_ item: MenuItem, onProgress: @Sendable (Double) async -> Void) async throws {
        let steps = 5
        let stepDuration = item.preparationTime / Double(steps)  /// 10 / 5 = 2
        
        for step in 1...steps {
            try Task.checkCancellation()
            try await Task.sleep(for: .seconds(stepDuration))
            let currentProgress = Double(step) / Double(steps) ///  1 / 5 = 0.2 ,    2 / 5 = 0.4
            await onProgress(currentProgress)
        }
        
    }
} //end Kitchen














// MARK: - 1. Core Data Models
struct MenuItem: Sendable, Hashable {
    let id: UUID = UUID()
    let name: String
    let preparationTime: Double
}

struct Order: Sendable, Identifiable, Hashable {
    let id: UUID = UUID()
    let tableNumber: Int
    let items: [MenuItem]
}

// Visual state tracker for individual orders in the UI
struct OrderState: Identifiable, Sendable, Hashable {
    let id: UUID
    let tableNumber: Int
    var status: String
    var progress: Double // 0.0 to 1.0
}




