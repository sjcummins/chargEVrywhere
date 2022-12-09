//
//  CreateUserView.swift
//  swiftUIChatter
//
//  Created by Allison Kwang on 11/8/22.
//

import SwiftUI
public var defaults = UserDefaults.standard
struct CreateUserDriverView: View {
    @State private var first_name: String = ""
    @State private var last_name: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var birthdate: Date = Date()
    @State private var model: String = ""
    @State private var color: String = ""
    @State private var license: String = ""
    @State private var description: String = ""
    @State private var hide_password: Bool = true
    @FocusState var in_focus: Field?
    @State private var sourceType1: UIImagePickerController.SourceType = .camera
    @State private var sourceType2: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isCameraPickerDisplay = false
    @State private var isImagePickerDisplay = false
    @State private var userAdded = false
    @State private var err: String = ""
    @State var showErr = false
    @Environment(\.dismiss) var dismiss
    
//    public var defaults = UserDefaults.standard
    
    enum Field {
        case hidden, plaintext
    }

    var body: some View {


        NavigationView{
            VStack {
                Form {
                    VStack {
                        Group{
                            if selectedImage != nil {
                                Image(uiImage: selectedImage!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .frame(width: 250, height: 250)
                            } else {
                                Image(systemName: "photo.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .frame(width: 250, height: 250)
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
                            }
                            HStack{
                                
                                Text("First Name")
                                TextField(text: $first_name, prompt: Text("Required")) {}
                                    .disableAutocorrection(true)
                            }.padding([.top, .leading, .trailing])
                            HStack{
                                Text("Last Name")
                                TextField(text: $last_name, prompt: Text("Required")) {}
                                    .disableAutocorrection(true)
                                
                            }.padding(.horizontal)
                            
                            DatePicker(
                                "Birthday",
                                selection: $birthdate,
                                displayedComponents: [.date])
                            .padding(.horizontal)
                            
                        }
                        Divider()
                        
                        Group{
                            HStack{
                                Text("Username")
                                TextField(text: $username, prompt: Text("Required")) {}
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                            }.padding(.horizontal)
                            
                            HStack{
                                Text("Password")
                                ZStack(alignment: .trailing) {
                                    
                                    HStack {
                                        if hide_password {
                                            SecureField(text: $password, prompt: Text("Required")){}
                                                .focused($in_focus, equals: .plaintext)
                                                .disableAutocorrection(true)
                                                .autocapitalization(.none)
                                        } else {
                                            TextField(text: $password, prompt: Text("Required")){}
                                                .focused($in_focus, equals: .hidden)
                                                .disableAutocorrection(true)
                                                .autocapitalization(.none)
                                        }
                                        
                                    }//HStack
                                    Button(action: {
                                        self.hide_password.toggle()
                                        in_focus = hide_password ? .hidden : .plaintext
                                    }) {
                                        Image(systemName: self.hide_password ? "eye.slash" : "eye")
                                            .accentColor(.gray)
                                    }
                                    .buttonStyle(.borderless)
                                    .padding(.trailing, 5)
                                    
                                }//ZStack
                            }//HStack
                            .padding(.horizontal)
                        }
                        Divider()
                        HStack{
                            Text("Vehicle Model")
                            TextField(text: $model, prompt: Text("Required")) {}
                                .disableAutocorrection(true)
                               

                        }.padding(.horizontal)
                        HStack{
                            Text("Vehicle Color")
                            TextField(text: $color, prompt: Text("Required")) {}
                                .disableAutocorrection(true)

                        }.padding(.horizontal)
                        
                        Divider()
                        Text("Tell us a little bit about yourself...")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextEditor(text: $description)
                            .padding(4)
                            .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary).opacity(0.2))

                    } //VStack
                    .textFieldStyle(.roundedBorder)
                    .listRowSeparator(.hidden)
                    Button("Sign Up") {
                        //Submit Data
                        Task{
                            let calendar = Calendar.current
                            let components = calendar.dateComponents([.year, .month, .day], from: birthdate)
                            if (self.first_name == "") {
                                err = "First name cannot be blank"
                                showErr = true
                                return
                            }
                            else if (self.last_name == "") {
                                err = "Last name cannot be blank"
                                showErr = true
                                return
                            }
                            else if (self.username == "") {
                                err = "Username cannot be blank"
                                showErr = true
                                return
                            }
                            else if (self.password == "") {
                                err = "Password cannot be blank"
                                showErr = true
                                return
                            }
                            else if (self.model == "") {
                                err = "Vehicle model cannot be blank"
                                showErr = true
                                return
                            }
                            else if (self.color == "") {
                                err = "Vehicle color cannot be blank"
                                showErr = true
                                return
                            }
                            else if (self.selectedImage == nil) {
                                err = "Must add profile picture"
                                showErr = true
                                return
                            }
                            
                            
                            let user_id = await API.shared.postUser2(User(first_name: self.first_name, last_name: self.last_name, year_of_birth: components.year!, month_of_birth: components.month!, day_of_birth: components.day!, username: self.username, password: self.password, charging_since: 2022, description: self.description), image: selectedImage)
                            
                            if (user_id != nil) {
                                remote_id = user_id!
                                showErr = false
                                print(remote_id)
                                userAdded.toggle()
                                //Store sign in values
                                defaults.set(user_id, forKey: "remote_id")
                                defaults.set(self.first_name, forKey: "first_name")
                                defaults.set(self.last_name, forKey: "last_name")
                                defaults.set(components.year!, forKey: "year_of_birth")
                                defaults.set(components.month!, forKey: "month_of_birth")
                                defaults.set(components.day!, forKey: "day_of_birth")
                                defaults.set(self.username, forKey: "username")
                                
                                defaults.set(self.password, forKey: "password")
                                
                                print(defaults.string(forKey: "password")!)
                               
                                defaults.set(self.description, forKey: "description")
                            }
                            else{
                                err = "An error occurred while trying to create driver profile"
                                showErr = true
                            }
                            
                            
                            

                        }
                        
                    }.buttonStyle(.borderedProminent).frame(maxWidth: .infinity, alignment:.trailing).padding(.top)
                } // Form
                
                .sheet(isPresented: self.$isImagePickerDisplay) {
                    ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType2)
                }
                .sheet(isPresented: self.$isCameraPickerDisplay) {
                    ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType1)
                }
                
                if ($showErr.wrappedValue){
                    Text($err.wrappedValue).foregroundColor(.red).padding(.horizontal).padding(.bottom)
                }
                
                if userAdded {
                    Label("Host Profile Successfully Added", systemImage: "checkmark.circle").foregroundColor(Color.green)
                    
                    Button(action: {dismiss()}){Text("Done")}.padding(.bottom)
                    
                }
            } // VStack
        }//Navigation View
        
    } // VStack
    @State private var isPresenting = false
}

struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserDriverView()
    }
}
