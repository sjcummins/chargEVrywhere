//
//  ContentView.swift
//  swiftUIChatter
//
//  Created by Jason Obrycki on 10/18/22.
//

import SwiftUI

struct HostHomeView: View {
    @State private var showingSheet = false
    @State private var showingAlert = false
    @State private var labelText = "Accept"
    @State private var labelText2 = "Decline"
    @State private var displayed_user_id = 1
    @State private var about_me = DriverAboutMe(user_id: 2, first_name: "", last_name: "", average_rating: 0.0, charging_since: 2022, description: "", vehicle_model: "", vehicle_color: "", vehicle_platenum: "", img_url: "")
    
    var body: some View {
        //api call here instead
        
        VStack {
            Text("Requests").fontWeight(.semibold).font(.title2).multilineTextAlignment(.leading)
            NavigationView{
                VStack {
                    Text(self.about_me.first_name + " " + self.about_me.last_name)

                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("Requested Charger: " + "Garage Charger")
                        //.font(.title)
                        .frame(maxWidth: 300, alignment: .leading)
//                    Text("Distance: " + self.$about_me.distance + " miles")
//                        //.font(.title)
//                        .frame(maxWidth: 300, alignment: .leading)
                    Button(action: {showingSheet.toggle()},
                           label: {Text("View Profile")
                            .foregroundColor(Color.white)
                            .frame(width: 300, height: 30)
                    })
                    .background(Color.blue)
                    .cornerRadius(20.0)
                    .sheet(isPresented: $showingSheet) {
                        HostViewOfDriverView(showSheetView:self.$showingSheet, user_id: self.$displayed_user_id, about_me: self.$about_me)
                                                }
                    HStack{
                        Button(action: {
                            //start timer
                            
                            if(labelText == "Accept"){
                                labelText = "Confirmed"
                                showingAlert.toggle()
                                //print(remote_id)
                            }
                            else{
                                labelText = "Accept"
                            }
                        },label: {Text(labelText)
                                .foregroundColor(Color.white)
                                .frame(width: 145, height: 30)
                        })
                        .alert(isPresented: $showingAlert) {
                                Alert(title: Text("Driver is on their way"), message: Text(""), dismissButton: .default(Text("Got it!")))
                            }
                        .background(Color.blue)
                        .cornerRadius(20.0)
                        Button(action: {
                            //start timer
                            
                            if(labelText2 == "Decline"){
                                labelText2 = "Confirmed"
                            }
                            else{
                                labelText2 = "Decline"
                            }
                        },label: {Text(labelText2)
                                .foregroundColor(Color.white)
                                .frame(width: 145, height: 30)
                        })
                        .background(Color.blue)
                        .cornerRadius(20.0)
                    }
                    .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Driver is on their way"), message: Text(""), dismissButton: .default(Text("Got it!")))
                        }

                    }
//                    Button("View Profile") {
//                                showingSheet.toggle()
//                    }
//                            .sheet(isPresented: $showingSheet) {
//                                HostViewOfDriverView(showSheetView:self.$showingSheet)
//                            }
                }
                .task{
//                    let user_info = await API.shared.getUser(id: displayed_user_id)
                    let user_info = await API.shared.getUser2(id: displayed_user_id)
                    let vehicle_info = await API.shared.getVehicle(id: displayed_user_id)
                    let avg_rating = await API.shared.getAverageHost_DriverRating(id: displayed_user_id, user_type: "DRIVER")
                    self.about_me = DriverAboutMe(user_id: displayed_user_id, first_name: user_info!.first_name, last_name: user_info!.last_name, average_rating: 4.5, charging_since: user_info!.charging_since, description: user_info!.description, vehicle_model: vehicle_info?.model ?? "None", vehicle_color: vehicle_info?.color ?? "None", vehicle_platenum: vehicle_info?.lics_number ?? "None", img_url: user_info!.img_url ?? "None")
                    
                }
                .refreshable {
                    let charger_info = await API.shared.getChargerInfo(id: remote_id)
                    if charger_info?.available == "FALSE" {
                        showingAlert.toggle()
                    }
                }
            }
        }

        
        
    @State private var isPresenting = false
}

struct HostHomeView_Previews: PreviewProvider {
    static var previews: some View {
        HostHomeView()
    }
}




