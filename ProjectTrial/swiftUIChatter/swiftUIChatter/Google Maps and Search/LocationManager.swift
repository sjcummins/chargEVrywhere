//
//  LocationManager.swift
//  swiftUIChatter
//
//  Created by Jacob Klionsky on 10/31/22.
//

import Foundation
import Combine
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var region: MKCoordinateRegion = MKCoordinateRegion.defaultRegion()

    // 1
     @Published var location: CLLocation? {
       willSet { objectWillChange.send() }
     }
    
    // 2
    var latitude: CLLocationDegrees {
        return location?.coordinate.latitude ?? 0
    }
    
    var longitude: CLLocationDegrees {
        return location?.coordinate.longitude ?? 0
    }
    static let shared = LocationManager()
    
    // 3
    override init() {
      super.init()
        
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestWhenInUseAuthorization()
      locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
  // 4
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
}
