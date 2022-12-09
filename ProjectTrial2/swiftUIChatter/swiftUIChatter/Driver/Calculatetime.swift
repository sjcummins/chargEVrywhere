//
//  Calculatetime.swift
//  swiftUIChatter
//
//  Created by Jacob Klionsky on 11/22/22.
//

import Foundation
import GooglePlaces





func getRouteSteps(from location: CLLocation, to smartroutelocation: CLLocation) {

    let session = URLSession.shared
    let API_KEY = "YOUR_API_KEY"

    let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(location.coordinate.latitude),\(location.coordinate.longitude)&destination=\(smartroutelocation.coordinate.latitude),\(smartroutelocation.coordinate.longitude)&sensor=false&mode=driving&key=\(API_KEY)")!
  

    let task = session.dataTask(with: url, completionHandler: {
        (data, response, error) in

        guard error == nil else {
            print(error!.localizedDescription)
            return
        }

        guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else {

            print("error in JSONSerialization")
            return

        }

        guard let routes = jsonResult["routes"] as? [Any] else {
            return
        }

        guard let route = routes[0] as? [String: Any] else {
            return
        }

        guard let legs = route["legs"] as? [Any] else {
            return
        }
        
    
        guard let leg = legs[0] as? [String: Any] else {
            return
        }

        guard let steps = leg["steps"] as? [Any] else {
            return
        }
          for item in steps {

            guard let step = item as? [String: Any] else {
                return
            }

            guard let polyline = step["polyline"] as? [String: Any] else {
                return
            }

            guard let polyLineString = polyline["points"] as? String else {
                return
            }

            //Call this method to draw path on map
            /*DispatchQueue.main.async {
                self.drawPath(from: polyLineString)
            }
             */

        }
    })
    task.resume()
}
