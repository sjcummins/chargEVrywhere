//
//  swiftUIChatterApp.swift
//  swiftUIChatter
//
//  Created by Jacob Klionsky on 10/27/22.
//

import SwiftUI
import GoogleMaps
import GooglePlaces

@main
struct swiftUIChatterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
           ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GMSServices.provideAPIKey("YOUR_API_KEY")
        GMSPlacesClient.provideAPIKey("YOUR_API_KEY")
        return true
    }
}


