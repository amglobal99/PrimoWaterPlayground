//: [Previous](@previous)

import Foundation
import UIKit



enum CustomError: Error {
    case invalidInput(url: String)
    case imageNotFound(url: String)
}


func getDateString() -> String {
    let now = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    return dateFormatter.string(from: now)
}





func downloadImage(url: String) async throws -> UIImage {
    try await Task.sleep(for: .seconds(5))
    guard let urlStr = URL(string: url) else {
        throw CustomError.invalidInput(url: url)
    }
    
    let (data, _ ) = try await URLSession.shared.data(from: urlStr)
    if let img = UIImage(data: data) {
        print("\(getDateString()) ... downloadImage SUCCESS for url: \(url)...")
        return img
    }
    print("\(getDateString()) ... downloadImage ERROR  for url: \(url)...")
    throw CustomError.imageNotFound(url: url)
}

 
 
 
func fetchMyImages(photoURLs: [String]) async throws -> [UIImage] {
    
    return try await withThrowingTaskGroup(of: UIImage.self) { group in
        for url in photoURLs {
            group.addTask {
                try await downloadImage(url: url)
            }
        }
        
        var myPhotos: [UIImage] = []
        for try await result in group {
            print("\(getDateString()) RESULT >>>> ... processing an image..")
            myPhotos.append(result)
        }
        return myPhotos
    }
} //end func















Task {
    do {
        let photoURLs: [String] = ["https://hws.dev/img/logo.png",
                                   "https://hws.dev/paul2.jpg",
                                   "https://developer.apple.com/news/images/og/swiftui-og.png",
                                   "https://picsum.photos/id/237/300/300",
                                   "https://picsum.photos/id/12/200"]
        let myPics = try await fetchMyImages(photoURLs: photoURLs)
        
        print("Jack -  I have \(myPics.count) photos")
        for (ind, p) in myPics.enumerated() {
            //print("\(ind) - \(p.debugDescription)")
        }
        
    }catch {
        print("we have an error: \(error)")
    }
}
