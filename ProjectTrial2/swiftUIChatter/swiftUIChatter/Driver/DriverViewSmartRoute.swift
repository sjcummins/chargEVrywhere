//
//  DriverViewSmartRoute.swift
//  swiftUIChatter
//
//  Created by Branden Mayday on 11/21/22.
//

import Foundation
import GoogleMaps
import GooglePlaces
import SwiftUI

struct DriverViewSmartRoute: View {
//    @Binding var showChargingView: Bool
    @State var chargers:[ChargerData] = []//passed in
    @State var filterPrice:Bool = false //passed in
    @State var filterRating:Bool = false//passed in
    @State var filterDistToDest:Bool = false //passed in
    @State var filterMinsToCharger:Bool = false//passed in
    
    let API_KEY = "YOUR_API_KEY"
    
    
    @State var limit: Float = 1
    @State var openPlacePicker = true
    @State private var street_address: String = ""
    @State private var city_address: String = ""
    @State private var state_address: String = ""
    @State private var zipcode_address: String = ""
    @State var smartroutelocation = CLLocation()
    @State var address = [GMSAddressComponent]()
    
    @Environment(\.dismiss) var dismiss
   
    
    
    
    var buttHeight = 50.0
    var buttWidth = 70.0
    var AnnArbor = CLLocation(latitude: 42.2808, longitude: -83.7430)
    @Binding var SmartRouteOptions : Bool
    @Binding var location : CLLocation
    @Binding var SmartRouteOn : Bool
    @Binding var topChargers:[ChargerData]
    @Binding var displayed_route: String
    @Binding var chargersStruct: [ChargerStats]
    @Binding var locationmanager: CLLocation?
    
    func durationToMins(durationStr: String) -> Double {
      let dur_comps = durationStr.components(separatedBy: " ");
      var total_mins = 0;
      if let i = dur_comps.firstIndex(where: { $0 == "days" }) {
        total_mins += (Int(dur_comps[i-1]) ?? 0)*24*60
      }
      if let i = dur_comps.firstIndex(where: { $0 == "hours" }) {
        total_mins += (Int(dur_comps[i-1]) ?? 0)*60
      }
      if let i = dur_comps.firstIndex(where: { $0 == "mins" }) {
        total_mins += Int(dur_comps[i-1]) ?? 0
      }
      return Double(total_mins)
    }
    func distStrToDouble(distanceStr: String) -> Double {
      let dist_comps = distanceStr.components(separatedBy: " ")
      var dist = dist_comps[0]
      if let i = dist.firstIndex(where: { $0 == "," }) {
        dist.remove(at: i)
      }
      return Double(dist)!
    }
    
    
    
