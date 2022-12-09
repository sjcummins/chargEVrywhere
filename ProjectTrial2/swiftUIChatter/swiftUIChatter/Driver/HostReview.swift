//
//  Review.swift
//  swiftUIChatter
//
//  Created by Allison Kwang on 11/6/22.
//

import Foundation

/*
 struct DriverReview: Identifiable {
     var id = UUID()
     var user_id: Int = -1
     var first_name: String = "bad"
     var last_name: String = "bad"
     var date: String = "bad"
     var subject: String = "bad"
     var message: String = "bad"
     var rating: Double = 0
 }
 */


struct HostReview:Identifiable {
    var id = UUID()
    var user_id: Int = -1
    var first_name: String = "bad"
    var last_name: String = "bad"
    var date: String = "bad"
    var subject: String = "bad"
    var message: String = "bad"
    var rating: Double = 0
    var driver_id: Int = -2
    var img_url: String = ""
}

struct HostAboutMe{
    var user_id: Int
    var first_name: String
    var last_name: String
    var average_rating: Double
    var charging_since: Int
    var description: String
    var street_address: String
    var city_address: String
    var state_address: String
    var zipcode_address: String
    var miles_away: Int
    var power_level: String
    var cost: String
    var latitude: Double
    var longitude: Double
    var charger_name: String
    var type: String
    var available: Bool
    var cid: Int
    var img_url: String
}
