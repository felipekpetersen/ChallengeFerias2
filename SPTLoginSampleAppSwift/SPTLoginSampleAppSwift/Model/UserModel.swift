//
//  UserModel.swift
//  Synchs
//
//  Created by Felipe Petersen on 10/02/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation

struct UserModel: Decodable {
    
}

struct RefreshResponse : Decodable {
    let access_token : String?
    let token_type : String?
    let expires_in : Int?
    let scope : String?
}


// MARK: - UserResponse
struct UserResponse: Decodable {
    let country, display_name, email: String?
    let external_urls: ExternalUrlsResponse?
    let followers: FollowersResponse?
    let href: String?
    let id: String?
    let images: [ImageResponse]?
    let product, type, uri: String?
}

// MARK: - ExternalUrls
struct ExternalUrlsResponse: Decodable {
    let spotify: String?
}

// MARK: - Followers
struct FollowersResponse: Decodable {
    let href: String?
    let total: Int?
}

// MARK: - Image
struct ImageResponse: Decodable {
    let height: Int?
    let url: String?
    let width: Int?
}
