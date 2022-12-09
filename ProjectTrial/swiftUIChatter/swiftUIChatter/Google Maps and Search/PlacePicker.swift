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
    @Binding var address: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<PlacePicker>) -> GMSAutocompleteViewController {

        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = context.coordinator
        

        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                  UInt(GMSPlaceField.placeID.rawValue))
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
                self.parent.address =  place.name!
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
