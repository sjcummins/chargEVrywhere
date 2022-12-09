//
//  API.swift
//  swiftUIChatter
//
//  Created by Allison Kwang on 11/8/22.
//
import Foundation
import Alamofire


final class API{
    static let shared = API()
    
    private init() {}                // and make the constructor private so no other
    // instances can be created
    
    //  ---------------getUser---------------------
    private(set) var user = User()
    private let nFields =  10
    private(set) var user2 = User2()
    //----------------------------------------------
    
    
    //  ---------------getAddCharger---------------------
    private(set) var chargerData = ChargerData()
    private let nFields_addCharger =  10
    //----------------------------------------------
    //  ---------------getLocalCharger---------------------
    private(set) var localCharger = [Int]()
    private let nFields_localCharger =  3
    //----------------------------------------------
    
    //  ---------------getVehicle---------------------
    private(set) var vehicle = Vehicle()
    private let nFields_vehicle =  3
    //----------------------------------------------
    //  ---------------getAVerageRating---------------------
    private(set) var averageRating = AverageRating()
    
    //----------------------------------------------
    
    
    //  ---------------postFunctions---------------------
    private(set) var localUser = LocalUser()
    private let nFields_localUser = 1
    //----------------------------------------------
    private(set) var reviewData = [DriverReview]()
    private(set) var HostreviewData = [HostReview]()
    
    
    private let serverUrl = "https://18.225.8.255/"
    
    
    
