//
//  ContentView.swift
//  swiftUIChatter
//
//  Created by Jacob Klionsky on 10/27/22.
//

import SwiftUI

struct Filter {
    var filterOn: Bool
    var maxPrice: Double
    var minRating: Double
    var chargerType: Int
}

struct FilterView: View {
    @State var isExpanded = false
    @State var lightgray = false
    @Binding var filter : Filter
    @State var oldFilter : Filter

    init(filter: Binding<Filter>) {
        self._filter = filter
        self._oldFilter = State(initialValue: filter.wrappedValue)
    }
    
    
    var buttHeight = 50.0
    var buttWidth = 70.0
    
    var body: some View {
        
        VStack {
            Spacer()
          
            HStack {
            Text("Charger Type:")
            Button(action: {
                filter.chargerType = ((filter.chargerType != 120) ? 120 : 0)
                
            }) {
                VStack {
                    Image(systemName: "powerplug.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:25)
                        .padding(.bottom, -5)
                    Text("120V")
                        
                }
            }.frame(width: buttWidth, height: buttHeight)
                .foregroundColor(.white)
                .background((filter.chargerType == 120) ?   Color(.blue):  Color(.gray))
                .clipShape(Capsule())
            
            Button(action: {
                filter.chargerType = ((filter.chargerType != 240) ? 240 : 0)
                
            }) {
                VStack {
                    Image(systemName: "powerplug.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:25)
                        .padding(.bottom, -5)
                    Text("240V")
                        
                }
            }.frame(width: buttWidth, height: buttHeight)
                .foregroundColor(.white)
                .background((filter.chargerType == 240)  ?  Color(.blue):  Color(.gray))
                .clipShape(Capsule())
            }
            
                VStack{
                    
                    HStack {
                        Spacer()
                        Text(" Max Rate $\(String(format: "%.2f", round(filter.maxPrice*100)/100.0))/hr.")
                        Slider(value: $filter.maxPrice, in: 0...10).frame(width: 150)
                Spacer()
                    }
                }
            HStack {
            Text ("Min Host Rating:")
                StarReview(rating: $filter.minRating)
            }
            Spacer()
            Spacer()
            
            HStack {
                
                Spacer()
                
            Button(action: {
                filter = oldFilter
                filter.filterOn = false
            }) {
                VStack {
                    Text("Cancel")
                }
            }.frame(width: buttWidth, height: buttHeight)
                .foregroundColor(.white)
                .background(Color(.gray))
                .clipShape(Capsule())
                
                Spacer()
                
            Button(action: {
                filter.filterOn = false
                
            }) {
                VStack {
                    Text("Apply")
                        
                }
            }.frame(width: buttWidth, height: buttHeight)
                .foregroundColor(.white)
                .background(Color(.gray))
                .clipShape(Capsule())
                Spacer()
            
            }
            .padding(.vertical)
            
        }.background(Color.white)
        
    }
}


