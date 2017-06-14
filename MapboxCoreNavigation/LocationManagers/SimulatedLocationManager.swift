import Foundation
import MapboxDirections

extension CLLocationCoordinate2D {
    static var nullIsland: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
}

class SimulatedLocationManager: NavigationLocationManager {
    var currentDistance: CLLocationDistance = 0
    
    var route: Route! {
        didSet {
            if let coordinates = route.coordinates {
                polyline = coordinates
            }
        }
    }
    
    var polyline: [CLLocationCoordinate2D] = [.nullIsland]
    
    override func startUpdatingLocation() {
        tick()
    }
    
    func stop() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(tick), object: nil)
    }
    
    @objc fileprivate func tick() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(tick), object: nil)
        
    }
}
