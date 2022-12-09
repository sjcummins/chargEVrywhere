//
//  ContentView.swift
//  swiftUIChatter
//
//  Created by Jason Obrycki on 10/18/22.
//

import SwiftUI
import GoogleMaps
import MapKit



struct HomeView: View {
    @StateObject public var locationManager = LocationManager.shared
    @State private var search: String = ""
    @StateObject private var vm = SearchResultsViewModel()
<<<<<<< HEAD
    @State private var showingAlert = false

    func butontapped() {
        print("tappd")
    }
=======
    @State var openPlacePicker = false
    @State var address = ""
>>>>>>> ed56c02ce80fc5ab90ccfbf2cd6a3e71beb5d4f9
   
   
    var body: some View {
        
        NavigationView{
          let mylist = List(vm.places) { place in
              Button(place.name) {
                          showingAlert = true
                      }
                      .alert("Important message", isPresented: $showingAlert) {
                      }
          }
                
            VStack {
<<<<<<< HEAD
            mylist
              GoogleMapsView()
                .edgesIgnoringSafeArea(.top)
                .frame(height: 250)
                    }.searchable(text: $vm.searchText)
                .navigationTitle("Places")
=======
//                List(vm.places) { place in
//                    Text(place.name)
//                        .onTouchDownGesture {
//                        /*    let location = CLLocationCoordinate2D(latitude: place.placemark.location?.coordinate.latitude ?? 0, longitude: place.placemark.location?.coordinate.longitude ?? 0)
//                            let marker = GMSMarker(position: location)
//                            marker.title = "Desired Location"
//                         */
//                        }
//                }
//
//                .edgesIgnoringSafeArea(.top)
//                .frame(height: 300)
//                    }.searchable(text: $vm.searchText)
//                .navigationTitle("Places")
                Text(address)
                            
                            Button {
                                
                                openPlacePicker.toggle()
                            } label: {
                                
                                Text("Search")
                            }
                      
                        }.sheet(isPresented: $openPlacePicker) {
                            PlacePicker(address: $address)
                        }
>>>>>>> ed56c02ce80fc5ab90ccfbf2cd6a3e71beb5d4f9
        
    }
    }
    @State private var isPresenting = false
}





struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

