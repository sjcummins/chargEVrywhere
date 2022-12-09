//
//  ContentView.swift
//  swiftUIChatter
//
//  Created by Jason Obrycki on 10/18/22.
//

import SwiftUI

struct HostHomeView: View {

    var body: some View {
        
        NavigationView{
            VStack {
                Text("Host Home")
                    .padding(.top, 5.0)
            }

          
    }
    }
    @State private var isPresenting = false
}

struct HostHomeView_Previews: PreviewProvider {
    static var previews: some View {
        HostHomeView()
    }
}




