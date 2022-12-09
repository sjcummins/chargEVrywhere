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
                Text("Host User")
                    .padding(.top, 5.0)
            }

          
    }
    }
    @State private var isPresenting = false
}

struct HostUserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}