    @MainActor
    func getUser(id: Int) async -> User? {
        
        guard let apiUrl = URL(string: serverUrl+"getUser/?user_id=" + String(id)) else {
            print("getUser: Bad URL")
            return nil
        }
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("getUser: HTTP STATUS: \(httpStatus.statusCode)")
                print("getUser: Response \(response.description)")
                return nil
            }
            print("getUser: Response \(response.description)")
            print("getUser: Data \(data)")
            let temp_data = Data(data)
            let decoder = JSONDecoder()
            guard let jsonObj = try? decoder.decode(User.self, from: temp_data) else {
                print("getUser: failed JSON deserialization")
                return nil
            }
            
            
            self.user = User(
                user_id: id,
                first_name: jsonObj.first_name,
                last_name:jsonObj.last_name,
                year_of_birth: jsonObj.year_of_birth,
                month_of_birth: jsonObj.month_of_birth,
                day_of_birth: jsonObj.day_of_birth,
                username:jsonObj.username,
                password: jsonObj.password,
                charging_since: jsonObj.charging_since,
                description: jsonObj.description)
            
        } catch {
            print("getUser: NETWORKING ERROR")
            return nil
        } // catch
        return user
    }
    
    
    
    func getUser2(id: Int) async -> (User2?) {
        
        guard let apiUrl = URL(string: serverUrl+"getUser2/?user_id=" + String(id)) else {
            print("getUser2: Bad URL")
            return nil
        }
        
        
        
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("getUser2: HTTP STATUS: \(httpStatus.statusCode)")
                print("getUser2: Response \(response.description)")
                return nil
            }
            print("getUser2: Response \(response.description)")
            print("getUser2: Data \(data)")
            let temp_data = Data(data)
            print("getUser2: tempData \(temp_data)")
            let decoder = JSONDecoder()
            guard let jsonObj = try? decoder.decode(User2.self, from: temp_data) else {
                print("getUser: failed JSON deserialization")
                return nil
            }
            
            
            self.user2 = User2(
                user_id: id,
                first_name: jsonObj.first_name,
                last_name:jsonObj.last_name,
                year_of_birth: jsonObj.year_of_birth,
                month_of_birth: jsonObj.month_of_birth,
                day_of_birth: jsonObj.day_of_birth,
                username:jsonObj.username,
                password: jsonObj.password,
                charging_since: jsonObj.charging_since,
                description: jsonObj.description,
                img_url: jsonObj.img_url)
            
            if self.user2.img_url == nil {
                self.user2.img_url = ""
            }
        } catch {
            print("getUser2: NETWORKING ERROR")
            return nil
        } // catch
        return self.user2
           
    }
    
    
    
    func getChargerPhotos(cid: Int) async -> [PhotoURL]? {
        guard let apiUrl = URL(string: serverUrl+"getChargerPhotos/?cid=" + String(cid)) else {
            print("getChargerPhotos: Bad URL")
            return nil
        }

        var images = [PhotoURL]()


        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("getChargerPhotos: HTTP STATUS: \(httpStatus.statusCode)")
                print("getChargerPhotos: Response \(response.description)")
                return nil
            }
            print("getChargerPhotos: Response \(response.description)")
            print("getChargerPhotos: Data \(data)")
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("getPhotos: failed JSON deserialization")
                return nil
            }
            let imagesReceived = jsonObj["photos"] as? [String] ?? []

            for imageEntry in imagesReceived {
                images.append(
                    PhotoURL(img_url: imageEntry)
                )
            } //for
            
        } catch {
            print("getChargerPhotos: NETWORKING ERROR")
            return nil
        } // catch
        return images
    }
    
    
    
    
    //  -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -       -   -   -   -
    
    
    
    
    
    
    
    
    
    @MainActor
    func getLocalChargers(lat: Double, longitude: Double, radius: Double) async -> [Int]? {
        self.localCharger.removeAll()
        var urlSuffix = "latitude=" + String(lat) + "&longitude=" + String(longitude) + "&radius=" + String(radius)
        
        guard let apiUrl = URL(string: serverUrl+"getLocalChargers/?" + urlSuffix) else {
            print("getLocalCharger Bad URL")
            return nil
        }
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("getLocalChargers: HTTP STATUS: \(httpStatus.statusCode)")
                return nil
            }
            
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("getLocalChargers: failed JSON deserialization")
                return nil
            }
            self.localCharger = jsonObj["cid"] as? [Int] ?? []
            
            
        } catch {
            print("getLocalChargers: NETWORKING ERROR")
        }
        return self.localCharger
        
    }
    
    
    
    
    
    
    
    
    
    //  -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -       -   -   -   -
    
    
    
    
    
    
    
    
    
    @MainActor
    func getChargerWindow(cid: Int) async -> ChargerData? {
        
        
        
        guard let apiUrl = URL(string: serverUrl+"getChargerWindow/?cid=" + String(cid)) else {
            print("getChargerWindow: Bad URL")
            return nil
        }
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("getLogin: HTTP STATUS: \(httpStatus.statusCode)")
                print("getLogin: Response \(response.description)")
                return nil
            }
            print("getLogin: Response \(response.description)")
            print("getLogin: Data \(data)")
            let temp_data = Data(data)
            let decoder = JSONDecoder()
            guard let jsonObj = try? decoder.decode(ChargerData.self, from: temp_data) else {
                print("getChargerData: failed JSON deserialization")
                return nil
            }
            
            
            
            self.chargerData = ChargerData(
                user_id: jsonObj.user_id,
                cid: jsonObj.cid,
                available: jsonObj.available,
                start_time_availability: jsonObj.start_time_availability,
                end_time_availability: jsonObj.end_time_availability,
                charger_type: jsonObj.charger_type,
                price: jsonObj.price,
                street_address: jsonObj.street_address,
                city_address: jsonObj.city_address,
                state_address: jsonObj.state_address,
                zipcode_address: jsonObj.zipcode_address,
                latitude: jsonObj.latitude,
                longitude: jsonObj.longitude
                
            )
        } catch {
            print("getChargerWindow: NETWORKING ERROR")
            return nil
        } // catch
        return chargerData
    }
    
    
    
    
    
    //  -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -       -   -   -   -
    
    
    
    
    
    @MainActor
    func getChargerInfo(id: Int) async -> ChargerData? {
        
        guard let apiUrl = URL(string: serverUrl+"getChargerInfo/?user_id=" + String(id)) else {
            print("getUser: Bad URL")
            return nil
        }
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("getUser: HTTP STATUS: \(httpStatus.statusCode)")
                print("getUser: Response \(response.description)")
                return nil
            }
            print("getUser: Response \(response.description)")
            print("getUser: Data \(data)")
            let temp_data = Data(data)
            let decoder = JSONDecoder()
            guard let jsonObj = try? decoder.decode(ChargerData.self, from: temp_data) else {
                print("getUser: failed JSON deserialization")
                return nil
            }
            
            
            self.chargerData = ChargerData(
                user_id: id,
                cid: jsonObj.cid,
                available:jsonObj.available,
                start_time_availability: jsonObj.start_time_availability,
                end_time_availability: jsonObj.end_time_availability,
                charger_type: jsonObj.charger_type,
                price:jsonObj.price,
                street_address: jsonObj.street_address,
                city_address: jsonObj.city_address,
                state_address: jsonObj.state_address,
                zipcode_address: jsonObj.zipcode_address,
                latitude: jsonObj.latitude,
                longitude: jsonObj.longitude
            )
            
            
        } catch {
            print("getUser: NETWORKING ERROR")
            return nil
        } // catch
        return self.chargerData
    }
    
    
    
    
    
    
    
    
    
    
    //  -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -       -   -   -   -
    
    
    
    
    
    
    
    
    @MainActor
    func getVehicle(id: Int) async -> Vehicle? {
        
        guard let apiUrl = URL(string: serverUrl+"getVehicle/?user_id=" + String(id)) else {
            print("getVehicle: Bad URL")
            return nil
        }
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("getVehicle: HTTP STATUS: \(httpStatus.statusCode)")
                print("getVehicle: Response \(response.description)")
                return nil
            }
            print("getVehicle: Response \(response.description)")
            print("getVehicle: Data \(data)")
            let temp_data = Data(data)
            let decoder = JSONDecoder()
            guard let jsonObj = try? decoder.decode(Vehicle.self, from: temp_data) else {
                print("getVehicle: failed JSON deserialization")
                return nil
            }
            
            
            self.vehicle = Vehicle(
                user_id: id,
                lics_number: jsonObj.lics_number,
                model: jsonObj.model,
                color: jsonObj.color)
            
        } catch {
            print("getVehicle: NETWORKING ERROR")
            return nil
        } // catch
        return vehicle
    }
    
    
    
    
    
    
    
    //  -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -       -   -   -   -
    
    
    
    
    
    
    
    @MainActor
    func getLogin(username: String, password: String) async -> LocalUser? {
        
        guard let apiUrl = URL(string: serverUrl+"getLogin/?username=" + username + "&password=" + password) else {
            print("getLogin: Bad URL")
            return nil
        }
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("getLogin: HTTP STATUS: \(httpStatus.statusCode)")
                print("getLogin: Response \(response.description)")
                return nil
            }
            print("getLogin: Response \(response.description)")
            print("getLogin: Data \(data)")
            let temp_data = Data(data)
            let decoder = JSONDecoder()
            guard let jsonObj = try? decoder.decode(LocalUser.self, from: temp_data) else {
                print("getLogin: failed JSON deserialization")
                return nil
            }
            
            
            self.localUser = LocalUser(
                user_id: jsonObj.user_id)
            
        } catch {
            print("getLogin: NETWORKING ERROR")
            return nil
        } // catch
        return localUser
    }
    
    
    //  -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -       -   -   -   -
    func getPhotos() -> [String]? {
        guard let apiUrl = URL(string: serverUrl+"getimages/") else {
            print("getPhotos: bad URL")
            return nil
        }
        var images_received = [String]()
        AF.request(apiUrl, method: .get).responseData { response in
            guard let data = response.data, response.error == nil else {
                print("getPhotos: NETWORKING ERROR")
                return
            }
            if let httpStatus = response.response, httpStatus.statusCode != 200 {
                print("getPhotos: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
            
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("getPhotos: failed JSON deserialization")
                return
            }
            images_received = jsonObj["images"] as? [String] ?? []
            
            if images_received.count == 0{
                return
            }
        }
        if images_received.count == 0 {
            return nil
        }
        return images_received
    }
    
    
    //------------------------------------ POST FUNCTIONS---------------------------
    
    
    
    
    
    func postUser(_ user: User) async -> Int? {
        let jsonObj =  [
            "first_name": user.first_name,
            "last_name": user.last_name,
            "year_of_birth": String(user.year_of_birth),
            "month_of_birth": String(user.month_of_birth),
            "day_of_birth": String(user.day_of_birth),
            "username": user.username,
            "password": user.password,
            "charging_since": String(user.charging_since),
            "description": user.description
        ]
        
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
            print("postUser: jsonData serialization error")
            return nil
        }
        
        guard let apiUrl = URL(string: serverUrl+"postUser/") else {
            print("postUser: Bad URL")
            return nil
        }
        
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type") // request is in JSON
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        do {
            let (data , response) = try await URLSession.shared.data(for: request)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("postChatt: HTTP STATUS: \(httpStatus.statusCode)")
                print("postChatt: description \(response.description)")
                return nil
            }
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Int] else {
                print("postUser: failed JSON deserialization")
                return nil
            }
            
            print(jsonObj)
            self.localUser.user_id = jsonObj["user_id"]!
            print("UserID: \(self.localUser.user_id)")
            return self.localUser.user_id
            
            
        } catch {
            print("postUser: NETWORKING ERROR")
        }
        return nil
    }
    
    
    
    //  -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -       -   -   -   -

    
    
    
    
    func postUser2(_ user: User, image: UIImage?) async -> Int? {
        
        var changed = false
        guard let apiUrl = URL(string: serverUrl+"postUser2/") else {
            print("postChargerPhoto: Bad URL")
            return nil
        }
        
        AF.upload(multipartFormData: { mpFD in
            if let firstname = String(user.first_name).data(using: .utf8) {
                mpFD.append(firstname, withName: "first_name")
            }
            if let lastname = String(user.last_name).data(using: .utf8) {
                mpFD.append(lastname, withName: "last_name")
            }
            if let yob = String(user.year_of_birth).data(using: .utf8) {
                mpFD.append(yob, withName: "year_of_birth")
            }
            if let mob = String(user.month_of_birth).data(using: .utf8) {
                mpFD.append(mob, withName: "month_of_birth")
            }
            if let dob = String(user.day_of_birth).data(using: .utf8) {
                mpFD.append(dob, withName: "day_of_birth")
            }
            if let usernam = String(user.username).data(using: .utf8) {
                mpFD.append(usernam, withName: "username")
            }
            if let pass = String(user.password).data(using: .utf8) {
                mpFD.append(pass, withName: "password")
            }
            if let since = String(user.charging_since).data(using: .utf8) {
                mpFD.append(since, withName: "charging_since")
            }
            if let descript = String(user.description).data(using: .utf8) {
                mpFD.append(descript, withName: "description")
            }
            if let jpegImage = image?.jpegData(compressionQuality: 1.0) {
                mpFD.append(jpegImage, withName: "img_url", fileName: "img_url", mimeType: "image/jpeg")
            }
        }, to: apiUrl, method: .post).response { response in
            switch (response.result) {
            case .success:
                print("postUser2: user posted!")
                changed = true
                guard let data = response.data, response.error == nil else {
                    print("postUser2: NETWORKING ERROR")
                    return
                } // guard let
                if let httpStatus = response.response, httpStatus.statusCode != 200 {
                    print("postUser2: HTTP STATUS: \(httpStatus.statusCode)")
                    return
                } // if
                
                 guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Int] else {
                     print("postUser2: failed JSON deserialization")
                     return
                 }
                     print(jsonObj)
                     self.localUser.user_id = jsonObj["user_id"]!
                     print("UserID: \(self.localUser.user_id)")
                
            case .failure:
                changed = true
                print("postUser2: posting failed")
            } //switch
            
        }//response in
        while changed != true {
            sleep(1)
        }
        return self.localUser.user_id
    }
    
    
    
    
    
    
    
    //  -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -       -   -   -   -
    
    
    
    
    
    
    func postCharger(_ charger: ChargerData) async -> Int? {
        let jsonObj =  [
            "user_id": String(charger.user_id),
            "available": "TRUE",
            "start_time_availability": String(charger.start_time_availability),
            "end_time_availability": String(charger.end_time_availability),
            "charger_type": charger.charger_type,
            "price": charger.price,
            "street_address": charger.street_address,
            "city_address":charger.city_address,
            "state_address": charger.state_address,
            "zipcode_address": charger.zipcode_address,
            "latitude": String(charger.latitude),
            "longitude": String(charger.longitude)
        ]
        
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
            print("postCharger: jsonData serialization error")
            return nil
        }
        
        guard let apiUrl = URL(string: serverUrl+"postCharger/") else {
            print("postCharger: Bad URL")
            return nil
        }
        
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type") // request is in JSON
        request.httpMethod = "POST"
        request.httpBody = jsonData
        print(jsonData)
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("postCharger: HTTP STATUS: \(httpStatus.statusCode)")
                print("postCharger: description \(response.description)")
                return nil
            }
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Int] else {
                print("postCharger: failed JSON deserialization")
                return nil
            }
            let cid = jsonObj["cid"]!
            print("Charger added CID: \(cid)")
            return cid
            
        } catch {
            print("postCharger: NETWORKING ERROR")
        }
        return nil
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //  -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -       -   -   -   -
    
    
    
    
    
    
    func postVehicle(_ v: Vehicle) async -> Int? {
        let jsonObj = [
            "user_id": String(v.user_id),
            "lics_number": v.lics_number,
            "model": v.model,
            "color": v.color
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
            print("postVehicle: jsonData serialization error")
            return nil
        }
        
        guard let apiUrl = URL(string: serverUrl+"postVehicle/") else {
            print("postVehicle: Bad URL")
            return nil
        }
        
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type") // request is in JSON
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        do {
            let (_ , response) = try await URLSession.shared.data(for: request)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("postVehicle: HTTP STATUS: \(httpStatus.statusCode)")
                print("postVehicle: description \(response.description)")
                return nil
            }
        } catch {
            print("postUser: NETWORKING ERROR")
        }
        return nil
    }
    
    
    
    
    
    
    
    
    
    
    
 
    
    
    
    
    
    
    
    
    
    //  -   -       -   --  -   --  -   -   -   -   -   -   -       --  -   --  -   -   -   -   -       -   -   -   -
    
    
    @MainActor
        func getAverageHost_DriverRating(id: Int, user_type: String) async -> String? {
            // user_type must be either HOST or DRIVER
            var urlSuffix = "receiving_review_type=" + user_type + "&user_id=" + String(id)
            guard let apiUrl = URL(string: serverUrl+"getAverageReview/?" + urlSuffix) else {
                print("getVehicle: Bad URL")
                return nil
            }
            var request = URLRequest(url: apiUrl)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
            request.httpMethod = "GET"
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("getVehicle: HTTP STATUS: \(httpStatus.statusCode)")
                    print("getVehicle: Response \(response.description)")
                    return nil
                }
                print("getVehicle: Response \(response.description)")
                print("getVehicle: Data \(data)")
                let temp_data = Data(data)
                let decoder = JSONDecoder()
                guard let jsonObj = try? decoder.decode(AverageRating.self, from: temp_data) else {
                    print("getVehicle: failed JSON deserialization")
                    return nil
                }
                
                
                self.averageRating = AverageRating(
                    avg_rating: jsonObj.avg_rating
                    )
                
            } catch {
                print("getVehicle: NETWORKING ERROR")
                return nil
            } // catch
            return self.averageRating.avg_rating
        }
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    private(set) var getRequesting = [Int]()
    private let nFields_getRequesting =  3
    
    @MainActor
    func getRequest(cid: Int) async -> [Int]? {
        
        guard let apiUrl = URL(string: serverUrl+"getRequest/?host_id=" + String(cid)) else {
            print("getRequest Bad URL")
            return nil
        }
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("getRequest: HTTP STATUS: \(httpStatus.statusCode)")
                return nil
            }
            
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("getRequest: failed JSON deserialization")
                return nil
            }
            self.getRequesting = jsonObj["driver_id"] as? [Int] ?? []
            
            
        } catch {
            print("getRequest: NETWORKING ERROR")
        }
        return self.getRequesting
        
    }
    
    
    
    
    
    private(set) var requested = Request()
    
    
    func postRequest(_ requested: Request) async -> Int? {
        let jsonObj =  [
            "user_id": requested.user_id,
            "cid": requested.charger_id,
            "host_id": requested.host_id,
        ]
        
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
            print("postRequest: jsonData serialization error")
            return nil
        }
        
        guard let apiUrl = URL(string: serverUrl+"postRequest/") else {
            print("postRequest: Bad URL")
            return nil
        }
        
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type") // request is in JSON
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        do {
            let (_ , response) = try await URLSession.shared.data(for: request)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("postRequest: HTTP STATUS: \(httpStatus.statusCode)")
                print("postRequest: description \(response.description)")
                return nil
            }
            
        } catch {
            print("postRequest: NETWORKING ERROR")
        }
        return nil
    }
    
    
    
    
    //updates the Charger's availability to false and deletes the requests with that host and charger
        func updateChargerAvailablity(_ chargerData: ChargerData) async  {
            let jsonObj =  [
                "cid": String(chargerData.cid),
                "user_id": String(chargerData.user_id)
            ]
            
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
                print("postUser: jsonData serialization error")
                return
            }
            
            guard let apiUrl = URL(string: serverUrl+"postChargerUpdate/") else {
                print("updateChargerAvailablity: Bad URL")
                return
            }
            
            var request = URLRequest(url: apiUrl)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type") // request is in JSON
            request.httpMethod = "POST"
            request.httpBody = jsonData
            
            do {
                let (_ , response) = try await URLSession.shared.data(for: request)
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("postChatt: HTTP STATUS: \(httpStatus.statusCode)")
                    print("postChatt: description \(response.description)")
                    return
                }
                
            } catch {
                print("postUser: NETWORKING ERROR")
            }
            
        }
        
        
        
        
        
        
        //updates the charger's availability to be true
        func updateChargerAvailablityToTrue(_ cid: Int) async  {
            let jsonObj =  [
                "cid": String(cid)
            ]
            
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
                print("postUser: jsonData serialization error")
                return
            }
            
            guard let apiUrl = URL(string: serverUrl+"postChargerAvailability/") else {
                print("updateChargerAvailablityToTrue: Bad URL")
                return
            }
            
            var request = URLRequest(url: apiUrl)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type") // request is in JSON
            request.httpMethod = "POST"
            request.httpBody = jsonData
            
            do {
                let (_ , response) = try await URLSession.shared.data(for: request)
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("postChatt: HTTP STATUS: \(httpStatus.statusCode)")
                    print("postChatt: description \(response.description)")
                    return
                }
                
            } catch {
                print("postUser: NETWORKING ERROR")
            }
            
        }
        
    
    
    // - - - - - - - - - - - -- - - - - - - - - - -  -- - - - - -
    func postChargerPhoto(_ user_id: Int, cid: Int, image: UIImage?) async {
        guard let apiUrl = URL(string: serverUrl+"postChargerPhoto/") else {
            print("postChargerPhoto: Bad URL")
            return
        }
        
        AF.upload(multipartFormData: { mpFD in
            if let userid = String(user_id).data(using: .utf8) {
                mpFD.append(userid, withName: "user_id")
            }
            if let c_id = String(cid).data(using: .utf8) {
                mpFD.append(c_id, withName: "cid")
            }
            if let jpegImage = image?.jpegData(compressionQuality: 1.0) {
                mpFD.append(jpegImage, withName: "image", fileName: "chargerImage", mimeType: "image/jpeg")
            }
        }, to: apiUrl, method: .post).response { response in
            switch (response.result) {
            case .success:
                print("postChargerPhoto: photo posted!")
            case .failure:
                print("postChargerPhoto: posting failed")
            }
        }
    }

    
    
    
    
    
    func getDriverReviews(_ id: Int) async -> [DriverReview]? {
              //let temp = String(serverUrl) + "getDriverReview/?" + String(id)
        self.reviewData.removeAll()
            guard let apiUrl = URL(string: serverUrl+"getDriverReview/?" + "driver_id="+String(id)) else {
                print("getDriverReview Bad URL")
                return nil
              }
              var request = URLRequest(url: apiUrl)
              request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
              request.httpMethod = "GET"
              
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                  print("getReviews: HTTP STATUS: \(httpStatus.statusCode)")
                  return nil
                }
                
                guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                  print("getDriverReviews: failed JSON deserialization")
                  return nil
                }
                
                //self.localCharger = jsonObj["reviews"] as? [Int] ?? []
                if jsonObj["reviews"] != nil {
                for anItem in jsonObj["reviews"] as! [Dictionary<String, Any>] {
                    var temp = DriverReview()
                    temp.first_name = anItem["first_name"] as! String
                    temp.last_name = anItem["last_name"] as! String
                    let e = anItem["stars"] as! String
                    temp.rating = Double(e) ?? 0
                    temp.message = anItem["message"] as! String
                    temp.date = anItem["review_date"] as! String
                    temp.subject = anItem["subject"] as! String
                    temp.user_id = anItem["driver_id"] as! Int
                    temp.img_url = anItem["img_url"] as! String
                    self.reviewData.append(temp)
                    }
                }
                else {
                    return self.reviewData
                }
              } catch {
                print("getChatts: NETWORKING ERROR")
              }
              
            return self.reviewData
            }
    
    
     func getHostReviews(_ id: Int) async -> [HostReview]? {
         self.HostreviewData.removeAll()
         //let temp = String(serverUrl) + "getHostReview/?" + String(id)
             guard let apiUrl = URL(string: serverUrl+"getHostReview/?" + "host_id="+String(id)) else {
                 print("getHostReview Bad URL")
                 return nil
               }
               var request = URLRequest(url: apiUrl)
               request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
               request.httpMethod = "GET"
               
             do {
                 let (data, response) = try await URLSession.shared.data(for: request)
                 
                 if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                   print("getReviews: HTTP STATUS: \(httpStatus.statusCode)")
                   return nil
                 }
                 
                 guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                   print("getHostReviews: failed JSON deserialization")
                   return nil
                 }
                

                 //self.localCharger = jsonObj["reviews"] as? [Int] ?? []
                 if jsonObj["reviews"] != nil { 
                     for anItem in jsonObj["reviews"] as! [Dictionary<String, Any>] {
                         print("anItem: \(anItem)")
                         var temp = HostReview()
                         temp.first_name = anItem["first_name"] as! String
                         temp.last_name = anItem["last_name"] as! String
                         let e = anItem["stars"] as! String
                         temp.rating = Double(e) ?? 0
                         temp.message = anItem["message"] as! String
                         temp.date = anItem["review_date"] as! String
                         temp.subject = anItem["subject"] as! String
                         temp.user_id = anItem["host_id"] as! Int
                         temp.img_url = anItem["img_url"] as! String
                         self.HostreviewData.append(temp)

                     }
                 }
               } catch {
                 print("getChatts: NETWORKING ERROR")
               }
               
             return self.HostreviewData
    }
     
    
   //type must be either "DRIVER" or "HOST"
    func postReview(_ d: DriverReview, type: String, host: HostReview) async ->Int? {
        
        
        var jsonObj = [
                "first_name": host.first_name,
                "last_name": host.last_name,
                "stars": String(host.rating),
                "message": host.message,
                "review_date": host.date,
                "subject": host.subject,
                "host_id": String(host.user_id),
                 "driver_id": String(host.driver_id),
                 "receiving_review_type": "HOST"
                
             ]
        
        if (type == "DRIVER") {
            jsonObj = [
                "first_name": d.first_name,
                "last_name": d.last_name,
                "stars": String(d.rating),
                "message": d.message,
                "review_date": d.date,
                "subject": d.subject,
                "driver_id": String(d.user_id),
                 "host_id": String(d.host_id),
                 "receiving_review_type": "DRIVER"
                
             ]
        }
         
         guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
             print("postDriverReview: jsonData serialization error")
             return nil
         }
         
         guard let apiUrl = URL(string: serverUrl+"postReview/") else {
             print("postDriverReview: Bad URL")
             return nil
         }
         
         var request = URLRequest(url: apiUrl)
         request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type") // request is in JSON
         request.httpMethod = "POST"
         request.httpBody = jsonData
         
         do {
             let (_ , response) = try await URLSession.shared.data(for: request)
             
             if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                 print("postReview: HTTP STATUS: \(httpStatus.statusCode)")
                 print("postReview: description \(response.description)")
                 return nil
             }
         } catch {
             print("postReview: NETWORKING ERROR")
         }
         return nil
     }
     
    
    private(set) var activity = [Activity]()
    @MainActor
    func getActivity(id: Int) async -> [Activity]? {
        
        guard let apiUrl = URL(string: serverUrl+"getActivities/?" + "user_id="+String(id)) else {
            print("getActivities Bad URL")
            return nil
          }
          var request = URLRequest(url: apiUrl)
          request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
          request.httpMethod = "GET"
          
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
              print("getActivities: HTTP STATUS: \(httpStatus.statusCode)")
              return nil
            }
            
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
              print("getActivities: failed JSON deserialization")
              return nil
            }
           
            //self.localCharger = jsonObj["reviews"] as? [Int] ?? []
            if jsonObj["activities"] != nil {
                for anItem in jsonObj["activities"] as! [Dictionary<String, Any>] {
                    var temp = Activity()
                    temp.host_id = anItem["host_id"] as! Int
                    temp.driver_id = anItem["driver_id"] as! Int
                    temp.duration = anItem["duration"] as! String
                    temp.cost = anItem["cost"] as! String
                    self.activity.append(temp)
                }
            }
            else {
                return self.activity
            }
          } catch {
            print("getActivities: NETWORKING ERROR")
          }
        return self.activity
    }
    
    
    private(set) var activity2 = Activity()
    
    
    func postActivity(_ activity2: Activity) async -> Int? {
        let jsonObj =  [
            "host_id": activity2.host_id,
            "driver_id": activity2.driver_id,
            "duration": activity2.duration,
            "cost": activity2.cost
        ] as [String : Any]
        
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
            print("postActivity: jsonData serialization error")
            return nil
        }
        
        guard let apiUrl = URL(string: serverUrl+"postActivity/") else {
            print("postActivity: Bad URL")
            return nil
        }
        
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type") // request is in JSON
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        do {
            let (_ , response) = try await URLSession.shared.data(for: request)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("postActivity: HTTP STATUS: \(httpStatus.statusCode)")
                print("postActivity: description \(response.description)")
                return nil
            }
            
        } catch {
            print("postActivity: NETWORKING ERROR")
        }
        return nil
    }
    
}

