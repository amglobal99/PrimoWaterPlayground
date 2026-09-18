//: [Previous](@previous)

import Foundation
import SwiftUI



enum FetchResult {
    case images([UIImage]?)
    case articles([Typicode]?)
}

struct Typicode: Codable {
    var id: Int
    var userId: Int
    var title: String
    var completed: Bool = false
}

struct ResultJack {
    var images: [UIImage]?
    var articles: [Typicode]?
}




func fetchData(urls: [String]) async throws -> ResultJack {

    return try await withThrowingTaskGroup(of: FetchResult.self) { group in
        
        /// Task # 1
        group.addTask {
            let images = try await withThrowingTaskGroup(of: UIImage?.self) { group1 in
                for url in urls {
                    group1.addTask {
                        try? await downloadImage(url: url)
                    }
                }
                
                var imgCollection: [UIImage] = []
                for try await result in group1 {
                    /// remove nil results
                    if let result = result {
                        imgCollection.append(result)
                    }
                }
                
                /// return value for inside task
                return imgCollection
            } /// images =
            
            /// retrurn value for this task
            return .images(images)
        } //end group1
        
        
        
        
        /// Task #
        group.addTask {
            let urlStr = "https://jsonplaceholder.typicode.com/todos"
            guard let url = URL(string: urlStr) else {
                return .articles([])
            }
            do {
                let (data,_) = try await URLSession.shared.data(from: url)
                let articles = try JSONDecoder().decode([Typicode].self, from: data)
                return .articles(articles)
            }catch {
                return .articles(nil)
            }
            
        }
        
    
        
        var images: [UIImage] = []
        var articles: [Typicode] = []
        
        for try await result in group {
            switch result {
            case .images(let img):
                if let img = img {
                    images = img
                }
            case .articles(let art):
                if let art = art {
                    articles = art
                }
            }
        }
        
        return ResultJack(images: images, articles: articles)
    }
    
} //end func






func downloadImage(url: String) async throws -> UIImage? {
    guard let url = URL(string: url) else {
        throw URLError(.badURL)
    }
    let (data,response) = try await URLSession.shared.data(from: url)
    if let img = UIImage(data: data) {
        return img
    }
    return nil
}





/// ******************************* MAIN BLCOK ***************************************************


func getData() async throws -> ResultJack? {
    do {
        let photoURLs: [String] = ["https://hws.dev/img/logo.png",
                                   "https://hws.dev/paul2.jpg",
                                   "https://developer.apple.com/news/images/og/swiftui-og.png",
                                   "https://picsum.photos/id/237/300/300",
                                   "https://picsum.photos/id/12/200"]
        return try await fetchData(urls: photoURLs)
    }catch {
        print("we have error: \(error)")
        handleError(error)
    }
    return nil
}




func handleError(_ error: Error) {
    print("I am handling error: \(error)")
}



let a = try await getData()

print("I have \(a?.images?.count) photos.")
print("I have \(a?.articles?.count) artciles.")



//if let articles = a?.articles {
//    print("************************************")
//    for i in articles {
//        print(i.title)
//    }
//    print("************************************")
//}
