//
//  DataStructures.swift
//  swiftUIChatter
//
//  Created by Allison Kwang on 11/8/22.
//

import Foundation
import CoreLocation


struct User: Decodable {
    var user_id: Int = 0
    var first_name: String = "a"
    var last_name: String = "a"
    var year_of_birth: Int = 1
    var month_of_birth: Int = 1
    var day_of_birth: Int = 1
    var username: String = "a"
    var password: String = "a"
    var charging_since: Int = 1
    var description: String = "a"
}
struct User2: Decodable {
    var user_id: Int = 0
    var first_name: String = "a"
    var last_name: String = "a"
    var year_of_birth: Int = 1
    var month_of_birth: Int = 1
    var day_of_birth: Int = 1
    var username: String = "a"
    var password: String = "a"
    var charging_since: Int = 1
    var description: String = "a"
    var img_url: String? = "a"
}


struct LocalCharger: Decodable {
    var cid: Int = 1
}

struct ChargerData: Decodable, Hashable {
    var user_id: Int = 0
    var cid: Int = 1
    var available:  String = "a"//string from api, must convert
    var start_time_availability: String = "a"
    var end_time_availability: String = "a"
    var charger_type: String = "a"
    var price: String = "a"
    var street_address: String = "a"
    var city_address: String = "a"
    var state_address: String = "a"
    var zipcode_address: String = "a"
    var latitude: String = "a"
    var longitude: String = "a"
}

struct Review: Decodable {
    var review_id: Int = 0
    var review_date: String = "a"
    var stars: String = "a"
    var subject: String = "a"
    var message: String = "a"
    var receiving_review_type: String = "a"
    var host_id: Int = 1
    var driver_id: Int = 1
    var img_url: String? = "a"

}


struct Vehicle: Decodable {
    var user_id: Int = 0
    var lics_number: String = "a"
    var model: String = "a"
    var color: String = "a"
    
}

struct Request: Identifiable {
    var id = UUID()
    var user_id: Int = 0
    var host_id: Int = -1
    var charger_id: Int = 0
    var requested: String = "FALSE"
}

struct LocalUser : Decodable {
    var user_id: Int = 0
}






struct AverageRating : Decodable {
    var avg_rating: String = "0"
}


struct Activity: Identifiable {
    var id = UUID()
    var host_id: Int = 0
    var driver_id: Int = 0
    var duration: String = "a"
    var cost: String = "a"
}
