//
//  UserModeButtonView.swift
//  swiftUIChatter
//
//  Created by Samuel Cummins on 11/6/22.
//  Adapted from https://github.com/Tprezioso/ExpandableButtonSwiftUI/blob/main/ExpandableButton

import SwiftUI

struct UserModeButtonView: View {
    @Binding var isHost: Bool
    @State var isExpanded = false
    
    var hostText = "Host"
    var hostIcon = "house.and.flag.fill"
    var driverText = "Driver"
    var driverIcon = "bolt.car.fill"
    var buttHeight = 32.0
    var buttWidth = 52.0
    
    var body: some View {
        HStack {
            if isExpanded {
                Button(action: {
                    isHost.toggle()
                    withAnimation {
                        isExpanded.toggle()
                    }
                    
                }) {
                    VStack {
                        
                        Image(systemName: !isHost ? hostIcon : driverIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:20)
                            
                        if(isExpanded) {
                            Text(!isHost ? hostText : driverText)
                            .font(.footnote)
                            .padding(.top, -10)
                        }
                    }
                    
                        
                }.frame(width: buttWidth, height: buttHeight)
                    .foregroundColor(.white)
                    .background(Color(.gray))
                    .clipShape(Capsule())
            }
            
            
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
                
            }) {
                VStack {
                    
                    Image(systemName: isHost ? hostIcon : driverIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:20)
                    if(isExpanded) {
                        Text(isHost ? hostText : driverText)
                        .font(.footnote)
                        .padding(.top, -10)
                    }
                }
                
                    
            }.frame(width: buttWidth, height: buttHeight)
                .foregroundColor(.white)
                .background(Color(.gray))
                .clipShape(Capsule())
            
        }.frame(width: buttWidth, height: (isExpanded ? buttHeight : nil), alignment: .topLeading)
    }
}

struct UserModeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        UserModeButtonView(isHost: .constant(true))
    }
}
