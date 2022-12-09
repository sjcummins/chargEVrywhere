//
//  DriverPaymentChargingView.swift
//  swiftUIChatter
//
//  Created by Allison Kwang on 11/7/22.
//

import SwiftUI

struct DriverPaymentChargingView: View {
    @Binding var showChargingView: Bool
    @State var about_me : HostAboutMe
    @State var cost: String
    @State var duration: String
    var body: some View {
        
        NavigationView{
            VStack{
                
                
                ProgressView(value: 0.5){
                    Text("Payment").frame(maxWidth: .infinity, alignment: .center)
                }.padding()
                Spacer()
                NavigationLink(destination: DriverReviewChargingView(showChargingView: self.$showChargingView, about_me: self.about_me, cost: cost, duration: duration)){
                    Text("Next")
                    //Text("\(duration)")
                    //Text("\(cost)")
                    
                }
            }//VStack
        }//NavigationView
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
    }//View
}
/*
struct DriverPaymentChargingView_Previews: PreviewProvider {
    static var previews: some View {
        DriverPaymentChargingView(showChargingView: .constant(true), about_me: se)
    }
}
*/
