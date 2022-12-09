//
//  UserModeButtonView.swift
//  swiftUIChatter
//
//  Created by Samuel Cummins on 11/6/22.
//  Adapted from https://github.com/Tprezioso/ExpandableButtonSwiftUI/blob/main/ExpandableButton

import SwiftUI
import GoogleMaps
import MapKit
import CoreLocation


struct NavigationButtonView: View {
    @Binding var location: CLLocation
    @Binding var currentlocation: Bool
    @Binding var openPlacePicker: Bool
    @Binding var chargerarrayreal: [ChargerData]
    @State var isExpanded = false
    @ObservedObject var locationManager = LocationManager()
    

    var nearbyIcon = "location.circle.fill"
    var optionsIcon  = "ellipsis.circle.fill"
    var cheapestchargerIcon  = "dollarsign.circle.fill"
    var fastchargerIcon = "speedometer"
    var searchIcon = "arrow.triangle.turn.up.right.diamond.fill"
    var buttHeight = 50.0
    var buttWidth = 70.0
    
    
    
    func findclosestcharger() {
        if chargerarrayreal.isEmpty || locationManager.location == CLLocation(latitude: 42.275335, longitude: -83.738607){
            location = locationManager.location ?? CLLocation(latitude: 42.275335, longitude: -83.738607)
            
        }
        else{
        var distance = locationManager.location?.distance(from: CLLocation(latitude: Double(chargerarrayreal[0].latitude) ?? 83, longitude: Double(chargerarrayreal[0].longitude) ?? -37))
                
        var closestcharger = chargerarrayreal[0]
        for charger in chargerarrayreal {
            if (locationManager.location?.distance(from: CLLocation(latitude: Double(charger.latitude) ?? 0.00, longitude: Double( charger.longitude)!)) ?? 0.00 < distance ?? 100000) {
                distance =   locationManager.location!.distance(from: CLLocation(latitude: Double(charger.latitude)!, longitude: Double( charger.longitude)!))
                closestcharger = charger
            }
        }
        location = CLLocation(latitude: Double(closestcharger.latitude)!, longitude: Double(closestcharger.longitude)!)
        
        }
    }
    
    
    var body: some View {
        VStack {
                Button(action: {
                    withAnimation {
                        findclosestcharger()
                        currentlocation = false
                        isExpanded.toggle()
                    }
                    
                }) {
                    VStack {
                        Image(systemName: fastchargerIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:25)
                            
                    }
                }.frame(width: buttWidth, height: buttHeight)
                    .foregroundColor(.white)
                    .background(Color(.gray))
                    .clipShape(Capsule())
                
                
                Button(action: {
                    withAnimation {
                        currentlocation = (locationManager.location != nil)
                        isExpanded.toggle()
                    }
                    
                }) {
                    VStack {
                        Image(systemName: nearbyIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:25)
                            
                    }
                }.frame(width: buttWidth, height: buttHeight)
                    .foregroundColor(.white)
                    .background(Color(.gray))
                    .clipShape(Capsule())
                
                
               
                Button(action: {
                    withAnimation {
                        openPlacePicker.toggle()
                        currentlocation = false
                        isExpanded.toggle()
                    }
                    
                }) {
                    VStack {
                        Image(systemName: searchIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:25)
                            
                    }
                }.frame(width: buttWidth, height: buttHeight)
                    .foregroundColor(.white)
                    .background(Color(.gray))
                    .clipShape(Capsule())

            }
            
            
            
            
            

            
    }
}



