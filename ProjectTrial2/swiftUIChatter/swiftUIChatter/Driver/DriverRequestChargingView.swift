//
//  DriverRequestChargingView.swift
//  swiftUIChatter
//
//  Created by Allison Kwang on 11/14/22.
//

import SwiftUI

struct DriverRequestChargingView: View {
    @Binding var showChargingView: Bool
    @State var about_me : HostAboutMe
    @State var next_screen = false
    var body: some View {
        NavigationView{
            VStack{
                
                
                ProgressView(value: 0.2){
                    Text("Request").frame(maxWidth: .infinity, alignment: .center)
                }.padding()
                Spacer()
                Button("Refresh") {
                    
                    Task{
                        
                        let charger = await API.shared.getChargerWindow(cid: about_me.cid)
                        if charger?.available == "FALSE"{
                            
                            next_screen.toggle()
                        }
                        
                        //Submit Data
                    }
                }.buttonStyle(.borderedProminent)
                
                Spacer()
                if next_screen{
                    NavigationLink(destination: DriverBeginChargingView(showChargingView: self.$showChargingView, about_me: self.about_me)){
                        Text("Next")
                        
                    }
                }
            }//VStack
        }//NavigationView
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
    }//View
}

//struct DriverRequestChargingView_Previews: PreviewProvider {
//    static var previews: some View {
//        DriverRequestChargingView(showChargingView: .constant(true))
//    }
//}
