//
//  ContentView.swift
//  swiftUIChatter
//
//  Created by Jason Obrycki on 10/18/22.
//

import SwiftUI
import GoogleMaps

struct HostMainView: View {
    var body: some View {
        TabView {
            HostHomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            HostActivityView()
                .tabItem {
                    Label("Activity", systemImage: "house")
                }
            HostUserView()
                .tabItem {
                    Label("User", systemImage: "person")
                }
    }
}
}

struct HostMainView_Previews: PreviewProvider {
    static var previews: some View {
        HostMainView()
    }
}

