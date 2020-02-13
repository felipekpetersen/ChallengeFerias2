//
//  UserRequest.swift
//  Synchs
//
//  Created by Felipe Petersen on 10/02/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation
import Alamofire

enum UserRouter: RouterProtocol {
    case refreshToken
    case me
    
    var path: String {
        switch self {
        case .refreshToken: return POST_REFRESH
        case .me: return GET_ME
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .refreshToken: return .post
        case .me: return .get
        }
    }
    
    var headers: [String : String]? {
//        switch self {
//        case .refreshToken: return ["refresh_token" : SpotifySingleton.shared().getRefreshToken()]
//        case .me: return ["auth" : SpotifySingleton.shared().getAccessToken()]
//        }
        return nil
    }
}
