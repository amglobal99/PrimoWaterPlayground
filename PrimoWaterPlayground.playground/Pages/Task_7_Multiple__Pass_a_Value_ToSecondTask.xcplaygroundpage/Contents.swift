//: [Previous](@previous)

import Foundation


struct NewsItem: Decodable {
    let id: Int
    let title: String
    let url: URL
}

struct HighScore: Decodable {
    let name: String
    let score: Int
}


/// ************ SIMULATenouS *********************>

func fetchUpdates() async throws -> ([NewsItem],[HighScore]) {
    
    var result: ([NewsItem],[HighScore]) = ([], [])
    
    let newsTask = Task { () -> [NewsItem] in
        let url = URL(string: "https://hws.dev/headlines.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([NewsItem].self, from: data)
    }
    
    let highScoreTask = Task { () -> [HighScore] in
        let url = URL(string: "https://hws.dev/scores.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([HighScore].self, from: data)
    }
    
    async let news = try newsTask.value
    async let highScores = try highScoreTask.value
    result = try await (news, highScores)

    return result
}







//MARK: - Sequential -- PASS RESULT FROM FIRST CALL TO SECOND TASK

func fetchUpdatesSequential() async throws -> ([NewsItem],[HighScore]) {
    
    let newsTask = Task { () -> [NewsItem] in
        let url = URL(string: "https://hws.dev/headlines.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([NewsItem].self, from: data)
    }
    
    let news = try await newsTask.value
    
    let highScoreTask = Task { () -> [HighScore] in
        for (index, i) in news.enumerated() {
            print("Jack: news item: \(index) - \(i.title)")
        }
        
        let url = URL(string: "https://hws.dev/scores.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([HighScore].self, from: data)
    }
    
    
    let highScores = try await highScoreTask.value
    
    return (news, highScores)
}





Task {
    do {

      // let myResults: ([NewsItem],[HighScore]) = try await fetchUpdates()   // concurrrent execution
        let myResults: ([NewsItem],[HighScore]) = try await fetchUpdatesSequential()  // sequential execution
        
        
        print("Jack: \(myResults.0.count) news items and \(myResults.1.count) high scores. ")
    }catch{
        print("sorry...error")
    }
}



