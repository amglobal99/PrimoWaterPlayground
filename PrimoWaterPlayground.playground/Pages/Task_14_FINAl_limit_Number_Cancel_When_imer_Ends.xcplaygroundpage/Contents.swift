//: [Previous](@previous)

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true


//MARK: -

// 1. Mock function for listing photos
func listPhotos(inGallery name: String) async -> [String] {
    // Simulate a short network delay
    try? await Task.sleep(nanoseconds: 100_000_000)
    return ["sunset.jpg", "beach.jpg", "mountain.jpg","river.jpg","tree.jpg","grass.jpg"]
}

// 2. Mock function for downloading a photo
func downloadPhoto(named: String) async -> Data? {
    // Simulate download time
    try? await Task.sleep(nanoseconds: 200_000_000)
    
    // Return mock binary data based on the name
    return "FakeImageDataFor_\(named)".data(using: .utf8)
}



///
///    1. This function limits simulatneous tasks to only 3 at a time
///    2. Before adding a task to pool, it cheks if group has been canceled
///    3.
///    the function returns an array of Data
func loadGallery(limit: Int) async -> [Data] {
    var results: [Data] = []
    
    return await withTaskGroup(of: Data?.self) { group in
        /// make first async call to get list of images
        let photoNames = await listPhotos(inGallery: "Summer Vacation")
        /// make sure list is not empty
        guard !photoNames.isEmpty else {
            return []
        }
        
        // 1. Seed the group up to the concurrency limit (3 tasks)
        for (index,name) in photoNames.enumerated() {
            /// ** Check if we already have 3 tasks in pipeline **
            ///  If yes, we wait for a task to complete ....
            ///  we add its result to our array. Then, we add new task in following block
            if index >= limit { /// index is now 3,4,5, ......
                if let optionalResult = await group.next(), let result = optionalResult {
                    results.append(result)
                }
            }

            /// ** ADD task only if NOT CANCELED **
            let added = group.addTaskUnlessCancelled {
                Task.isCancelled ? nil : await downloadPhoto(named: name)
            }
            /// Break  out of loop if earlier statement returns FALSE
            guard added else { break }
        } //for loop
        
        /// Drain the remaining tasks still running in the group ( there will be 3 last tasks that will be processed here)
        for await remainingResult in group {
            if let result = remainingResult {
                results.append(result)
            }
        }
        
        // ** Return the Results **
        return results
    } //withThrowingTask
    
} //end func



Task{
    let photos =  await loadGallery(limit: 3)
    print("we have \(photos.count) phtots")
    PlaygroundPage.current.finishExecution()
}




/// *********************************************************************




//MARK: - Example 2 .... non optional Result
/// Run task group with multiple tasks .... limit simultaneous tasks to 3
/// AlOS: Check if Task has been cancelled


func processTasksConcurrently(array: [Int], limit: Int) async -> [Int]{
    var results: [Int] = []
    
    await withTaskGroup(of: Int.self) { group in
        for (index, val) in array.enumerated() {
            
            if index >= limit {
                if let result = await group.next() {
                    results.append(result)
                }
            }
       
            /// ** ADD task only if NOT CANCELED **
            let added = group.addTaskUnlessCancelled {
                Task.isCancelled ? 0 : await fetchResult(for: val)
            }
            /// Break  out of loop if earlier statement returns FALSE
            guard added else { break }
        } // for loop
        
        for await remainingResult in group {
            print("   appending \(remainingResult)")
            results.append(remainingResult)
        }
    } //group in
    
    return results
}




func fetchResult(for input: Int) async -> Int {
    try? await Task.sleep(for: .seconds(1))
    return input * 10
}




Task{
    let ans  = await processTasksConcurrently(array:  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], limit: 3)
    print(ans)
    
    PlaygroundPage.current.finishExecution()
}
