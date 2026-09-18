import SwiftUI
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

enum CustomError: Error {
    case invalidUrl
    case invalieResponse
    case imageNotFound
}


var testUrls: [String] = ["https://hws.dev/img/logo.png",
                           "https://hws.dev/paul2.jpg",
                           "https://developer.apple.com/news/images/og/swiftui-og.png",
                           "https://picsum.photos/id/237/300/300",
                           "https://picsum.photos/id/12/200"]





func downloadStats() async -> [Int] {
    
    let maxTasks = 3
    
    return await withTaskGroup(of: Int.self) { group in
        var result: [Int] = []
        
        for i in 1...10 {
            if i > maxTasks {
                if let value = await group.next() {
                    result.append(value)
                }
            }
            
            group.addTask {
                getStat(num: i)
            }
        } //for
            
        while let val = await group.next() {
            result.append(val)
        }
        
        return result
    }
    
}









func getStat(num: Int) -> Int {
    return num * 5
}


Task {
    let soln = await downloadStats()
    print(soln)
    PlaygroundPage.current.finishExecution()
}
















/*
func downloadImage(url: String) async throws -> UIImage? {
    guard let url = URL(string: url) else {
        throw CustomError.invalidUrl
    }
    let (data,response) = try await URLSession.shared.data(from: url)
    guard let resp = response as? HTTPURLResponse, resp.statusCode == 200 else {
        throw CustomError.invalieResponse
    }
    if let image = UIImage(data: data) {
        return image
    }
    return nil
}



func fetchImages(urls: [String]) async throws -> [UIImage]  {
    
    return try await withThrowingTaskGroup(of: UIImage?.self) { group in
        for url in urls {
            group.addTask {
                return try await downloadImage(url: url)
            }
        }
        
        var myImages: [UIImage] = []
        for try await result in group {
            if let res = result {
                myImages.append(res)
            }
        }
        return myImages
    }
}





Task {
    let imgs = try await fetchImages(urls: testUrls)
    print(imgs.count)
    
    
    PlaygroundPage.current.finishExecution()

}


*/


