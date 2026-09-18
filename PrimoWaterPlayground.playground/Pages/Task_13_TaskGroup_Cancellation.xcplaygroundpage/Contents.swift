//: [Previous](@previous)

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true


// 1. Mock function for listing photos
func listPhotos(inGallery name: String) async -> [String] {
    // Simulate a short network delay
    try? await Task.sleep(nanoseconds: 100_000_000)
    return ["sunset.jpg", "beach.jpg", "mountain.jpg"]
}



// 2. Mock function for downloading a photo
func downloadPhoto(named: String) async -> Data? {
    // Simulate download time
    try? await Task.sleep(nanoseconds: 200_000_000)
    
    // Return mock binary data based on the name
    return "FakeImageDataFor_\(named)".data(using: .utf8)
}



// 3. Calling your function
func loadGallery() async {
    let photos = await withTaskGroup(of: Data?.self) { group in
        let photoNames = await listPhotos(inGallery: "Summer Vacation")
        for name in photoNames {
            let added = group.addTaskUnlessCancelled {
                Task.isCancelled ? nil : await downloadPhoto(named: name)
            }
            guard added else { break }
        }
        var results: [Data] = []
        for await photo in group {
            if let photo {
                results.append(photo)
            }
        }
        return results
    }
    
    print("Downloaded \(photos.count) photos.")
}












Task{
   await loadGallery()
    
    PlaygroundPage.current.finishExecution()
}





//**********************************************************************


//MARK: - simple task cancel



var heavyTask: Task<Void, Error>

heavyTask = Task {
    print("Task started.")
    for i in 1...5 {
        if Task.isCancelled {
            print("Task was cancelled mid-way!")
            break
        }
        print("Working on step \(i)...")
        
        do {
            try await Task.sleep(for: .seconds(1))
        } catch {
            print("Task was cancelled mid-way during sleep!")
            break
        }
    }
    print("Task finished.")
    PlaygroundPage.current.finishExecution()
}



Task {
    try await Task.sleep(for: .seconds(2.5))
    print("Calling cancel() on the task...")
    heavyTask.cancel()
   
    
    PlaygroundPage.current.finishExecution()

}



//MARK: - Cancel a Shift Using a Timer



/*

enum ExampleError: Error {
    case badURL
}

func testCancellation() async {
    do {
        try await withThrowingTaskGroup(of: Void.self) { group in
            
            
            group.addTask {
                try await Task.sleep(for: .seconds(1))
                throw ExampleError.badURL
            }

            group.addTask {
                try await Task.sleep(for: .seconds(2))
                print("Task is cancelled: \(Task.isCancelled)")
            }

            try await group.next()
        }
    } catch {
        print("Error thrown: \(error)")
    }
}

await testCancellation()

*/










/*

struct NewsStory: Identifiable, Decodable {
    let id: Int
    let title: String
    let strap: String
    let url: URL
}


let url1  = URL(string: "http:www.yahoo.com")!


let n1 = NewsStory(id: 2, title: "Miami", strap: "t1", url: url1)
let n2 = NewsStory(id: 2, title: "Miami", strap: "t1", url: url1)
let n3 = NewsStory(id: 2, title: "Miami", strap: "t1", url: url1)
let n4 = NewsStory(id: 2, title: "Miami", strap: "t1", url: url1)
let n5 = NewsStory(id: 2, title: "Miami", strap: "t1", url: url1)



func loadStories() async {
    var stories = [NewsStory]()

    do {
        try await withThrowingTaskGroup(of: [NewsStory].self) { group in
            
            for i in 1...5 {
                group.addTask {
                        
                    if i == 1 {
                        return [n1]
                    }else if i == 2 {
                        return []
                    }else if i == 3 {
                        return [n3]
                    }else if i == 4 {
                        return [n4]
                    }else {
                        return [n5]
                    }
                    
                    
                }
            }
            
            for try await result in group {
                if result.isEmpty {
                    group.cancelAll()
                } else {
                    stories.append(contentsOf: result)
                }
            }
            
            
        }
    } catch {
        print("Failed to load stories: \(error.localizedDescription)")
    }
}



await loadStories()

*/




















/*


/// test output
/// we have error: CancellationError()
/// our result is: Group Cancellation
func printMessage() async {
    let result = await withThrowingTaskGroup(of: String.self) { group in
        
        group.addTask {
            return "Group"
        }
        
        
        group.addTask {
            return "Cancellation"
        }

        group.addTask {
            try await Task.sleep(for: .seconds(1))
            try Task.checkCancellation()
            return "Testing"
        }
        
        
        group.cancelAll()
        var collected = [String]()

        do {
            for try await value in group {
                collected.append(value)
            }
        } catch {
            print("we have error: \(error)")
        }

        return collected.joined(separator: " ")
    }

    print("our result is: \(result)")
}

await printMessage()


 PlaygroundPage.current.finishExecution()


*/









/*
 
 
 enum ExampleError: Error {
     case badURL
 }

 func testCancellation() async  {
     
     do {
         try await withThrowingTaskGroup(of: Void.self) { group in
             
             group.addTask {
                 try await Task.sleep(for: .seconds(1))
                 throw ExampleError.badURL
             }
             
             group.addTask {
                 try await Task.sleep(for: .seconds(2))
                 print("Task is cancelled: \(Task.isCancelled)")
             }
             
             try await group.next()
             group.cancelAll()
         }
         
     }catch {
         print("we have error: \(error)")
     }
     
 }



 await testCancellation()







 PlaygroundPage.current.finishExecution()

 */
