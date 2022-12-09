//
//  ContentView.swift
//  swiftUIChatter
//
//  Created by Jason Obrycki on 10/18/22.
//

import SwiftUI

struct HostUserView: View {
    var body: some View {
        
        NavigationView{
            VStack {
                NavigationLink(destination: SignInView()) {
                    Label("Sign In", systemImage: "plus.circle")
                        .labelStyle(.titleOnly)
                }.buttonStyle(.borderedProminent)
                Text("Or")
                NavigationLink(destination: CreateUserHostView()) {
                    Label("Sign Up", systemImage: "plus.circle")
                }.buttonStyle(.bordered)
                
                NavigationLink(destination: CreateChargerView()) {
                    Label("Add Charger", systemImage: "plus.circle")
                }.buttonStyle(.bordered)
                

            }//VStack

          
        }//NavigationView
    }
    @State private var isPresenting = false
}

struct HostUserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}



