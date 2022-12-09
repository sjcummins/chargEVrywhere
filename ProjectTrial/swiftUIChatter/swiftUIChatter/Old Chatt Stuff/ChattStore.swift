//
//  ChattStore.swift
//  swiftChatter
//
//  Created by Jason Obrycki on 9/14/22.
//

import Foundation

final class ChattStore: ObservableObject  {
    static let shared = ChattStore() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
                                     // instances can be created
    @Published private(set) var chatts = [Chatt]()
    private let nFields = Mirror(reflecting: Chatt()).children.count

    private let serverUrl = "https://18.224.21.181/"
    
    
    func postauth(_ chatt: Chatt) async {
        let jsonObj = ["username": chatt.username,
                       "message": chatt.message]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
            print("postChatt: jsonData serialization error")
            return
        }
                
        guard let apiUrl = URL(string: serverUrl+"postchatt/") else {
            print("postChatt: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type") // request is in JSON
        request.httpMethod = "POST"
        request.httpBody = jsonData

            do {
                       let (_, response) = try await URLSession.shared.data(for: request)

                       if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                           print("postChatt: HTTP STATUS: \(httpStatus.statusCode)")
                           return
                       } else {
                           await getChatts()
                       }
                   } catch {
                       print("postChatt: NETWORKING ERROR")
                   }
    }
    
    
    func getChatts() async {
        guard let apiUrl = URL(string: serverUrl+"getchatts/") else {
            print("getChatts: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
        request.httpMethod = "GET"

            do {
            let (data, response) = try await URLSession.shared.data(for: request)
                
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("getChatts: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
                
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("getChatts: failed JSON deserialization")
                return
            }
            let chattsReceived = jsonObj["chatts"] as? [[String?]] ?? []
            
            self.chatts = [Chatt]()
            for chattEntry in chattsReceived {
                if chattEntry.count == self.nFields {
                    self.chatts.append(Chatt(username: chattEntry[0],
                                             message: chattEntry[1],
                                             timestamp: chattEntry[2]))
                } else {
                    print("getChatts: Received unexpected number of fields: \(chattEntry.count) instead of \(self.nFields).")
                }
            }
        } catch {
            print("getChatts: NETWORKING ERROR")
        }
            
    }
    
   func addUser(_ idToken: String?) async {
            guard let idToken = idToken else {
                return
            }
            
            let jsonObj = ["clientID": "189457896029-revlf5c0evj80pka8h9aapidb4cvfpd0.apps.googleusercontent.com",
                        "idToken" : idToken]

            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
                print("addUser: jsonData serialization error")
                return
            }

            guard let apiUrl = URL(string: serverUrl+"adduser/") else {
                print("addUser: Bad URL")
                return
            }
            
            var request = URLRequest(url: apiUrl)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
            request.httpMethod = "POST"
            request.httpBody = jsonData
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("addUser: HTTP STATUS: \(httpStatus.statusCode)")
                    return
                }

                // will save() chatterID later
            } catch {
                print("addUser: NETWORKING ERROR")
            }
        }
}
