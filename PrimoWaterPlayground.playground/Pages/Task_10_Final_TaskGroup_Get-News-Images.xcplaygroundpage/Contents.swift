
import UIKit


struct NewsItem: Decodable {
    let id: Int
    let title: String
    let url: URL
}

struct HighScore: Decodable {
    let name: String
    let score: Int
}

enum FetchResult {
    case scores([HighScore]?)
    case news([NewsItem]?)
    case images([UIImage]?)
    case jsonString(String?)
}

enum CustomError: Error {
    case invalidInput(url: String)
    case imageNotFound(url: String)
    case invalidResponse
}

struct ResultJack {
    var scores: [HighScore]?
    var news: [NewsItem]?
    var images: [UIImage]?
    var jsonString: String?
}







// ***************************************************************************




//MARK: - ************ Download Image

func downloadImageFromUrl(url: String) async throws -> UIImage {
    try await Task.sleep(for: .seconds(5))
    guard let urlStr = URL(string: url) else {
        throw CustomError.invalidInput(url: url)
    }
    let (data, _ ) = try await URLSession.shared.data(from: urlStr)
    if let img = UIImage(data: data) {
        return img
    }
    throw CustomError.imageNotFound(url: url)
}

 




//MARK:  - =================================== MAIN FUNC ==================================


func fetchData(photoURLs: [String]) async throws -> ResultJack {
    
    /// This is our task group
    return try await withThrowingTaskGroup(of: FetchResult.self) { group in
    
        
        
     /// Task # 1 - Pass value from First Task to Second
        group.addTask {
            do {
                let newsTask = Task { () -> [NewsItem] in
                    guard let url = URL(string: "https://hws.dev/headlines.json") else {
                        return []
                    }
                    let (data, _) = try await URLSession.shared.data(from: url)
                    return try JSONDecoder().decode([NewsItem].self, from: data)
                }
                
                let news = try await newsTask.value
                
                let highScoreTask = Task { () -> [HighScore] in
                    for (index, i) in news.enumerated() {
                        print("Jack: news item: \(index) - \(i.title)")
                    }
                    
                    guard let url = URL(string: "https://hws.dev/scores.json") else {
                        return []
                    }
                    let (data, _) = try await URLSession.shared.data(from: url)
                    return try JSONDecoder().decode([HighScore].self, from: data)
                }
                
                let highScores = try await highScoreTask.value
                return .scores(highScores)
                
            }catch {
                return .scores(nil)
            }
            
        }// group.addTask
        
        
        
    
    
        //Task # 2 ........... NEWS
        
        group.addTask {
            do{
                let newsTask = Task { () -> [NewsItem]? in
                    guard let url = URL(string: "https://hws.dev/headlines.json") else {
                        return nil
                    }
                    let (data, _) = try await URLSession.shared.data(from: url)
                    return try JSONDecoder().decode([NewsItem].self, from: data)
                }
                var news: [NewsItem]?
                news = try await newsTask.value
                return .news(news)
            }catch{
                return .news(nil)
            }
        }
        
        
    
        
        /// Task # 3 - Get Images .... NESTED TASK
        group.addTask {
            do {
                /// create nested sub task
                let imgs = try await withThrowingTaskGroup(of: UIImage?.self) { imageGroup in
                    for url in photoURLs {
                        imageGroup.addTask {
                            try? await downloadImageFromUrl(url: url)
                        }
                    }
                    var collectionImages: [UIImage] = []
                    for try await result in imageGroup {
                        if let result = result {
                            collectionImages.append(result)
                        }
                    }
                    return collectionImages
                } //end sub task
                
                return .images(imgs)
            }catch {
                return .images(nil)
            }
        } //addTask
        
        
        
        
        
        
        
        /// collect results
        var scores: [HighScore]?
        var news: [NewsItem]?
        var images: [UIImage]?
        var jsonString: String?
        
        for try await value in group {
            switch value {
            case .scores(let f):
                scores = f
            case .news(let i):
                news = i
            case .images(let img):
                images = img
            case .jsonString(let str):
                jsonString = str
            }
        }
        
        return ResultJack(scores: scores,  news: news, images: images, jsonString: jsonString)
        
    } //group in
    
}








func getData() async throws -> ResultJack? {
    do {
        let photoURLs: [String] = ["https://hws.dev/img/logo.png",
                                   "https://hws.dev/paul2.jpg",
                                   "https://developer.apple.com/news/images/og/swiftui-og.png",
                                   "https://picsum.photos/id/237/300/300",
                                   "https://picsum.photos/id/12/200"]
        return try await fetchData(photoURLs: photoURLs)
    }catch {
        print("we have error: \(error)")
        handleError(error)
    }
    
    /// finally return nil
    return nil
}




func handleError(_ error: Error) {
    print("I am handling error: \(error)")
}




let a = try await getData()
print("My news items: \(String(describing: a?.news?.count))")
