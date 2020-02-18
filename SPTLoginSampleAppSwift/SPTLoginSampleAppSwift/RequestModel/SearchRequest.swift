//
//  SearchRequest.swift
//  Synchs
//
//  Created by Felipe Petersen on 16/02/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation
import Alamofire

enum SearchRouter: RouterProtocol {
    case getSearch
    
    var path: String {
        switch self {
        case .getSearch: return GET_SEARCH
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getSearch: return .get
        
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
