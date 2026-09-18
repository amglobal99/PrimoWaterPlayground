//: [Previous](@previous)

import Foundation
import Combine
import UIKit

import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true



struct TypiCode: Codable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool = false
}


var cancellables = Set<AnyCancellable>()


enum ExampleError: Swift.Error {
    case somethingWentWrong
}






func fetch1() -> AnyPublisher<TypiCode, Error> {
    let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
    return URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: TypiCode.self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
}

func fetch2() -> AnyPublisher<TypiCode, Error> {
    let url = URL(string: "https://jsonplaceholder.typicode.com/todos/2")!
    return URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: TypiCode.self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
}



func fetch3() -> AnyPublisher<UIImage?, Error> {
    let url = URL(string: "https://hws.dev/img/logo.png")!
    return URLSession.shared.dataTaskPublisher(for: url)
        // 1. Map the result to extract just the Data
        .map { $0.data }
        // 2. Convert Data to UIImage (returns nil if data is invalid)
        .map { UIImage(data: $0) }
        // 3. Cast the URLError to a general Error to match function signature
        .mapError { $0 as Error }
        // 4. Erase the complex internal types to AnyPublisher
        .eraseToAnyPublisher()
}
   



    let publisher1 = fetch1()
    let publisher2 = fetch2()
    let publisher3 = fetch3()
    



    let _ = publisher1.zip(publisher2, publisher3).sink(
        receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("Finished successfully")
            case .failure(let error):
                print("Failed with error: \(error)")
            }
        }, receiveValue: { (result1, result2, result3) in
            // result1 and result2 are both tuples of (data: Data, response: URLResponse)
            print("Received both results: \(result1), \(result2), \(String(describing: result3))")
        })
    .store(in: &cancellables)
    






/*
// THIS DOES NOT WROK YET
let cancellable = publisher1.zip(publisher2, publisher3).sink(
    receiveCompletion: { completion in
        switch completion {
        case .finished:
            print("Finished successfully")
        case .failure(let error):
            print("Failed with error: \(error)")
        }
    }, receiveValue: { (result1, result2, image) in
        // result1 and result2 are both tuples of (data: Data, response: URLResponse)
        print("Received both results: \(result1), \(result2), \(String(describing: image))")
        print("\(result1)  - \(result2) - \(String(describing: image))")
    }
).store(in: &cancellables)

*/




//
//let subject = PassthroughSubject<(TypiCode, TypiCode, UIImage),ExampleError>()
//subject.send(cancellable)
//















/*

let publisher = [1, 2, 3, 4, 5].publisher

// Subscribe to the publisher using the sink operator
var cancellable: AnyCancellable?

cancellable = publisher.sink(
    receiveCompletion: { completion in
        switch completion {
        case .finished:
            print("Publisher completed successfully.")
        case .failure(let error):
            print("Error: \(error)")
        }
    },
    receiveValue: { value in
        print("Received value: \(value)")
    }
)

// This keeps the subscription alive
// To release and cancel the subscription, set cancellable to nil
cancellable = nil

*/




/*

 // SIMPLE EXMPLE
 func fetchPlayers(from urlString: String) -> AnyPublisher<[String], Never> {
     guard let url = URL(string: urlString) else {
         return Just([]).eraseToAnyPublisher()
     }
     
     // Perform async request
     // ...
     return Just([]).eraseToAnyPublisher()
 }

 fetchPlayers(from: "badURL")
     .sink { players in
         print(players)
     }

 
*/
