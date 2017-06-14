import Foundation
import CoreLocation

class ReplayLocationManager: NavigationLocationManager {
    var currentIndex: Int = 0
    var locations: [CLLocation]! {
        didSet {
            currentIndex = 0
        }
    }
    
    deinit {
        stop()
    }
    
    override func startUpdatingLocation() {
        tick()
    }
    
    func stop() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(tick), object: nil)
    }
    
    @objc fileprivate func tick() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(tick), object: nil)
        
        guard locations.count < currentIndex else {
            currentIndex = 0
            return
        }
        
        let location = locations[currentIndex]
        delegate?.locationManager!(self, didUpdateLocations: [location])
        currentIndex += 1
    }
}
