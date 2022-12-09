//
//  ContentView.swift
//  swiftUIChatter
//
//  Created by Jason Obrycki on 10/18/22.
//

import SwiftUI

struct ActivityView: View {
    @StateObject private var locationManager = LocationManager.shared
    @State private var search: String = ""
    @StateObject private var vm = SearchResultsViewModel()


    var body: some View {
        
    
        NavigationView{
            VStack {
                Text("Activity")
                    .padding(.top, 5.0)
                            
            }

          
    }
    }
    @State private var isPresenting = false
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}



