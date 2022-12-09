
import SwiftUI
import GoogleMaps

struct GoogleMapsView: UIViewRepresentable {
    // 1
    @ObservedObject var locationManager = LocationManager()
    private let zoom: Float = 10.0
    
    // 2
    func makeUIView(context: Self.Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.latitude, longitude: locationManager.longitude, zoom: zoom)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        return mapView
    }
    
    // 3
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.latitude, longitude: locationManager.longitude, zoom: zoom)
        mapView.camera = camera
        
        
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude:
                                                            locationManager.latitude, longitude: locationManager.longitude))
      
        let position = CLLocationCoordinate2D(latitude:
                                                locationManager.latitude, longitude: locationManager.longitude)
        let marker = GMSMarker(position: position)
        marker.title = "Current Location"
        marker.map = mapView
    }
    
}


struct GoogleMapsView_Previews: PreviewProvider {    
    static var previews: some View {
        GoogleMapsView()
    }
}
