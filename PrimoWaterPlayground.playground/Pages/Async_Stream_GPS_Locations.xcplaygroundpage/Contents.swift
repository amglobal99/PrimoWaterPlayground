//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import CoreLocation


PlaygroundPage.current.needsIndefiniteExecution = true


//MARK: -

/// ********** AsyncStream to get GPS Locations


@MainActor
final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    let stream: AsyncStream<CLLocation>
    private var continuation: AsyncStream<CLLocation>.Continuation
    var stopUpdatesTask: Task<Void,Error>?
    private let locationManager = CLLocationManager()
    
    override init() {
        let (stream, continuation) = AsyncStream.makeStream(of: CLLocation.self)
        self.stream = stream
        self.continuation = continuation
        
        super.init()
        
        continuation.onTermination = { @Sendable [weak self]  termination in
            switch termination {
            case .finished:
                print("Stream finished normally.")
                 Task {
                    await self?.stopLocationUpdates()
                }
            case .cancelled:
                print("Task reading the stream was cancelled.")
            @unknown default:
                break
            }
            
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    } //init
    
    
    
    deinit {
        
    }
    
    
    
    // Protocol requirement requires nonisolated. We hop into the actor instance immediately.
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task {
            await handleLocations(locations)
        }
    
    }
    
    
    private func handleLocations(_ locations: [CLLocation]) {
        MainActor.assumeIsolated {
           // guard let continuation = self.continuation else { return }
            for location in locations {
                continuation.yield(location)
            }
        }
    }
    
    
    private func stopLocationUpdates() {
        self.locationManager.stopUpdatingLocation()
    }
    
    
    
    func completeStream() {
        continuation.finish()
    }
    
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
} //end actor





//// Consume the stream

Task { @MainActor in
    let manager = LocationManager()
    /// process the stream
    for await location in manager.stream {
        print("New coordinates: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    }
    
    print("Stream finished completely.")
    manager.completeStream()
}
