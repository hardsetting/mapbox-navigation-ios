import XCTest
import MapboxDirections
@testable import MapboxCoreNavigation


class LocationManagerTests: XCTestCase {
    
    func fetchRoute() {
        
        let directions = Directions(accessToken: "")
        
        let wp1 = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 37.7884, longitude: -122.4002))
        let wp2 = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 38.9100, longitude: -77.03647))
        
        let options = RouteOptions(coordinates: [wp1.coordinate, wp2.coordinate], profileIdentifier: .automobileAvoidingTraffic)
        options.routeShapeResolution = .full
        options.includesSteps = true
        
        let expectation = self.expectation(description: "Get Route")
        
        directions.calculate(options) { (waypoints, routes, error) in
            if let route = routes?.first {
                self.saveRoute(route)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                print(error)
            }
        }
        
    }
    
    func saveRoute(_ route: Route) {
        let filename = "sfdc.data"
        let tempPath = NSTemporaryDirectory() as! NSString
        let filePath = tempPath.appendingPathComponent(filename)
        NSKeyedArchiver.archiveRootObject(route, toFile: filePath)
    }
    
    func testBenchmarkSimulatedLocationManager() {
        self.measure {
            let bundle = Bundle(for: LocationManagerTests.self)
            guard let filePath = bundle.path(forResource: "SF-DC", ofType: "data") else {
                XCTAssert(false)
                return
            }
            
            let route = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as! Route
            
            let navigation = RouteController(along: route, directions: directions)
            let locationManager = SimulatedLocationManager()
            locationManager.route = route
            navigation.locationManager = locationManager
            navigation.resume()
        }
    }
}
