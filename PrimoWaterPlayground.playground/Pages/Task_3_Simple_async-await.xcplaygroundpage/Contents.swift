
import Foundation
import UIKit




func fetchData() async {
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {
        print("Invalid URL")
        return
    }
    
    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("Invalid response or status code")
            return
        }
        
        // You can now process the 'data' received
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Received data: \(jsonString)")
        }
    } catch {
        print("Error fetching data: \(error)")
    }
    
}



Task {
    await fetchData()
}



