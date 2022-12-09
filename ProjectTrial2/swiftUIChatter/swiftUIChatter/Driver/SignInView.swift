//
//  SignInView.swift
//  swiftUIChatter
//
//  Created by Allison Kwang on 11/8/22.
//

import SwiftUI

struct SignInView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var forgot: String = "Forgot password?"
    @State private var err: String = ""
    @State var showErr = false
    @State private var hide_password: Bool = true
    @FocusState var in_focus: Field?
    enum Field {
        case hidden, plaintext
    }
    var body: some View {
        Form{
                VStack{
                    Spacer()
                    Text("Welcome Back!")
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
                }//VStack
                .textFieldStyle(.roundedBorder)
                .listRowSeparator(.hidden)
            HStack{
                Button(forgot) {
                    forgot = "Too bad!"
                }.buttonStyle(.borderless)
                Spacer()
                Button("Sign In") {
                    
                    Task{
                        if (self.username == "") {
                            err = "Username cannot be blank"
                            showErr = true
                            return
                        }
                        else if (self.password == "") {
                            err = "Password cannot be blank"
                            showErr = true
                            return
                        }
                        
                        let user_id = await API.shared.getLogin(username: self.username, password: self.password)
                        
                        
                        
                        if (user_id != nil) {
                            remote_id = user_id!.user_id
                            showErr = false
                            print(remote_id)
                            //Store sign in values
                            defaults.set(user_id!.user_id, forKey: "remote_id")
                            defaults.set(self.username, forKey: "username")
                            defaults.set(self.password, forKey: "password")
                        }
                        else{
                            err = "Invalid username or password"
                            showErr = true
                        }
                        print(remote_id)
                    }
                    //Submit Data
            
                }.buttonStyle(.borderedProminent)
            }.padding(.horizontal).padding(.top)
            if ($showErr.wrappedValue){
                Text($err.wrappedValue).foregroundColor(.red).padding(.horizontal)
            }
            
        }//Form
        

    }//View
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
