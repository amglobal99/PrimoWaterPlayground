//: [Previous](@previous)

import Foundation
import PlaygroundSupport



PlaygroundPage.current.needsIndefiniteExecution = true


//MARK: -  Example #1

/// Limit the nuber of tasks that an execute ..... for example, I want to process 100 photos .... but I will do 3 at a time
func processTasksConcurrently() async {
    let array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    var results: [Int] = []
    
    await withTaskGroup(of: Int.self) { group in
        for (index, val) in array.enumerated() {
            // 1. If 3 tasks are already running, wait for one to finish
            if index >= 3 {
                if let finishedResult = await group.next() {
                    results.append(finishedResult)
                }
            }
            
            // 2. Add the next task to the pool
            group.addTask {
                return await fetchResult(for: val)
            }
            
        } // for loop
        
        
        
        // 3. Drain the remaining tasks left in the group
        while let remainingResult = await group.next() {
            print("   appending \(remainingResult)")
            results.append(remainingResult)
        }
    } //group in
    
    
    print("All collected results: \(results)")
}




func fetchResult(for input: Int) async -> Int {
    try? await Task.sleep(for: .seconds(1))
    return input * 10
}







/*

Task{
   
   // await processTasksConcurrently()
    
    PlaygroundPage.current.finishExecution()
}

*/


//********************************************************************************




//MARK: - Example #2 ... Limit Number of Tasks PLUS Check if Task Cancelled



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



// 3. Calling your function
func loadGallery() async -> [Data?] {
    var results: [Data] = []
    
    return await withTaskGroup(of: Data?.self) { group in
        let photoNames = await listPhotos(inGallery: "Summer Vacation")
        for (index,name) in photoNames.enumerated() {
            if index >= 3 {
                if let finishedResult = await group.next(), let fin = finishedResult {
                    results.append(fin)
                }
            }
            
            let added = group.addTaskUnlessCancelled {
                Task.isCancelled ? nil : await downloadPhoto(named: name)
            }
            
            guard added else { break }
        } //for loop
        
        var results: [Data] = []
        for await photo in group {
            if let photo {
                results.append(photo)
            }
        }
        return results
    } //withThrowingTask
    
} //end func




Task{
    let photos =  await loadGallery()
    print("we have \(photos.count) phtots")
    PlaygroundPage.current.finishExecution()
}




/*
 /// very simple example
 
 func downloadStats() async -> [Int] {
     let maxConcurrent = 3
     
     return await withTaskGroup(of: Int.self) {group in
         var newStats: [Int] = []
         
         for i in 1...10 {
             if i > maxConcurrent {
                 if let ans = await group.next() {
                     newStats.append(ans)
                 }
             }
             
             group.addTask {
                 return  getStat(num: i)
             }
         }
         
         
         while let a = await group.next() {
             newStats.append(a)
         }
         
         return newStats
     }
     
     
 } //func





 func getStat(num: Int) -> Int {
     return num * 10
 }


 Task {
     let soln = await downloadStats()
     print(soln)
     PlaygroundPage.current.finishExecution()
 }
 */
