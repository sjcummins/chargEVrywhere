
import SwiftUI
import GoogleMaps


struct GoogleMapsViewCustomized: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(owner: self)
    }
    
    

    
    
    // 1
    var location = CLLocation()
    @Binding var chargerarray : [ChargerData]
    @Binding var filter : Filter
    private let zoom: Float = 15.0
    
    // 2
    func makeUIView(context: Self.Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoom)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = context.coordinator
        return mapView
    }
    
    // 3
    func updateUIView(_ mapView: GMSMapView, context: Context) {
     
        mapView.clear()
            //let camera =  GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoom)
        
         mapView.animate(toLocation: CLLocationCoordinate2D(latitude:
                                                                location.coordinate.latitude, longitude: location.coordinate.longitude))
        

        // State for markers displayed on the map for each city in `cities`
        @State var charger_markers: [GMSMarker] = chargerarray.map {
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: Double($0.latitude) ?? 0 , longitude: Double($0.longitude) ?? 0 ) )
            marker.title = $0.street_address
            marker.icon = drawChargerIcon(type: $0.charger_type, available: $0.available == "TRUE" ? true : false) //$0.available ?  :
            
            let c : ChargerData = $0
            Task {
                let user = await API.shared.getUser2(id: c.user_id)
                if (user?.user_id != nil) {
                    let about_me = HostAboutMe(user_id: user!.user_id, first_name: user!.first_name, last_name: user!.last_name, average_rating: 4.5, charging_since: user!.charging_since, description: user!.description, street_address: c.street_address, city_address: c.city_address, state_address: c.state_address, zipcode_address: c.zipcode_address, miles_away: 0, power_level: c.charger_type, cost: c.price, latitude: Double(c.latitude)!, longitude: Double(c.longitude)!, charger_name: c.street_address, type: c.charger_type, available: (c.available == "TRUE" ? true : false), cid: c.cid, img_url: user!.img_url!)
                    marker.userData = ["charger" : c, "about_me" : about_me]
                    marker.map = passesFilters(marker: marker, filter: filter) ? mapView : nil
                    
                }
                else{
                    print("nil charger")
                }//else
                
            }//task
          return marker
        }
    }
    func drawChargerIcon(type: String, available: Bool) -> UIImage {
        let speed = type == "240V" ? "fast" : "slow"
        let avail = available ? "avail" : "unavail"
        let icon = UIImage(named: speed+"_"+avail)
        let oldWidth = icon!.size.width
        let scaleFactor = 30 / oldWidth

        let newHeight = icon!.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor

        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        icon!.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    func imageWithView(view: UIView) -> UIImage {
        var image: UIImage?
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return image ?? UIImage()
    }
    
    func passesFilters(marker: GMSMarker, filter: Filter) -> Bool {
        let about_me = ((marker.userData as! [String: Any])["about_me"]) as! HostAboutMe
        return ( Double(about_me.cost) ?? 999 < filter.maxPrice &&
                 Double(about_me.average_rating) > filter.minRating &&
                (filter.chargerType != 0 ? ((about_me.type == "240V" ? 240 : 120) == filter.chargerType) : true) //if the filtered charger type isn't 0 (0 = either), return whether the host charger matches the filtered charger type, else return true
        )
    }
    class Coordinator: NSObject, GMSMapViewDelegate {
       let owner: GoogleMapsViewCustomized       // access to owner view members,
        @State private var data: [String : Any] = [String:Any]()

       init(owner: GoogleMapsViewCustomized) {
         self.owner = owner
       }
        
        func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
            print("USERDATA")
            print(marker.userData as! [String: Any])
//            self.data = (marker.userData as! [String: Any])
            let callout = UIHostingController(rootView: ChargerMarkerInfoWindow(data: (marker.userData as! [String: Any])))
//            marker.userData = self.$data
            callout.view.frame = CGRect(x: 0, y: 0, width: 200, height: 75)
            callout.view.isUserInteractionEnabled = true
            callout.view.layer.cornerRadius = 10
            return callout.view
        }
        
        func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
            let callout = UIHostingController(rootView: DriverViewOfHostView(about_me: ((marker.userData as! [String: Any])["about_me"]) as! HostAboutMe))
            let vc = UIViewController()
            vc.view = mapView
            
            vc.present(callout, animated: true, completion: nil)
          
        }
        

    }

}

//
//struct GoogleMapsViewCustomized_Previews: PreviewProvider {
//    static var previews: some View {
//        GoogleMapsViewCustomized(location: CLLocation())
//    }
//}

