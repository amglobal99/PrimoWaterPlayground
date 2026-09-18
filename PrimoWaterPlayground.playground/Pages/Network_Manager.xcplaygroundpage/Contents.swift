//: [Previous](@previous)

import Foundation







import Foundation

@globalActor
actor NetworkActor {
    static let shared = NetworkActor()
}


// MARK: - Network Manager Actor

@NetworkActor
final class NetworkManager {

    static let shared = NetworkManager()
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    //MARK: - Request
    
    /// Generic fetch method for any Codable type
    func request<T: Decodable>(_ endpoint: URLStringConvertible) async throws -> [T] {
        guard let url = URL(string: endpoint.urlString) else {
            throw NetworkErrorNew.invalidURL
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw NetworkErrorNew.underlying(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkErrorNew.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkErrorNew.httpError(statusCode: httpResponse.statusCode)
        }

        do {
            return try decoder.decode([T].self, from: data)
        } catch {
            throw NetworkErrorNew.decodingError(error)
        }
    } //end func
    
    
    
    
    
    /*
    /// Generic fetch method for any Codable type
    func request<T: Decodable>(_ endpoint: URLStringConvertible) async throws -> T {
        guard let url = URL(string: endpoint.urlString) else {
            throw NetworkErrorNew.invalidURL
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw NetworkErrorNew.underlying(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkErrorNew.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkErrorNew.httpError(statusCode: httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkErrorNew.decodingError(error)
        }
    } //end func
    */
    
    
} // end class




// MARK: - Helper Protocol for String-to-URL safety
@NetworkActor
protocol URLStringConvertible {
    var urlString: String { get }
}


extension String: URLStringConvertible {
    var urlString: String { self }
}



//MARK: - Enums


// MARK: - Network Error
enum NetworkErrorNew: LocalizedError {
    
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case underlying(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The URL provided was invalid."
        case .invalidResponse: return "The server response was invalid."
        case .httpError(let code): return "HTTP error occurred with status code: \(code)."
        case .decodingError(let error): return "Failed to decode response: \(error.localizedDescription)"
        case .underlying(let error): return error.localizedDescription
        }
    }
}



struct Todo: Decodable, Sendable {
    var id: Int
    var userId: Int
    var title: String
    var completed: Bool
}



extension Todo: Equatable, Hashable {
    
    public static func == (lhs: Todo, rhs: Todo) -> Bool {
        return lhs.id == rhs.id &&
        lhs.userId == rhs.userId
    }
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(userId)
    }
    
}


 Task {
     do {
         let todos: [Todo] = try await NetworkManager.shared.request("https://jsonplaceholder.typicode.com/todos")
         for t in todos {
             print(t)
         }
     } catch {
         print(error.localizedDescription)
     }
 }
