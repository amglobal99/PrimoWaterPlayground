//: [Previous](@previous)

import UIKit


enum FetchResult {
    case favorites([String])
    case ages(Set<Int>)
    case images([UIImage])
}


struct User {
    var favorites: [String]
    var ages: Set<Int>
    var images: [UIImage]
}


//MARK: - Download Image

func downloadImage(url: String) async throws -> UIImage? {
    guard let url = URL(string: url) else { return nil }
    let (data, _) = try await URLSession.shared.data(from: url)
    if let img = UIImage(data: data) {
        return img
    }
    return nil
}


//MARK: - Fetch Data


func fetchData() async throws -> User {
    
    return try await withThrowingTaskGroup(of: FetchResult.self) { group in
        
        group.addTask {
            return .favorites(["a", "b", "c"])
        }
        
        group.addTask {
            return .ages([1, 2, 3])
        }
        
        
        group.addTask {
            if let img =  try await downloadImage(url: "https://hws.dev/paul2.jpg") {
                return .images([img])
            }
            return .images([])
        }
        
        
        var fav: [String] = []
        var ages: Set<Int> = []
        var images: [UIImage] = []
        
        for try await value in group {
            switch value {
            case .favorites(let f):
                fav = f
            case .ages(let i):
                ages = i
            case .images(let img):
                images = img
            }
        }
        
        return User(favorites: fav, ages: ages, images: images)
    } // end group in
    
} //end function
    




Task {
    
    do {
        let photoURLs: [String] = ["https://hws.dev/img/logox.png",
                                   "https://hws.dev/paul2.jpg",
                                   "https://developer.apple.com/news/images/og/swiftui-og.png",
                                   "https://picsum.photos/id/237/300/300",
                                   "https://picsum.photos/id/12/200"]
        let u = try await fetchData()
        print("I have an user: \(u)")
    }catch {
        print("we have error: \(error)")
        handleError(error)
    }
}



func handleError(_ error: Error) {
    print("I am handling error: \(error)")
}
