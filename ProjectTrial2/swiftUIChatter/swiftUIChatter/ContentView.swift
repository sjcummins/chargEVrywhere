//
//  ContentView.swift
//  swiftUIChatter
//
//  Created by Jacob Klionsky on 10/27/22.
//

import SwiftUI

struct ContentView: View {
    @State private var isHost = false
    @State var img_url = ""
    var body: some View {
        ZStack {
            
            VStack {
                HStack {
                    Text("chargEVrywhere")
                        .frame(maxWidth: .infinity)
                }
                if isHost {
                       HostMainView()
                    }
                else {
                  MainView()
                }
            } //VStack
            
            VStack {
                HStack {
                    UserModeButtonView(isHost: self.$isHost)
                        .padding(.leading, 10)
                        .padding(.top, -5)
                    Spacer()
                    let username = defaults.string(forKey: "username")
                    let password = defaults.string(forKey: "password")
                    
                    //If credentials exist, get login infor
                    let v = Task{
                        if (username != nil && password != nil) {
                            let user_id = await API.shared.getLogin(username: username!, password: password!)
                            if user_id != nil {
                                let user = await API.shared.getUser2(id: user_id!.user_id)
                                self.img_url = user!.img_url!
                            }
                        }
                    }
                    if self.img_url != "" {
                        AsyncImage(url: URL(string: self.img_url)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:50, alignment: .topTrailing)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                                    .padding(.top, -10)
                                    .padding(.trailing, 5)
                            case .failure:
                                Image(systemName: "photo")
                            @unknown default:
                                
                                EmptyView()
                            }
                        }//AsyncImage
                    } //if
                    else {
                        
                    }
                }//HStack
                Spacer()
            }//Vstack
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

