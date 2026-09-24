import SwiftUI
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true



let task = Task {
    let stream = AsyncStream<Int> { continuation in
        continuation.onTermination = { _ in
            print("2. Stream onTermination executed") // Runs second
        }
        
        // Simulating work
        continuation.yield(1)
    }

    await withTaskCancellationHandler {
        for await item in stream {
            if Task.isCancelled {
                print("will break")
                break
            }
            print("Received \(item)")
        }
    } onCancel: {
        print("1. Cancellation handler executed") // Runs first
    }
}



    task.cancel()
   // PlaygroundPage.current.finishExecution()




