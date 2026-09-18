//: [Previous](@previous)

import UIKit


enum FetchResult {
    case favorites([String])
    case ages(Set<Int>)
    case images([UIImage])
    case typiCodes([TypiCode])
}


struct User {
    var favorites: [String]
    var ages: Set<Int>
    var images: [UIImage]
    var typiCodes: [TypiCode]
}


struct TypiCode: Codable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool = false
}


func downloadImage(url: String) async throws -> UIImage? {
    guard let url = URL(string: url) else { return nil }
    let (data, _) = try await URLSession.shared.data(from: url)
    if let img = UIImage(data: data) {
        return img
    }
    return nil
}




func downloadTypiCodes(url: String) async throws -> [TypiCode]? {
    guard let url = URL(string: url) else { return nil }
    let (data, response) = try await URLSession.shared.data(from: url)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        print("Invalid response or status code")
        return nil
    }
    
    let decoder = JSONDecoder()
    let codes = try decoder.decode([TypiCode].self, from: data)
    return codes
    
}





func fetchData(photoURLs: [String], typiCodeUrl: String) async throws -> User {
    
    return try await withThrowingTaskGroup(of: FetchResult.self) { group in
        
        /// Task # 1
        group.addTask {
            return .favorites(["a", "b", "c"])
        }
        
        
        /// Task # 2
        group.addTask {
            return .ages([1, 2, 3])
        }
        
        /// Task # 3
        group.addTask {
            /// create sub task
            let imgs = try await withThrowingTaskGroup(of: UIImage?.self) { imageGroup in
                for url in photoURLs {
                    imageGroup.addTask {
                        try? await downloadImage(url: url) // entire group should not fail if one fails
                    }
                }
                
                var collectionImages: [UIImage] = []
                for try await result in imageGroup {
                    if let result = result {
                        collectionImages.append(result)
                    }
                }
                return collectionImages
            } //end inside task
            
            return .images(imgs)
            
        } //addTask
        
        
            
        /// Task # 4
        group.addTask {
            
            /// create sub task
            let codes = try await withThrowingTaskGroup(of: [TypiCode]?.self) { group in
                group.addTask {
                    try await downloadTypiCodes(url: typiCodeUrl)
                }
                
                var typiCodes: [TypiCode] = []
                for try await result in group {
                    if let result = result {
                        typiCodes.append(contentsOf: result)
                    }
                }
                return typiCodes
            }
            
            return .typiCodes(codes)
            
        } //addTask
        
        
        
        
        
        
        
        
        
        
        
    
        /// collect results
        
        var fav: [String] = []
        var ages: Set<Int> = []
        var images: [UIImage] = []
        var typiCodes: [TypiCode] = []
        
        for try await value in group {
            switch value {
            case .favorites(let f):
                fav = f
            case .ages(let i):
                ages = i
            case .images(let img):
                images = img
            case .typiCodes(let codes):
                typiCodes = codes
            }
        }
        
        return User(favorites: fav, ages: ages, images: images, typiCodes: typiCodes)
    } // end group in
    
} //end function
    




//MARK: - *************** Main Task *********************


Task {
    
    do {
        let photoURLs: [String] = ["https://hws.dev/img/logo3.png",
                                   "https://hws.dev/paul2.jpg",
                                   "https://developer.apple.com/news/images/og/swiftui-og.png",
                                   "https://picsum.photos/id/237/300/300",
                                   "https://picsum.photos/id/12/200"]
        let u = try await fetchData(photoURLs: photoURLs, typiCodeUrl: "https://jsonplaceholder.typicode.com/todos")
       // print("I have an user: \(u)")
        print("I have an user with : \(u.images.count) images")
        
        print("************* ")
        
        for code in u.typiCodes {
            print("\(code)")
        }
        
        print("***************")
        
    }catch {
        print("we have error: \(error)")
    }
}
