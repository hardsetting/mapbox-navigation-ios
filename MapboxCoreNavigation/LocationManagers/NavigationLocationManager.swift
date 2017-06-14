import Foundation
import CoreLocation

@objc(MBNavigationLocationManager)
open class NavigationLocationManager: CLLocationManager {
    
    override public init() {
        super.init()
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            requestWhenInUseAuthorization()
        }
        
        if Bundle.main.backgroundModeLocationSupported {
            activityType = .automotiveNavigation
            distanceFilter = 50
            allowsBackgroundLocationUpdates = true
        }
    }
    
}
