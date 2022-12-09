//
//  DriverReviewChargingView.swift
//  swiftUIChatter
//
//  Created by Allison Kwang on 11/6/22.
//

import SwiftUI

struct DriverReviewChargingView: View {
    @State var rating = 0.0
    @State var subject = ""
    @State var message = ""
    @State var date = ""
    @Binding var showChargingView: Bool
    @State var about_me : HostAboutMe
    @State var cost: String
    @State var duration: String
    @State private var showAlert = false
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
                                var temp = HostReview()
                                temp.driver_id = remote_id
                                temp.subject = subject
                                temp.message = message
                                temp.date = date
                                temp.rating = rating
                                temp.user_id = about_me.user_id
                                temp.first_name = about_me.first_name
                                temp.last_name = about_me.last_name
                                temp.img_url = ""
                                var driver = DriverReview()
                                await API.shared.postReview(driver, type: "HOST", host: temp)
                                showChargingView.toggle()
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
                        //showChargingView.toggle()
                        self.showAlert = true
                        Task{
                            
                            await API.shared.updateChargerAvailablityToTrue(about_me.cid)
                            var activity = Activity(host_id: about_me.user_id, driver_id: remote_id, duration: duration, cost: cost)
                            await API.shared.postActivity(activity)
                            
                        }
                        
                    }){
                        Text("Done")
                        
                    }.alert(isPresented: $showAlert) {
                        Alert(title: Text("Completed Charge Notification"), message: Text("Check Activity Page to see history! You spent $\(cost) for \(duration) of charging."), dismissButton: .default(Text("OK"), action:{showChargingView.toggle()}))
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
/*
struct DriverReviewChargingView_Previews: PreviewProvider {
    static var previews: some View {
        DriverReviewChargingView(showChargingView: .constant(true))
    }
}
*/
