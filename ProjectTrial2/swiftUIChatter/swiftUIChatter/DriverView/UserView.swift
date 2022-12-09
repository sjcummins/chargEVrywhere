//
//  ContentView.swift
//  swiftUIChatter
//
//  Created by Jason Obrycki on 10/18/22.
//

import SwiftUI

struct UserView: View {

    var body: some View {
        
    
        NavigationView{
            VStack {
                Text("User")
                    .padding(.top, 5.0)
            }

          
    }
    }
    @State private var isPresenting = false
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}


