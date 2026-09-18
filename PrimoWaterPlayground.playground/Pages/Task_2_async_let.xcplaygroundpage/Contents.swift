//: [Previous](@previous)

import Foundation
import UIKit




func fetchImage(url: String) async throws -> UIImage? {
    guard let url = URL(string: url) else {
        print("Invalid URL .....")
        return nil
    }
    let (data, _) = try await URLSession.shared.data(from: url)
    print("processing data for: \(url)")
    if let img = UIImage(data: data) {
        return img
    }
    print("nil for: \(url)")
    return nil
}



Task {
    do {
        async let one = fetchImage(url: "https://hws.dev/img/logo.png")
        async let two =  fetchImage(url: "https://hws.dev/paul2.jpg")
        async let three = fetchImage(url: "https://www.gstatic.com/webp/gallery/1.jpg")
        async let four = fetchImage(url: "https://picsum.photos/id/237/200/300")
        
        
        let final = try await [one, two, three, four]
    }catch {
        print("we have error: \(error)")
    }
}
