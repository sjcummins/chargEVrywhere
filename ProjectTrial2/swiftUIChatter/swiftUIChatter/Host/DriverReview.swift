//
//  Review.swift
//  swiftUIChatter
//
//  Created by Allison Kwang on 11/5/22.
//

import Foundation

struct DriverReview: Identifiable {
    var id = UUID()
    var user_id: Int = -1
    var first_name: String = "bad"
    var last_name: String = "bad"
    var date: String = "bad"
    var subject: String = "bad"
    var message: String = "bad"
    var rating: Double = 0
    var host_id: Int = -2
    var img_url: String = "bad"
}
struct DriverAboutMe{
    var user_id: Int
    var first_name: String
    var last_name: String
    var average_rating: Double
    var charging_since: Int
    var description: String
    var vehicle_model: String
    var vehicle_color: String
    var vehicle_platenum: String
    var img_url: String
}

struct DriverPreview{
    var user_id: Int
    var first_name: String
    var last_name: String
    var requested_charger: String
    var distance: String
}

struct PhotoURL: Identifiable {
    var id = UUID()
    var img_url: String
}
