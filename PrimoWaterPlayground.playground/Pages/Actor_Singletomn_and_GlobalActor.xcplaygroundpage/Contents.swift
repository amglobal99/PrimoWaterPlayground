//: [Previous](@previous)

import Foundation
import UIKit


import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true


//MARK: - Example 1 .... Regular Singleton With Thread Safety


actor LoggingManager {
    static let shared =  LoggingManager()
    private init() {}
    
    func getSomething() {
        print("this is a test")
    }
}


/// To use
let myLogger = LoggingManager.shared
await myLogger.getSomething()





//MARK: - Example 2 .... Using Global Actor


//MARK: - *********** WEb Example *******

/*
Example: When you need a Global ActorImagine your database has a DatabaseManager, but you also have a separate CacheRepository class and a LegacyLogger class. You want to make sure they all run on the same background database thread to avoid race conditions or database locks, and you want them to talk to each other without constantly using await. [1] (/goto?url=CAESjgEB6zswFdsyzWylROFSMvwEKBRf2bMTQkem-zUxB3uTYAFJ5NjSJXxdRykNSvP_9DWLzTfav5oAiILwpVDinCHQ4a8uxjJ-ZmPs187KfsoZb45CIK2TzSfKzHazejJBwsJ--Zx7SV_WBkJWxuryJlUCeWLedsGG_EbmUPGoJKum3XZJOEuyLpMtQ7vnh4vh), [2] (/goto?url=CAEScgHrOzAVR7bAevWyabIuideaJzWYMQH9a6fsZIdCiERbofj1cK1iiizfO9gZSNkPBLshx-npQ08PbCFeSc6TkN9p8u0S-LShMbfMNHQmov4wMqJPcadtelra0BDUU07mxMGsyrlV6zca88TySNSyMBttlQ)swift// 1. Define the Global Actor

 */
 


@globalActor
actor DatabaseActor {
    static let shared = DatabaseActor()
    private init() {}
}



// 2. Class A is automatically isolated to the database context
@DatabaseActor
class DatabaseManager {
    func writeToDisk() { /* Synchronous internal database work */ }
}



// 3. Completely separate Class B runs on the EXACT SAME queue!
@DatabaseActor
class CacheRepository {
    
    func clearCache(manager: DatabaseManager) {
        // Because both are @DatabaseActor, this call is SYNCHRONOUS.
        // No 'await' needed here!
        manager.writeToDisk()
    }
}

























/*

struct NewsStory {
    let id: Int
    let title: String
    let strap: String
    let url: URL?
}


let n1 = NewsStory(id: 2, title: "Miami", strap: "t1", url: nil)
let n2 = NewsStory(id: 2, title: "Miami", strap: "t1", url: nil)
let n3 = NewsStory(id: 2, title: "Miami", strap: "t1", url: nil)
let n4 = NewsStory(id: 2, title: "Miami", strap: "t1", url: nil)
let n5 = NewsStory(id: 2, title: "Miami", strap: "t1", url: nil)



func loadStories() async {
    var stories: [NewsStory] = []

    do {
        try await withThrowingTaskGroup(of: [NewsStory].self) { group in
            
//            for i in 1...5 {
//                group.addTask {
//                        print("I am aqt \(i)")
//                    if i == 1 {
//                        return [n1]
//                    }else if i == 2 {
//                        return []
//                    }else if i == 3 {
//                        return [n3]
//                    }else if i == 4 {
//                        return [n4]
//                    }else {
//                        return [n5]
//                    }
//                    
//                    
//                }
//            }
//            
            
            group.addTask {
                return [n1]
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

PlaygroundPage.current.finishExecution()

