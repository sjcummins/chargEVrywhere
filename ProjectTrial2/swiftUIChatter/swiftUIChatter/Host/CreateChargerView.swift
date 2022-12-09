//
//  CreateChargerView.swift
//  swiftUIChatter
//
//  Created by Allison Kwang on 11/8/22.
//

import SwiftUI
import GooglePlaces

struct CreateChargerView: View {
    @State private var address = [GMSAddressComponent]()
    @State var location = CLLocation()
    @State private var street_address: String = ""
    @State private var city_address: String = ""
    @State private var state_address: String = ""
    @State private var zipcode_address: String = ""
    @State private var charger_type: String = ""
    @State private var price: String = ""
    @State private var start_availability: String = ""
    @State private var end_availability: String = ""
    @State var openPlacePicker = false
    @State var currentlocation = true
    @State private var sourceType1: UIImagePickerController.SourceType = .camera
    @State private var sourceType2: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isCameraPickerDisplay = false
    @State private var isImagePickerDisplay = false
    @State private var chargerAdded = false
    @State private var cid : Int?
    @State private var numPhotosAdded = 0
   
    var body: some View {
        VStack{
            Text("Add a Charger then Photos")
            NavigationView{
                    Form {
                        if !chargerAdded {
                            VStack {
                                Group{
                                    VStack{
                                        
                                        HStack{
                                            Text("Enter Address")
                                            
                                            ZStack{
                                                
                                                if street_address == ""{
                                                    Text("Required")
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .foregroundColor(Color.gray).opacity(0.5)
                                                        .padding()
                                                }else{
                                                    Text("\(street_address)")
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .foregroundColor(Color.gray).opacity(0.5)
                                                        .padding()
                                                }
                                                Button(action: {
                                                    openPlacePicker.toggle()
                                                    currentlocation = false
                                                }){
                                                    Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                                                        .imageScale(.large)
                                                        .frame(maxWidth: .infinity)
                                                        .hidden()
                                                }
                                                .buttonStyle(.borderless)
                                            }
                                        }//HStack
                                        .sheet(isPresented: $openPlacePicker) {
                                            PlacePicker(address: $address, street_address: $street_address, city_address: $city_address, state_address: $state_address, zipcode_address:$zipcode_address, location: $location)
                                        }
                                        Group{
                                            Text("Street Address").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                                            TextField(text: $street_address, prompt: Text("Required")) {}
                                                .disableAutocorrection(true)
                                        }.padding([.top, .leading, .trailing])
                                        VStack{
                                            Text("City").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                                            TextField(text: $city_address, prompt: Text("Required")) {}
                                                .disableAutocorrection(true)
                                            
                                        }.padding(.horizontal)
                                        VStack{
                                            Text("State").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                                            TextField(text: $state_address, prompt: Text("Required")) {}
                                                .disableAutocorrection(true)
                                            
                                        }.padding(.horizontal)
                                    }//Group
                                    VStack{
                                        Text("Zip Code").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                                        TextField(text: $zipcode_address, prompt: Text("Required")) {}
                                            .disableAutocorrection(true)
                                        
                                    }.padding(.horizontal)
                                    
                                } //VStack
                                
                                Divider()
                                
                                Group{
                                    HStack{
                                        Text("Price")
                                        TextField(text: $price, prompt: Text("Required")) {}
                                            .disableAutocorrection(true)
                                            .autocapitalization(.none)
                                    }.padding(.horizontal)
                                    HStack{
                                        Text("Type")
                                        TextField(text: $charger_type, prompt: Text("Required")) {}
                                            .disableAutocorrection(true)
                                            .autocapitalization(.none)
                                    }.padding(.horizontal)
                                    HStack{
                                        Text("Start Availability")
                                        TextField(text: $start_availability, prompt: Text("Required")) {}
                                            .disableAutocorrection(true)
                                            .autocapitalization(.none)
                                    }.padding(.horizontal)
                                    HStack{
                                        Text("End Availability")
                                        TextField(text: $end_availability, prompt: Text("Required")) {}
                                            .disableAutocorrection(true)
                                        
                                    }.padding(.horizontal)
                                }
                                Divider()
                                
                            } //VStack
                            .textFieldStyle(.roundedBorder)
                            .listRowSeparator(.hidden)
                            Button("Add Charger") {
                                //Submit Data
                                
                                Task{
                                    cid = await API.shared.postCharger(ChargerData(user_id: remote_id, available: "TRUE", start_time_availability: "1999-01-08 04:05:06",end_time_availability: "2023-01-08 04:05:06", charger_type: self.charger_type, price:self.price, street_address: self.street_address, city_address: self.city_address, state_address: self.state_address, zipcode_address: self.zipcode_address, latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude)))
                                    print(cid!)
                                    chargerAdded.toggle()
                                    
                                }
                            }.buttonStyle(.borderedProminent).frame(maxWidth: .infinity, alignment:.trailing).padding(.top)
                        }// if
                        if chargerAdded {
                            if numPhotosAdded == 0 {
                                Label("Charger Successfully Added", systemImage: "checkmark.circle").foregroundColor(Color.green)
                            }
                            else if numPhotosAdded == 1{
                                Label("\(numPhotosAdded) Photo was successfully added", systemImage: "checkmark.circle").foregroundColor(Color.green)
                            }
                            else {
                                Label("\(numPhotosAdded) Photos were successfully added", systemImage: "checkmark.circle").foregroundColor(Color.green)
                            }
                            Group{
                                //add photos
                                HStack{
                                    
                                    if selectedImage != nil {
                                        Spacer()
                                        Image(uiImage: selectedImage!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                                            .frame(width: 250, height: 250)
                                        Spacer()
                                    } else {
                                        Spacer()
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                                            .frame(width: 250, height: 250)
                                        Spacer()
                                    }
                                
                                }
                                HStack{
                                    Button(action: {
                                        print("change to camera")
                                        self.isCameraPickerDisplay.toggle()
                                        
                                    },
                                           label: {Label("Camera", systemImage: "camera")})
                                    .padding()
                                    .buttonStyle(.borderless)
                                    Button(action: {
                                        print("change to photolibrary")
                                        self.isImagePickerDisplay.toggle()
                                        
                                    },
                                           label: {Label("Photo", systemImage: "photo")})
                                    .padding()
                                    .buttonStyle(.borderless)
                                }//HStack
                                Button("Add Photo") {
                                    //Submit Data
                                    
                                    Task{
                                        
                                        // api call to post photo
                                        await API.shared.postChargerPhoto(remote_id, cid: cid!, image: selectedImage)
                                        
                                        numPhotosAdded += 1
                                        
                                        
                                    }
                                }.buttonStyle(.borderedProminent).frame(maxWidth: .infinity, alignment:.trailing).padding(.top)
                                
                                .sheet(isPresented: self.$isImagePickerDisplay) {
                                    ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType2)
                                }
                                .sheet(isPresented: self.$isCameraPickerDisplay) {
                                    ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType1)
                                }
                                
                            }//Group
                        }//if
                    } // Form
            }//Navigation View
        }//VStack
        
    }//View

}


//struct CreateChargerView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateChargerView()
//    }
//}


//NavigationView{
//    VStack {
//        Form {
//            VStack {
//                HStack{
//                    Text("Enter Address")
//
//                    ZStack{
//
//                        if street_address == ""{
//                            Text("Required")
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .foregroundColor(Color.gray).opacity(0.5)
//                                .padding()
//                        }else{
//                            Text("\(street_address)")
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .foregroundColor(Color.gray).opacity(0.5)
//                                .padding()
//                        }
//                        Button(action: {
//                            openPlacePicker.toggle()
//                            currentlocation = false
//                        }){
//                            Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
//                                .imageScale(.large)
//                                .frame(maxWidth: .infinity)
//                                .hidden()
//                        }
//                        .buttonStyle(.borderless)
//                    }
//                }//HStack
////                        .sheet(isPresented: $openPlacePicker) {
////                            PlacePicker(address: $address, location: $location)
////                            let name = $address.addressComponents.first(where: { $0.type == "city" })?.name
//
//
//
//                Divider()
//            }//VStack
//
//        } // Form
//    }//Vstack
//}//Navigation View
