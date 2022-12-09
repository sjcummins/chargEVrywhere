//
//  ContentView.swift
//  swiftUIChatter
//
//  Created by Jason Obrycki on 10/18/22.
//

import SwiftUI
import GoogleMaps
import MapKit
import CoreLocation
import GooglePlaces


struct HomeView: View {
    @State private var search: String = ""
    @StateObject private var vm = SearchResultsViewModel()
    @State private var showingAlert = false
    @State var openPlacePicker = false
    @State var address = [GMSAddressComponent]()
    @ObservedObject var locationManager = LocationManager()
    @State var location = CLLocation()
    @State var currentlocation = true
    @State private var showingChargerProfile = false
    @State private var nearbychargerslist = [Int]()
    
    @State private var street_address: String = ""
    @State private var city_address: String = ""
    @State private var state_address: String = ""
    @State private var zipcode_address: String = ""
    
    @State private var nearbychargers = [Int]()
    @State public var chargerarrayreal = [ChargerData]()
    @State public var bestchargerlocation = CLLocation()
    @State private var showingnearestcharger = false
    @State var topChargers:[ChargerData] = []
    
    @State var filter = Filter(filterOn: false, maxPrice: 10.00, minRating: 1, chargerType: 0)
    @State var SmartRouteOptions: Bool = false
    @State var SmartRouteOn: Bool = false
    @State var RouteMap: Bool = false
    @State var displayed_route: String = "" // remove
    @State var chargersStruct:[ChargerStats] = []
    
    
    
    let default_charger = ChargerData(user_id: 0, cid: 0, available: "", start_time_availability: "", end_time_availability: "", charger_type: "", price: "0", street_address: "", city_address: "", state_address: "", zipcode_address: "", latitude: "", longitude: "")
    
    
    var buttHeight = 50.0
    var buttWidth = 70.0
    
    var body: some View {
        NavigationView{
            ZStack {
                
                VStack {
            
                if (!currentlocation || showingnearestcharger) {
                        GoogleMapsViewCustomized(location:  CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), chargerarray: $chargerarrayreal, filter: $filter)
                    }
                    else {
                        GoogleMapsViewCustomized(location: locationManager.location ?? CLLocation(latitude: 42.2808, longitude: -83.7430), chargerarray: $chargerarrayreal, filter: $filter)
                    }
                        

                    Spacer()
                    
                    
                }.sheet(isPresented: $openPlacePicker) {
                        PlacePicker(address: $address, street_address: $street_address, city_address: $city_address, state_address: $state_address, zipcode_address:$zipcode_address, location: $location)
                }.task {
                    
                    //Don't know why this isn't working but add default values
                    let nearbycharger = await API.shared.getLocalChargers(lat: locationManager.latitude, longitude: locationManager.longitude, radius: 100000)
                    for x in 0..<(nearbycharger?.count ?? 0){
                        let tempcharger = await API.shared.getChargerWindow(cid: nearbycharger?[x] ?? 0)
                        chargerarrayreal.append(tempcharger ?? default_charger)
                    }
                }
                
             
                

                VStack {
                    if filter.filterOn {
                        FilterView(filter: $filter)
                    }
                    else if SmartRouteOptions {
                        DriverViewSmartRoute(chargers: chargerarrayreal, SmartRouteOptions: $SmartRouteOptions, location: $location, SmartRouteOn: $SmartRouteOn,  topChargers: $topChargers, displayed_route: $displayed_route, chargersStruct: $chargersStruct, locationmanager: $locationManager.location)
                    }
                    else if SmartRouteOn {
                        SmartRouteUIView(location: locationManager.location ?? CLLocation(latitude: 42.2808, longitude: -83.7430), topchargerarray: $topChargers, chargersStruct: $chargersStruct, filter: $filter, displayed_route: $displayed_route, SmartRouteOn: $SmartRouteOn)
                       // SmartRouteMapView(polyStr: $bestpolystr, SmartRouteOn: $SmartRouteOn )
                    }
                    
                    else {
    
                    HStack {
                        
                        Button(action: {
                                SmartRouteOptions = true
                              
                          }) {
                              VStack {
                                  Text("Smart Route")
                              }
                          }.frame(width: buttWidth, height: buttHeight)
                              .foregroundColor(.white)
                              .background(Color(.gray))
                              .clipShape(Capsule())
                        Spacer()
                Button(action: {
                          filter.filterOn = true
                      
                  }) {
                      VStack {
                          Text("Filter")
                      }
                  }.frame(width: buttWidth, height: buttHeight)
                      .foregroundColor(.white)
                      .background(Color(.gray))
                      .clipShape(Capsule())
                    }
                    .padding(.vertical)
                    .padding(.horizontal)
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationButtonView(location: $location, currentlocation: $currentlocation, openPlacePicker: $openPlacePicker, chargerarrayreal: $chargerarrayreal)
                    } // HStack
                    .padding(.vertical)
                    .padding(.horizontal)
                } // else
                    
           } //VStack
                
                    
            } // ZStack
            
        } // Navigation View
    } // body
    @State private var isPresenting = false
}





struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}




/*     List(vm.places) { place in
         Button(place.name) {
                     showingAlert = true
         }.alert("Do you want to go to " + place.name + "?", isPresented: $showingAlert) {
             }
     }
   GoogleMapsView()
     .edgesIgnoringSafeArea(.top)
     .frame(height: 250)
         }.searchable(text: $vm.searchText)
     .navigationTitle("Places")
 
 */
