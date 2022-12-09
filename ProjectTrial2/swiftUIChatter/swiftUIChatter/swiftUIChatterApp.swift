//
//  swiftUIChatterApp.swift
//  swiftUIChatter
//
//  Created by Jacob Klionsky on 11/3/22.
//

import SwiftUI
import GoogleMaps
import GooglePlaces

let API_KEY = "YOUR_API_KEY"

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
        GMSServices.provideAPIKey(API_KEY)
        GMSPlacesClient.provideAPIKey(API_KEY)
        return true
    }
}
