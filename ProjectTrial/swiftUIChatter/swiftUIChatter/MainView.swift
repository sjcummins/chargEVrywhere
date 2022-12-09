//
//  ContentView.swift
//  swiftUIChatter
//
//  Created by Jason Obrycki on 10/18/22.
//

import SwiftUI
import GoogleMaps

struct MainView: View {
    @State private var hostmode = false
    
    
    
    var body: some View {
   

        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            ActivityView()
                .tabItem {
                    Label("Activity", systemImage: "house")
                }
            UserView()
                .tabItem {
                    Label("User", systemImage: "person")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
