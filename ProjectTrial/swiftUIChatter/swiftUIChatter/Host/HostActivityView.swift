//
//  ContentView.swift
//  swiftUIChatter
//
//  Created by Jason Obrycki on 10/18/22.
//

import SwiftUI

struct HostActivityView: View {
    @StateObject private var locationManager = LocationManager.shared
    @State private var search: String = ""
    @StateObject private var vm = SearchResultsViewModel()


    var body: some View {
        
    
        NavigationView{
            VStack {
                Text("Host Activity")
                    .padding(.top, 5.0)
                            
            }

          
    }
    }
    @State private var isPresenting = false
}

struct HostActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}




