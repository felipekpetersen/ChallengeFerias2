//
//  RequestModel.swift
//  SPTLoginSampleAppSwift
//
//  Created by Felipe Petersen on 06/11/19.
//  Copyright © 2019 Spotify. All rights reserved.
//

import Foundation


class UserRequest {
    
    //SignUp Request
    func refreshToken( completion: @escaping ([String: Any]?, Error?) -> Void) {
        let group = DispatchGroup() // initialize the async
        group.enter()
        let parameters = ["refresh_token": UserDefaults.standard.string(forKey: "token")!]
        //create the url with NSURL
        let url = URL(string: "http://fepetersenspotify.herokuapp.com/api/refresh_token")!
        
        //create the session object
        let session = URLSession.shared
        
        //now create the Request object using the url object
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST" //set http method as POST
        do {
            
            request.httpBody = parameters.percentEscaped().data(using: .utf8) // pass dictionary to data object and set it as request body
        } catch let error {
            print(error.localizedDescription)
            completion(nil, error)
        }
        
        //HTTP Headers
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Acadresst")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard data != nil else {
                completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }
            
            do {
                
                print(data)
                if let file = data {
                    let json = try JSONSerialization.jsonObject(with: file, options: []) as! [String:Any]
                    print(json)
                    completion(json, nil)
                    group.leave()
//                    for (key, value) in json {
//                        if (key == "token_type"){
//                            if(value as? Int == 0){
//                                completion(nil, nil)
//                                group.leave()
//                            } else {
//                                completion(json, nil)
//                                group.leave()
//                            }
//                        } else {
//                            completion(nil, nil)
//                        }
//                    }
                    
                } else {
                    group.leave()
                    print("no file")
                    
                }
                
            } catch {
                group.leave()
                print(error.localizedDescription)
                
            }
        })
        
        task.resume()
        
    }
}
