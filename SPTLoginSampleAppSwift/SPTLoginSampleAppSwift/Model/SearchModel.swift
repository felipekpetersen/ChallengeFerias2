//
//  SearchModel.swift
//  Synchs
//
//  Created by Felipe Petersen on 16/02/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let search = try? newJSONDecoder().decode(Search.self, from: jsonData)

import Foundation

// MARK: - Search
struct SearchResponse: Codable {
    var tracks, playlists: Playlists?
}

// MARK: - Playlists
struct Playlists: Codable {
    var href: String?
    var items: [MusicItem]?
    var limit: Int?
    var next: String?
    var offset: Int?
    var previous: String?
    var total: Int?
}

// MARK: - Item
//struct MusicItem: Codable {
//    var album: SearchAlbum?
//    var artists: [SearchArtist]?
//    var availableMarkets: [String]?
//    var discNumber, durationMS: Int?
//    var explicit: Bool?
//    var externalIDS: ExternalIDS?
//    var externalUrls: ExternalUrls?
//    var href: String?
//    var id: String?
//    var isLocal: Bool?
//    var name: String?
//    var popularity: Int?
//    var previewURL: String?
//    var trackNumber: Int?
//    var type: ItemType?
//    var uri: String?
//
//    enum CodingKeys: String, CodingKey {
//        case album, artists
//        case availableMarkets
//        case discNumber
//        case durationMS
//        case explicit
//        case externalIDS
//        case externalUrls
//        case href, id
//        case isLocal
//        case name, popularity
//        case previewURL
//        case trackNumber
//        case type, uri
//    }
//}

// MARK: - Album
struct SearchAlbum: Codable {
    var albumType: SearchAlbumTypeEnum?
    var artists: [SearchArtist]?
    var availableMarkets: [String]?
    var externalUrls: ExternalUrls?
    var href: String?
    var id: AlbumID?
    var images: [Image]?
    var name: AlbumName?
    var releaseDate: String?
    var releaseDatePrecision: ReleaseDatePrecision?
    var totalTracks: Int?
    var type: AlbumTypeEnum?
    var uri: AlbumURI?

    enum CodingKeys: String, CodingKey {
        case albumType
        case artists
        case availableMarkets
        case externalUrls
        case href, id, images, name
        case releaseDate
        case releaseDatePrecision
        case totalTracks
        case type, uri
    }
}

enum SearchAlbumTypeEnum: String, Codable {
    case album = "album"
}

// MARK: - Artist
struct SearchArtist: Codable {
    var externalUrls: ExternalUrls?
    var href: String?
    var id: ArtistID?
    var name: ArtistName?
    var type: SearchArtistType?
    var uri: ArtistURI?

    enum CodingKeys: String, CodingKey {
        case externalUrls
        case href, id, name, type, uri
    }
}

enum ArtistID: String, Codable {
    case the08Td7MxkoHQkXnWAYD8D6Q = "08td7MxkoHQkXnWAYD8d6Q"
    case the0AXuMYPvjBGthmsiknR0DY = "0aXuMYPvjBGthmsiknR0DY"
}

enum ArtistName: String, Codable {
    case andyGordon = "Andy Gordon"
    case taniaBowra = "Tania Bowra"
}

enum SearchArtistType: String, Codable {
    case artist = "artist"
}

enum ArtistURI: String, Codable {
    case spotifyArtist08Td7MxkoHQkXnWAYD8D6Q = "spotify:artist:08td7MxkoHQkXnWAYD8d6Q"
    case spotifyArtist0AXuMYPvjBGthmsiknR0DY = "spotify:artist:0aXuMYPvjBGthmsiknR0DY"
}

enum AlbumID: String, Codable {
    case the1FrhRifX9S3SjpkoYG9N81 = "1FrhRifX9s3sjpkoYG9N81"
    case the6AkEvsycLGftJxYudPjmqK = "6akEvsycLGftJxYudPjmqK"
}

enum AlbumName: String, Codable {
    case placeInTheSun = "Place In The Sun"
    case theReverentJorfyLive = "The Reverent Jorfy (Live)"
}

enum AlbumURI: String, Codable {
    case spotifyAlbum1FrhRifX9S3SjpkoYG9N81 = "spotify:album:1FrhRifX9s3sjpkoYG9N81"
    case spotifyAlbum6AkEvsycLGftJxYudPjmqK = "spotify:album:6akEvsycLGftJxYudPjmqK"
}

// MARK: - ExternalIDS
//struct ExternalIDS: Codable {
//    var isrc: String?
//}
//
//enum ItemType: String, Codable {
//    case track = "track"
//}

