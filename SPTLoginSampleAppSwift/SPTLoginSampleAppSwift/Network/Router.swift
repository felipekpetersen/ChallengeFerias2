//
//  Router.swift
//  Core
//
//  Created by Jonas de Castro Leitão on 19/09/19.
//  Copyright © 2019 Itau. All rights reserved.
//

import Alamofire

public enum RouterUrl: String {
    case hub  = "https://1c0f0c49-8521-4ca4-a68c-be57e5d91817.mock.pstmn.io"
    case local = "http://localhost:3000"
}

public protocol RouterProtocol {
        
    var path: String { get }
    
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
}

extension RouterProtocol {
    
    var url: String {
        return "https://1c0f0c49-8521-4ca4-a68c-be57e5d91817.mock.pstmn.io" + self.path
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
