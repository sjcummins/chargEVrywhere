//
//  PlacePicker.swift
//  swiftUIChatter
//
//  Created by Samuel Cummins on 11/3/22.
//

import Foundation
import SwiftUI
import GooglePlaces


struct PlacePicker: UIViewControllerRepresentable {
    
    func makeCoordinator() -> GooglePlacesCoordinator {
        GooglePlacesCoordinator(self)
    }
    @Environment(\.presentationMode) var presentationMode
    @Binding var address: [GMSAddressComponent]
    @Binding var street_address: String
    @Binding var city_address: String
    @Binding var state_address: String
    @Binding var zipcode_address: String
    @Binding var location: CLLocation
    func makeUIViewController(context: UIViewControllerRepresentableContext<PlacePicker>) -> GMSAutocompleteViewController {

        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = context.coordinator
        

        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                  UInt(GMSPlaceField.placeID.rawValue) |
                                                  UInt(GMSPlaceField.coordinate.rawValue) |
                                                  GMSPlaceField.addressComponents.rawValue |
                                                  GMSPlaceField.formattedAddress.rawValue)
                                      autocompleteController.placeFields = fields

        return autocompleteController
    }

    func updateUIViewController(_ uiViewController: GMSAutocompleteViewController, context: UIViewControllerRepresentableContext<PlacePicker>) {
    }

    class GooglePlacesCoordinator: NSObject, UINavigationControllerDelegate, GMSAutocompleteViewControllerDelegate {

        var parent: PlacePicker

        init(_ parent: PlacePicker) {
            self.parent = parent
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            DispatchQueue.main.async {
                print(place.description.description as Any)
                self.parent.address =  place.addressComponents!
                var street_num = ""
                var street_name = ""
                for addressComponent in (place.addressComponents)!{
                    for component in addressComponent.types {
                        switch(component){
                        case "street_number":
                            street_num = addressComponent.name
                            
                        case "route":
                            street_name = addressComponent.name
                            
                        case "locality":
                            self.parent.city_address = addressComponent.name
                            
                        case "administrative_area_level_1":
                            self.parent.state_address = addressComponent.shortName ?? "MI"
                            
                        case "postal_code":
                            self.parent.zipcode_address = addressComponent.name
                            
                        default:
                            break
                        }
                    }
                }
                self.parent.street_address = street_num + " " + street_name
                    
                
               

                self.parent.location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                self.parent.presentationMode.wrappedValue.dismiss()
                print("latitude: \(place.coordinate.latitude)")
                print("longitude: \(place.coordinate.longitude)")
            }
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            print("Error: ", error.localizedDescription)
        }

        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }

    }
}
