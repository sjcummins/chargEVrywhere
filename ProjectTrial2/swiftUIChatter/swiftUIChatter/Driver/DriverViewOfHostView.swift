//
//  DriverViewOfHostView.swift
//  swiftUIChatter
//
//  Created by Allison Kwang on 11/6/22.
//

import SwiftUI

struct DriverViewOfHostView: View {
    @Environment(\.dismiss) var dismiss
    
    
    
    
    @State private var showChargingView = false
    @State private var isPresented = false
    @State private var isPresentingConfirm: Bool = false
    @State var about_me : HostAboutMe
    @State var booler = true
    @State var reviews = [HostReview]()
    @State var urls = [PhotoURL]()
    //reviews.removeAll()
    
    var body: some View {
       
        if (booler == true) {
            var d = Task {
                var tempReviews = await API.shared.getHostReviews(about_me.user_id)!
                //reviews = await API.shared.getHostReviews(about_me.user_id)!
                if (tempReviews.count != reviews.count) {
                    reviews = tempReviews
                }
                //reviews = await API.shared.getHostReviews(about_me.user_id)!
                booler = false
                self.urls = await API.shared.getChargerPhotos(cid: about_me.cid) ?? []
            }
        }
        
        //let id = about_me.user_id
        
        ZStack{
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
                                }.task{
                                    
                                    let reviews = /* MAKE API CALL HERE */ [
                                        HostReview(user_id: 2,first_name: "Jacob", last_name: "Klionsky", date: "01-01-2022", subject: "Awesome", message: "Best charger ever! ", rating: 4, img_url: ""),
                                        HostReview(user_id: 3,first_name: "Jabrill", last_name: "Peppers", date: "01-01-2023", subject: "Good driver", message: "I just love charging so so much!", rating: 5, img_url: ""),
                                        HostReview(user_id: 4,first_name: "Mr", last_name: "Potatohead", date: "01-01-2024", subject: "God Bless", message: "Super fast, super fun, super innovative!", rating: 4, img_url: ""),
                                        HostReview(user_id: 5,first_name: "Anon", last_name: "Anon", date: "01-05-2022", subject: "Anti-Charger.", message: "I hate this place!", rating: 1, img_url: ""),
                                        HostReview(user_id: 6,first_name: "Super", last_name: "EV", date: "05-01-2022", subject: "Lost", message: "Where am I?", rating: 4, img_url: ""),
                                        
                                    ]
                                    
                                }
                                .listRowSeparator(.hidden)
                            
                            Text(about_me.first_name + " " + about_me.last_name)
                                .font(.title)
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text("Charging since '" + String(about_me.charging_since%100)).font(.caption)
                                .listRowSeparator(.hidden)
                        
                            NavigationLink(destination: DriverHostPhotosView(urls: urls)) {
                                
                                
                            HStack{
                                Text("   ")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Photos")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            
                        }
                        
                        .buttonStyle(PlainButtonStyle())
                            Spacer()
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
                    
                        HStack{
                            VStack(alignment: .leading){
                                Text("Address")
                                    .font(.footnote)
                                Text("\(about_me.street_address)\n\(about_me.city_address), \(about_me.state_address) \(about_me.zipcode_address)"
                                ).textSelection(.enabled)
                            }
                            Spacer()
                            Button(action: {
                                isPresentingConfirm = true
                            }) {
                                Image(systemName:"arrow.triangle.turn.up.right.diamond")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:30)
                            }
                            .confirmationDialog("Open with ...", isPresented: $isPresentingConfirm) {
                                Button {
                                    // open google maps
                                    let google_url = URL(string: "comgooglemaps://?saddr=&daddr=\(about_me.latitude),\(about_me.longitude)&directionsmode=driving")
                                    if UIApplication.shared.canOpenURL(google_url!) {
                                           UIApplication.shared.open(google_url!, options: [:], completionHandler: nil)
                                     }
                                     else{
                                         let urlBrowser = URL(string: "https://www.google.co.in/maps/dir/??saddr=&daddr=\(about_me.latitude),\(about_me.longitude)&directionsmode=driving")
                                                     
                                            UIApplication.shared.open(urlBrowser!, options: [:], completionHandler: nil)
                                     }
                                    
                                } label: {
                                    Label("Google Maps", systemImage: "arrow.triangle.turn.up.right.diamond")
                                }
                                Button {
                                    // open apple maps
                                    let apple_url = URL(string: "maps://?saddr=&daddr=\(about_me.latitude),\(about_me.longitude)")
                                    if UIApplication.shared.canOpenURL(apple_url!) {
                                          UIApplication.shared.open(apple_url!, options: [:], completionHandler: nil)
                                    }
                                } label: {
                                    Label("Apple Maps", systemImage: "arrow.triangle.turn.up.right.diamond")
                                }
                            }
                        } //HStack
                        
                        
                        VStack(alignment: .leading){
                            Text("Charger Type").listRowSeparator(.hidden).font(.footnote)
                            Text(about_me.power_level).listRowSeparator(.hidden)
                        }
                        VStack(alignment: .leading){
                            Text("Price").listRowSeparator(.hidden).font(.footnote)
                            Text(about_me.cost).listRowSeparator(.hidden)
                        }
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
                                        Group{
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
                                        }
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
                        .textSelection(.enabled)
                    } //ScrollViewReader
                } //NavigationView
                .navigationBarTitle(Text(about_me.first_name + " " + about_me.last_name), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {dismiss()}){Text("Done")})
            }.navigationViewStyle(StackNavigationViewStyle())
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showChargingView.toggle()
                        Task{
                            
                            var request = Request(user_id: remote_id, host_id: about_me.user_id, charger_id: about_me.cid, requested: "TRUE")
                            await API.shared.postRequest(request)
                            
                        }
                    },
                           label: {Text("Start Charge!")
                            .frame(width: 120, height: 40)
                            .foregroundColor(Color.white)
                    })
                    .background(Color.blue)
                    .cornerRadius(10.0)
                    .padding([.bottom, .trailing], 10.0)
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 3,
                            x: 3,
                            y: 3)
                    .sheet(isPresented: $showChargingView) {
                        DriverRequestChargingView(showChargingView: self.$showChargingView, about_me: self.about_me)
                    }
                } // HStack
            } // VStack
        } //ZStack
    }//bodyview
        
}

//struct DriverViewOfHostView_Previews: PreviewProvider {
//    static var previews: some View {
//        DriverViewOfHostView()
//    }
//}
