//
//  ChargerMarkerInfoWindow.swift
//  swiftUIChatter
//
//  Created by Samuel Cummins on 11/6/22.
//

import SwiftUI
import MapKit

struct ChargerMarkerInfoWindow: View {
    
    @State var data: [String: Any]
    var body: some View {
        VStack {
            HStack {
                Image("charger_"+String((data["charger"] as! ChargerData).cid))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width:30)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                
                Text((data["charger"] as! ChargerData).street_address)
                Button(action: {print("pressed")}){Image(systemName: "chevron.right.circle")}
                
            }
            HStack {
                Text("Type: " + (data["charger"] as! ChargerData).charger_type + "  |  " + ((data["charger"] as! ChargerData).available == "TRUE" ? "Available" : "Unavailable"))
                    .font(.footnote)
                    .foregroundColor(Color.gray)
            }
            Spacer()
        }
        

    }
}
//
//struct ChargerMarkerInfoWindow_Previews: PreviewProvider {
//    static var previews: some View {
//        ChargerMarkerInfoWindow(charger: Charger(name: "Joe's Charger",        location: CLLocation(latitude: 42.275335, longitude: -83.718607), type: "240V", description: "A very nice charger", available: true, id: 0))
//    }
//}
