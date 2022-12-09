//
//  HostViewOfDriverView.swift
//  swiftUIChatter
//
//  Created by Allison Kwang on 11/5/22.
//

import SwiftUI

struct HostViewOfDriverView: View {
    @Binding var showSheetView: Bool
    @Binding var user_id: Int
    
    @Binding var about_me : DriverAboutMe
    @State var reviews = [DriverReview]()
    var body: some View {
        


        
//        let about_me = DriverAboutMe(user_id: 1, first_name: "Sugih", last_name: "Jamin", average_rating: 4.5, charging_since: 2022, description: "Hi, my name is Sugih Jamin, I have a car.")
        /*let reviews = /* MAKE API CALL HERE */ [
            DriverReview(user_id: 2,first_name: "Need", last_name: "Energy", date: "01-01-2022", subject: "Awesome", message: "Really really low energy right now, needed to charge and Sugi had the perfect charger for you", rating: 4),
            DriverReview(user_id: 3,first_name: "Happy", last_name: "Charger", date: "01-01-2023", subject: "Good driver", message: "Lalala I love charging", rating: 5),
            DriverReview(user_id: 4,first_name: "Anon", last_name: "Anon", date: "01-01-2024", subject: "Seems like a CSE professor", message: "Great host, great teacher, I love this!", rating: 4),
            DriverReview(user_id: 5,first_name: "Plz", last_name: "Help", date: "01-05-2022", subject: "Walked home", message: "I tried to charge but the charger didn't work and I was out of energy so I had to walk home 20 miles. Never using Sugi's charger again", rating: 1),
            DriverReview(user_id: 6,first_name: "Yes", last_name: "Sir", date: "05-01-2022", subject: "Charged Up", message: "I'm fricking charged up and ready to win the day, I love ChargEVrywhere and I love Sugi", rating: 4),
        
        ] */
        
        NavigationView {
            ScrollViewReader { proxy in
                List {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            AsyncImage(url: URL(string: about_me.img_url)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image.resizable()
                                         .aspectRatio(contentMode: .fill)
                                         .frame(width:200)
                                         .clipShape(Circle())
                                         .shadow(radius: 10)
                                case .failure:
                                    Image(systemName: "photo")
                                @unknown default:
                                    
                                    EmptyView()
                                }
                            }//AsyncImage
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                        .task{
                            let user_info = await API.shared.getUser(id: user_id)
//                            let user_info = await API.shared.getUser2(id: user_id)
                            let vehicle_info = await API.shared.getVehicle(id: user_id)
//                            let avg_rating = API.shared.getAverageRating(user_id:user_id, receiving_review_type: "DRIVER")
                            /*self.about_me = DriverAboutMe(user_id: user_id, first_name: user_info!.first_name, last_name: user_info!.last_name, average_rating: 4.5, charging_since: user_info!.charging_since, description: user_info!.description, vehicle_model: vehicle_info!.model, vehicle_color: vehicle_info!.color, vehicle_platenum: vehicle_info!.lics_number) */
                            
                            reviews = await API.shared.getDriverReviews(user_id) ?? [DriverReview(user_id: 2,first_name: "Need", last_name: "Energy", date: "01-01-2022", subject: "Awesome", message: "Really really low energy right now, needed to charge and Sugi had the perfect charger for you", rating: 2, host_id: -1, img_url: "")]
                            
                        }
                        
                        Text(about_me.first_name + " " + about_me.last_name)
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("Charging since '" + String(about_me.charging_since%100)).font(.caption)
                            .listRowSeparator(.hidden)
                        Text(String(about_me.vehicle_color) + " " + String(about_me.vehicle_model)).font(.caption)
                            .listRowSeparator(.hidden)
                        Text("Plate Number: " + String(about_me.vehicle_platenum)).font(.caption)
                            .listRowSeparator(.hidden)
                    
                        NavigationLink(destination: HostDriverPhotosView(img_url: about_me.img_url)) {
//                        Label("Photos", systemName: "star.fill")
//                        Label("Lightning", systemImage: "bolt.fill")
                        HStack{
                            Text("   ")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Photos")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    }//VStack
                    
                    
                    HStack {
                        Text("Average Rating: " + String(round(about_me.average_rating*10)/10) + "/5")
                            .frame(width: 175, height: 30, alignment: .leading)
                        Image(systemName: "star.fill").foregroundColor(Color.yellow).mask(
                            Rectangle()
                                .size(width: CGFloat(23.5 * (Double(about_me.average_rating) - 0)), height: 50)
                        )
                        Image(systemName: "star.fill").foregroundColor(Color.yellow).mask(
                            Rectangle()
                                .size(width: CGFloat(23.5 * (Double(about_me.average_rating) - 1)), height: 50)
                        )
                        Image(systemName: "star.fill").foregroundColor(Color.yellow).mask(
                            Rectangle()
                                .size(width: CGFloat(23.5 * (Double(about_me.average_rating) - 2)), height: 50)
                        )
                        Image(systemName: "star.fill").foregroundColor(Color.yellow).mask(
                            Rectangle()
                                .size(width: CGFloat(23.5 * (Double(about_me.average_rating) - 3)), height: 50)
                        )
                        Image(systemName: "star.fill").foregroundColor(Color.yellow).mask(
                            Rectangle()
                                .size(width: CGFloat(23.5 * (Double(about_me.average_rating) - 4)), height: 50)
                        )
                    } //HStack
                  
                    Text(about_me.description)
                    
                    Text("Reviews (\(reviews.count))")
                        .font(.title)
                    
                    VStack(alignment: .leading) {
                        ForEach(reviews) { review in
                                
                                Text("\(review.subject)").font(.title3)
                                    .fontWeight(.bold)
                                    .lineLimit(nil)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Spacer()
                                HStack {
                                    Text("Rating: ")
                                        .frame(width: 55, alignment: .leading)
                                    Image(systemName: "star.fill").foregroundColor(Color.yellow)
                                        .mask(
                                            Rectangle()
                                                .size(width: CGFloat(23.5 * (Double(review.rating) - 0)), height: 30)
                                        ) //HStack
                                    
                                    Image(systemName: "star.fill").foregroundColor(Color.yellow).mask(
                                        Rectangle()
                                            .size(width: CGFloat(23.5 * (Double(review.rating) - 1)), height: 30)
                                    )
                                    Image(systemName: "star.fill").foregroundColor(Color.yellow).mask(
                                        Rectangle()
                                            .size(width: CGFloat(23.5 * (Double(review.rating) - 2)), height: 30)
                                    )
                                    Image(systemName: "star.fill").foregroundColor(Color.yellow).mask(
                                        Rectangle()
                                            .size(width: CGFloat(23.5 * (Double(review.rating) - 3)), height: 30)
                                    )
                                    Image(systemName: "star.fill").foregroundColor(Color.yellow).mask(
                                        Rectangle()
                                            .size(width: CGFloat(23.5 * (Double(review.rating) - 4)), height: 30)
                                    )
                                    Text("(" + String(round(review.rating*10)/10) + "/5)")
                                }//HStack
                                Spacer()
                                
                                Text("\(review.message)").font(.body).frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(nil)
                                
                            
                            HStack {
                                AsyncImage(url: URL(string: review.img_url)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width:50)
                                            .clipShape(Circle())
                                            .shadow(radius: 10)
                                    case .failure:
                                        Image(systemName: "photo")
                                    @unknown default:
                                        
                                        EmptyView()
                                    }
                                }//AsyncImage
                                Text("\(review.first_name) \(review.last_name)").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(review.date)").font(.footnote).frame(width: 100, height: 40, alignment: .trailing)
                            } //HStack
                            Spacer()
                            Divider()
                            
                        } //ForEach
                    }// List
                } //ScrollViewReader
            } //NavigationView
            .navigationBarTitle(Text(about_me.first_name + " " + about_me.last_name), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {self.showSheetView = false}){Text("Done")})
        }.navigationViewStyle(StackNavigationViewStyle())
    }//bodyview
}//struct
//
//struct HostViewOfDriverView_Previews: PreviewProvider {
//    static var previews: some View {
//        HostViewOfDriverView(showSheetView: .constant(true))
//    }
//}
