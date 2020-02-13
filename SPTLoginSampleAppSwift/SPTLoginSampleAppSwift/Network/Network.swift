//
//  Network.swift
//  Core
//
//  Created by Jonas de Castro Leitão on 19/09/19.
//  Copyright © 2019 Itau. All rights reserved.
//swiftlint:disable line_length

import Alamofire

public enum NetworkError: Error {
    case badRequest
}

public enum RequestResult<Model> {
    case sucess (model: Model)
    case failure (error: NetworkError)
}

public class Network {
    
    public static let shared = Network()
    private init() {}
    
    public func request<D:Decodable>(_ router: RouterProtocol, parameters: Parameters? = nil, model: D.Type, encoding: ParameterEncoding = URLEncoding.default, completion: @escaping (RequestResult<D>) -> Void) {
        
        AF.request(router.url, method: router.method, parameters: parameters, encoding: encoding, headers: router.fullHeaders)
        .validate()
        .responseDecodable { (response: AFDataResponse<D>) in
            print(response.request)
            print(response.description)
            print(response.response)
            print(response.error?.errorDescription)
            if let value = response.value {
                completion(.sucess(model: value))
            } else {
                completion(.failure(error: .badRequest))
            }
        }
    }
}
