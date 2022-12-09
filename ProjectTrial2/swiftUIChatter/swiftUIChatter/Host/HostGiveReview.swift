//
//  HostGiveReview.swift
//  swiftUIChatter
//
//  Created by Branden Mayday on 12/6/22.
//

import Foundation
import SwiftUI

struct HostGiveReview: View {
    @State var rating = 0.0
    @State var subject = ""
    @State var message = ""
    @State var date = ""
    @Binding var showChargingView: Bool
    @State var about_me : HostAboutMe
    var body: some View {
        NavigationView{
            VStack{
                
                Form {
                    VStack {
                        HStack{
                            Text("Subject")
                            TextEditor(text: $subject)
                                .disableAutocorrection(true)
                        }
                        HStack{
                            Text("Message")
                            TextEditor(text: $message)
                                .disableAutocorrection(true)
                        }
                        HStack{
                            Text("Date")
                            TextEditor(text: $date)
                                .disableAutocorrection(true)
                        }
                        HStack{
                            Slider(value: $rating, in: 0...5, step: 1)
                            Text(String(Int(rating)))
                            
                            //Text("Rating")
                            //TextEditor(text: $rating)
                                
                            
                            //.disableAutocorrection(true)
                        }
                        Spacer()
                        Button("Submit Review") {
                            Task{
                                var temp = DriverReview()
                                temp.host_id = remote_id
                                temp.subject = subject
                                temp.message = message
                                temp.date = date
                                temp.rating = rating
                                temp.user_id = about_me.user_id
                                temp.first_name = about_me.first_name
                                temp.last_name = about_me.last_name
                                temp.img_url = ""
                                var hos = HostReview()
                                await API.shared.postReview(temp, type: "DRIVER", host: hos)
                                
                            }
                        }
                    } //VStack
                }//Form
                
                /*
                ProgressView(value: 0.8){
                    Text("Review            ").frame(maxWidth: .infinity, alignment: .trailing)
                }.padding()
                Spacer()
                //Content for Review
                TextEditor(text: .constant("Placeholder"))
                Spacer()
//                NavigationLink(destination: HomeView()){
//                    Text("Done")
//
//                }
                 */
                HStack {
                    Button(action: {
                        showChargingView.toggle()
                    }){
                        Text("Done")
                    }
                    .padding(.bottom, 10)
                    //Spacer()
                    /*
                    NavigationLink(destination: LeaveReviewForHost(about_me: self.about_me)){
                                      Text("Leave a Review")
                    
                    }.padding(.bottom, 10)
                        .padding(.horizontal, 50)
                    */
                }
                
                
            }//VStack
            
        }//NavigationView
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
    }//View
}
