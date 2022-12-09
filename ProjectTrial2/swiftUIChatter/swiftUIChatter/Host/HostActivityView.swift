//
//  ContentView.swift
//  swiftUIChatter
//
//  Created by Jason Obrycki on 10/18/22.
//

import SwiftUI

struct HostActivityView: View {
    @State private var search: String = ""
    @StateObject private var vm = SearchResultsViewModel()
    @State private var notif = Activity()
    @State private var notifs = [Activity]()
    //var remote_id = 3
    var body: some View {
        
    
        NavigationView{
            VStack() {
                //Text("Activity").frame(maxWidth: .infinity, alignment: .center).padding()
                Button("Refresh") {
                    
                    Task{
                        
                        if notifs .isEmpty
                        {
                            notifs = await API.shared.getActivity(id: remote_id)!
                        }
                    }
                        //let x = 3
                        //Submit Data
                    
                }.buttonStyle(.borderedProminent)
                ScrollView{
                    VStack{
                        ForEach(notifs) { notif in
                            
                            Spacer()
                            if(notif.host_id == remote_id)
                            {
                                Text("You made $\(notif.cost) from \(notif.duration) of a driver using your charger.").frame(maxWidth: .infinity, alignment: .center).padding()
                            }
                            else
                            {
                                Text("You spent $\(notif.cost) from \(notif.duration) of charging.").frame(maxWidth: .infinity, alignment: .center).padding()
                            }
                        }
                    }
                }
                            
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




