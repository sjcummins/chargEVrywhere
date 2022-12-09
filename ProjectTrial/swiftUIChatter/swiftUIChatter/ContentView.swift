//
//  ContentView.swift
//  swiftUIChatter
//
//  Created by Jacob Klionsky on 10/27/22.
//

import SwiftUI

struct ContentView: View {
    @State private var hostmode = false
    
    var body: some View {
        Text("ChargEvrywhere")
            .padding(.top, 10.0)
        Button(action: {
            if hostmode == true {
                hostmode = false
            }
            else {
                hostmode = true
            }
                }) {
                    if hostmode == false {
                        Text("Host Mode")
                    }
                    else {
                        Text("Driver Mode")
                    }
                }
        
        if hostmode {
               HostMainView()
            }
        else {
            MainView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
