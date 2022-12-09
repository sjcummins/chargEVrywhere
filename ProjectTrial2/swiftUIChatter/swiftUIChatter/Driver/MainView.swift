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
        let username = defaults.string(forKey: "username")
        let password = defaults.string(forKey: "password")
        //If credentials exist, get login infor
        let v = Task{
            if (username != nil && password != nil) {
                let user_id = await API.shared.getLogin(username: username!, password: password!)
            }
        }
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            ActivityView()
                .tabItem {
                    Label("Activity", systemImage: "list.bullet")
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
