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
        let username = defaults.string(forKey: "username")
        let password = defaults.string(forKey: "password")
        //If credentials exist, get login infor
        let v = Task{
            if (username != nil && password != nil) {
                let user_id = await API.shared.getLogin(username: username!, password: password!)
            }
        }
        TabView {
            HostHomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            HostActivityView()
                .tabItem {
                    Label("Activity", systemImage: "list.bullet")
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

