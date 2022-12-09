//
//  ContentView.swift
//  swiftUIChatter
//
//  Created by Jason Obrycki on 10/18/22.
//

import SwiftUI
public var remote_id: Int = 1
struct UserView: View {

    var body: some View {
        
        //Load previous login credentials
        let username = defaults.string(forKey: "username")
        let password = defaults.string(forKey: "password")
        //If credentials exist, get login infor
        let v = Task{
            if (username != nil && password != nil) {
                let user_id = await API.shared.getLogin(username: username!, password: password!)
            }
        }
        NavigationView{
            VStack {
                NavigationLink(destination: SignInView()) {
                    Label("Sign In", systemImage: "plus.circle")
                        .labelStyle(.titleOnly)
                }.buttonStyle(.borderedProminent)
                Text("Or")
                NavigationLink(destination: CreateUserDriverView()) {
                    Label("Sign Up", systemImage: "plus.circle")
                }.buttonStyle(.bordered)
                
        

            }//VStack

          
        }//NavigationView
    }
    @State private var isPresenting = false
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}