    var body: some View {
        NavigationView{
            
            if openPlacePicker {
                VStack {

                }.sheet(isPresented: $openPlacePicker) {
                    PlacePicker(address: $address, street_address: $street_address, city_address: $city_address, state_address: $state_address, zipcode_address:$zipcode_address, location: $smartroutelocation)
            }
                
                 
            }
            else {
                
                /*
                task {         getRouteSteps(from: location, to: smartroutelocation)

                }
                */
                
                VStack(){
                    Text("Choose Smart Routing Filters")
                    .padding()
                    .font(.custom("", size: 25))
                    Spacer()
                    
                    /*
                    
                    HStack {
                        Spacer()
                        Text("Options presented: \(String(format: "%.0f", round(limit*100)/100.0))")
                        Slider(value: $limit, in: 1...3).frame(width: 150)
                        Spacer()
                    }
                     */
                    
                   
                    HStack {
                        Button(
                            action: {
                                filterRating.toggle()
                            },
                            label: {Text("Host Rating")
                                    .frame(width: 120, height: 50)
                                    .foregroundColor(Color.white)
                            })
                        .buttonStyle(.borderedProminent)
                        .tint((filterRating ? Color.blue : Color.gray))
                        
                        Button(
                            action: {
                                filterDistToDest.toggle()
                            },
                            label: {Text("Closest to Destination")
                                    .frame(width: 120, height: 50)
                                    .foregroundColor(Color.white)
                            })
                        .buttonStyle(.borderedProminent)
                        .tint((filterDistToDest ? Color.blue : Color.gray))
                       
                    }
                    
                    
                    Spacer(minLength: 40)
                    HStack {
                        Button(
                            action: {
                                filterMinsToCharger.toggle()
                            },
                            label: {Text("Quickest to Reach")
                                    .frame(width: 120, height: 50)
                                    .foregroundColor(Color.white)
                                    
                            })
                        .buttonStyle(.borderedProminent)
                        .tint((filterMinsToCharger ? Color.blue : Color.gray))
                        
                        Button(
                            action: {
                                filterPrice.toggle()
                            },
                            label: {Text("Charger Price")
                                    .frame(width: 120, height: 50)
                                    .foregroundColor(Color.white)
                                    
                            })
                        .buttonStyle(.borderedProminent)
                        .tint((filterPrice ? Color.blue : Color.gray))
                    }
                    
                    
                    
                    //  -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
                    //                        BELOW IS SECRET SMART ROUTING FORMULA
                    HStack {
                        //just filler so I can call the .task in order to make api calls
                    }
                    .task {
                        if (smartroutelocation.coordinate.latitude == 0 && smartroutelocation.coordinate.longitude == 0 ){
                            SmartRouteOptions = false
                        }
                        if (SmartRouteOptions){
                            var done = false
                            //filling in the list of charger stat info classes from our list of chargers
                            for charger in chargers {
                                var duration = 1000000.0
                                var distance = 1000000.0
                                let avg_rating = await API.shared.getAverageHost_DriverRating(id: charger.user_id, user_type: "HOST")
                                
                                let charge = ChargerStats()
                                charge.cid = charger.cid
                                charge.chargerlocation =  CLLocation(latitude: Double(charger.latitude)!, longitude: Double(charger.longitude)!)
                                charge.cost = Double(charger.price)!
                                charge.avgRating = 4.5
                                
                                let session = URLSession.shared
                                var url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(charger .latitude),\(charger.longitude)&destination=\(smartroutelocation.coordinate.latitude),\(smartroutelocation.coordinate.longitude)&sensor=false&mode=driving&key=\(String(API_KEY))")!
                                print(url)
                                var task = session.dataTask(with: url, completionHandler: {
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
                                    if routes.isEmpty{
                        
                                    }
                                    else {
                                    
                                    guard let route = routes[0] as? [String: Any] else {
                                        return
                                    }
                                    
                                    guard let legs = route["legs"] as? [Any] else {
                                        return
                                    }
                                    
                                    
                                    guard let leg = legs[0] as? [String: Any] else {
                                        return
                                    }
                                    
                                    let distancetemp = (leg["distance"] as! [String: Any])["text"]
                                    distance = distStrToDouble(distanceStr: distancetemp as! String)
                                    
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
                                    }
                                    charge.distanceToDest = distance
                                    }
                                })
                                task.resume()
                                //FILL IN!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                                //FILTER MINS TO CHARGER
                                let url2 = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(locationmanager?.coordinate.latitude ?? AnnArbor.coordinate.latitude ),\(locationmanager?.coordinate.longitude ??  AnnArbor.coordinate.longitude)&destination=\(charger.latitude),\(charger.longitude)&sensor=false&mode=driving&key=\(String(API_KEY))")!
                                let task2 = session.dataTask(with: url2, completionHandler: {
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
                                        print("error in getting routes")
                                        return
                                    }
                                    if routes.isEmpty{
                                    }
                                    else {
                                    
                                    guard let route = routes[0] as? [String: Any] else {
                                        print("error in getting route")
                                        return
                                    }
                                    
                                    guard let legs = route["legs"] as? [Any] else {
                                        print("error in getting legs")
                                        return
                                    }
                                    
                                    
                                    guard let leg = legs[0] as? [String: Any] else {
                                        print("error in getting leg")
                                        return
                                    }
                                    
                                    let durationtemp =  (leg["duration"] as! [String: Any])["text"]
                                    duration = durationToMins(durationStr: durationtemp as! String);
                                    
                                    guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                                        print("error in getting overview polyline")
                                        return
                                    }
                                    
                                    guard let polyLineString = overview_polyline["points"] as? String else {
                                        print("error in getting polyline")
                                        return
                                    }
                                    
                                    
                                    
                                    charge.maproute += polyLineString
                                    charge.minsToReach = duration
                                    done = true
                                    }
                                })
                                task2.resume()
                                
                                
                                //FILL IN!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                                
                                chargersStruct.append(charge)
                            }// for
                            
                            
                            //TO DO!! FILL IN THE OTHER attributes of the class WITH GOOGLE MAPS DATA
                            
                            //now that we have all the info on the chargers we need, we will make an array
                            // for each attribute we want to judge on and find which chargers are the best suited for them by
                            // sorting
                            while (!done) {
                                sleep(1)
                            }
                            var pricesArray:[ChargerStats] = []
                            var ratingsArray:[ChargerStats] = []
                            var distToDestArray:[ChargerStats] = []
                            var MinsToChargerArray:[ChargerStats] = []
                            
                            for charger in chargersStruct {
                                pricesArray.append(charger)
                                ratingsArray.append(charger)
                                distToDestArray.append(charger)
                                MinsToChargerArray.append(charger)
                            }
                            
                            //time to sort the arrays based on their name
                            pricesArray.sort(by: { $0.cost < $1.cost })
                            ratingsArray.sort(by: { $0.avgRating > $1.avgRating })
                            distToDestArray.sort(by: { $0.distanceToDest < $1.distanceToDest })
                            MinsToChargerArray.sort(by: { $0.minsToReach < $1.minsToReach })
                            
                            //now we will add up the rankings of each charger based on the sorted arrays above
                            for charger in chargersStruct {
                                charger.rankings += pricesArray.firstIndex(where: { $0.cid == charger.cid })!
                                charger.rankings += ratingsArray.firstIndex(where: { $0.cid == charger.cid })!
                                charger.rankings += distToDestArray.firstIndex(where: { $0.cid == charger.cid })!
                                charger.rankings += MinsToChargerArray.firstIndex(where: { $0.cid == charger.cid })!
                            }
                            //sort our list of all chargers by their combined rankings
                            chargersStruct.sort(by: { $0.rankings < $1.rankings })
                            var count = 0
                            let otherlimit = 3
                            topChargers = []
                            for _ in chargersStruct {
                                if (count < otherlimit) {
                                    let currentcid = chargersStruct[count].cid
                                    for charger in chargers {
                                        if (currentcid == charger.cid) {
                                            topChargers.append(charger)
                                            break
                                        }
                                    }
                                    if count == 0 {
                                    }
                                    
                                }
                                count += 1
                            }
                            displayed_route = chargersStruct[0].maproute
                            //topChargers should now have the top "limit" amount of chargers based on their preferences
                            
                        }// if smart
                    }// task
                    
                    Spacer()
            HStack{
                
               
                
            }//HStack
                    
                    HStack {
                    Button(action: {
                        SmartRouteOptions = false
                    }) {
                        VStack {
                            Text("Cancel")
                        }
                    }.frame(width: buttWidth, height: buttHeight)
                        .foregroundColor(.white)
                        .background(Color(.gray))
                        .clipShape(Capsule())
                    
                    
                    Button(action: {
                        SmartRouteOptions = false
                        SmartRouteOn = true
                    
                    }) {
                        VStack {
                            Text("Apply")
                        }
                    }.frame(width: buttWidth, height: buttHeight)
                        .foregroundColor(.white)
                        .background(Color(.gray))
                        .clipShape(Capsule())
                    }
                    .padding(.vertical)
                    
                    
                    
                    
                    
                }//VStack
                
            }//else
            
        }//NavigationView
    }//VieW
    
}


class ChargerStats: ObservableObject, Hashable {
    static func == (lhs: ChargerStats, rhs: ChargerStats) -> Bool {
        return lhs.cid == rhs.cid
    }
    
    var cid: Int = 0
    var cost: Double = 0
    var distanceToDest: Double = 0
    var avgRating: Double = 0
    var minsToReach: Double = 0
    var rankings: Int = 0
    var maproute: String = ""
    var chargerlocation: CLLocation = CLLocation(latitude: 42.2808, longitude: -83.7430)
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(cid)
    }
    
}
