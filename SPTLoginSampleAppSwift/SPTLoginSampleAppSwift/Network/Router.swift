//
//  Router.swift
//  Core
//
//  Created by Jonas de Castro Leitão on 19/09/19.
//  Copyright © 2019 Itau. All rights reserved.
//

import Alamofire

public enum RouterUrl: String {
    case hub  = "http://fepetersenspotify.herokuapp.com"
    case local = "http://localhost:3000"
}

public protocol RouterProtocol {
        
    var path: String { get }
    
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
}

extension RouterProtocol {
    
    var url: String {
        return "http://fepetersenspotify.herokuapp.com" + self.path
    }
    
    var headers: [String: String]? {
        return nil
    }
   
    var fullHeaders: HTTPHeaders {
        
        var configurations = [
            "Accept-Encoding": "gzip",
            "Content-Type": "application/json"
        ]
        
        configurations.merge(self.headers ?? [:]) { current, new -> String in new }
        
        return HTTPHeaders(configurations)
    }
}
