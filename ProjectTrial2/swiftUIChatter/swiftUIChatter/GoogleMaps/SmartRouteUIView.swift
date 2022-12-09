//
//  SmartRouteUIView.swift
//  swiftUIChatter
//
//  Created by Jacob Klionsky on 12/5/22.
//

import SwiftUI
import GoogleMaps

struct SmartRouteUIView: View {
    var location = CLLocation()
    @Binding var topchargerarray : [ChargerData]
    @Binding var chargersStruct : [ChargerStats]
    @Binding var filter : Filter
    @Binding var displayed_route : String
    @Binding var SmartRouteOn : Bool
    @State var activeRoute : Int = 0
    @State var displayed_host : HostAboutMe? = nil
    @State var presenting_host = false
    var buttHeight = 50.0
    var buttWidth = 70.0
    
    
    var body: some View {
        ZStack {
            SmartMapsViewCustomized(topchargerarray: $topchargerarray, filter: $filter, displayed_route: $displayed_route, displayed_host: $displayed_host)
        VStack {
            Spacer()
            HStack {
            Button(action: {
                SmartRouteOn = false
            }) {
                VStack {
                    Text("Cancel")
                }
            }.frame(width: buttWidth, height: buttHeight)
                .foregroundColor(.white)
                .background(Color(.gray))
                .clipShape(Capsule())
                
                
                Spacer()
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 5)
            
            VStack {
                ForEach(Array(topchargerarray.enumerated()), id: \.element) { (index, element) in
                    HStack{
                        Button(action: {
                            activeRoute = index
                            displayed_route = chargersStruct[index].maproute
                            
                        },
                               label: { Text("\(element.street_address)"  +
                                             (activeRoute != index ? ": \(String(chargersStruct[index].distanceToDest)) mi., \(String(Int(chargersStruct[index].minsToReach))) mins" : ""))
                               .frame(maxWidth: .infinity, maxHeight: 20)
                                .foregroundColor(Color.white)
                                
                            
                        })
                        .buttonStyle(.borderedProminent)
                        .tint(Color.gray)
                        .padding(.leading, 5)
                        .padding(.trailing, (activeRoute != index ? 5 : 1))
                        .padding(.top, 5)
                        
                        if (activeRoute == index) {
                            withAnimation{
                                Button(action: {
                                    self.presenting_host = true
                                },
                                   label: { Text("View Details")
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(Color.white)
                                    
                                })
                                .buttonStyle(.borderedProminent)
                                .tint(Color.blue)
                                .padding(.leading, 1)
                                .padding(.trailing, 5)
                                .padding(.top, 5)
                                .sheet(isPresented: $presenting_host) { DriverViewOfHostView(about_me: $displayed_host.wrappedValue!) }
                            }//withAnimation
                        }//if
                    }//Hstack
                    .frame(maxWidth: .infinity)
                }//foreach
            } // VStack
                
            .background(Color.white)
            
        }
     
        }
    }
}
