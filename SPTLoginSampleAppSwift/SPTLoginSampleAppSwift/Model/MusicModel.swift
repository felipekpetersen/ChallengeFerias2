//
//  MusicModel.swift
//  Synchs
//
//  Created by Felipe Petersen on 11/02/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation

// MARK: - PlaylistTracksResponse
struct PlaylistTracksResponse: Codable {
    var href: String?
    var items: [PlaylistTracksItem]?
    var limit: Int?
    var next: String?
    var offset: Int?
    var previous: String?
    var total: Int?
}

// MARK: - Item
struct PlaylistTracksItem: Codable {
    var addedAt: Date?
    var addedBy: PlaylistTracksAddedBy?
    var isLocal: Bool?
    var track: MusicItem?

    enum CodingKeys: String, CodingKey {
        case addedAt
        case addedBy
        case isLocal
        case track
    }
}

// MARK: - AddedBy
struct PlaylistTracksAddedBy: Codable {
    var externalUrls: ExternalUrls?
    var href: String?
    var id, type, uri, name: String?

    enum CodingKeys: String, CodingKey {
        case externalUrls
        case href, id, type, uri, name
    }
}

// MARK: - ExternalUrls
//struct ExternalUrls: Codable {
//    var spotify: String?
//}

// MARK: - Track
//struct MusicItem: Codable {
//    var album: PlaylistTracksAlbum?
//    var artists: [PlaylistTracksAddedBy]?
//    var availableMarkets: [String]?
//    var discNumber, durationMS: Int?
//    var explicit: Bool?
//    var externalIDS: PlaylistTracksExternalIDS?
//    var externalUrls: ExternalUrls?
//    var href: String?
//    var id, name: String?
//    var popularity: Int?
//    var previewURL: String?
//    var trackNumber: Int?
//    var type, uri: String?
//
//    enum CodingKeys: String, CodingKey {
//        case album, artists
//        case availableMarkets
//        case discNumber
//        case durationMS
//        case explicit
//        case externalIDS
//        case externalUrls
//        case href, id, name, popularity
//        case previewURL
//        case trackNumber
//        case type, uri
//    }
//}

// MARK: - Album
struct PlaylistTracksAlbum: Codable {
    var albumType: String?
    var artists: [PlaylistTracksAddedBy]?
    var availableMarkets: [String]?
    var externalUrls: ExternalUrls?
    var href: String?
    var id: String?
    var images: [Image]?
    var name, type, uri: String?

    enum CodingKeys: String, CodingKey {
        case albumType
        case artists
        case availableMarkets
        case externalUrls
        case href, id, images, name, type, uri
    }
}

// MARK: - Image
//struct Image: Codable {
//    var height: Int?
//    var url: String?
//    var width: Int?
//}

// MARK: - ExternalIDS
struct PlaylistTracksExternalIDS: Codable {
    var isrc: String?
}


// MARK: - PlaylistResponse
struct PlaylistResponse: Codable {
    var href: String?
    var items: [MusicItem]?
    var limit: Int?
    var next: String?
    var offset: Int?
    var previous: String?
    var total: Int?
}
//
//// MARK: - Item
//struct MusicItem: Codable {
//    var collaborative: Bool?
//    var item_description: String?
//    var external_urls: ExternalUrls?
//    var href: String?
//    var id: String?
//    var images: [Image]?
//    var name: String?
//    var owner: Owner?
//    var primary_color: JSONNull?
//    var item_public: Bool?
//    var snapshotID: String?
//    var tracks: Tracks?
//    var type: ItemType?
//    var uri: String?
//
//    enum CodingKeys: String, CodingKey {
//        case collaborative
//        case item_description
//        case external_urls
//        case href, id, images, name, owner
//        case primary_color
//        case item_public
//        case snapshotID
//        case tracks, type, uri
//    }
//}

// MARK: - ExternalUrls
struct ExternalUrls: Codable {
    var spotify: String?
}

// MARK: - Image
struct Image: Codable {
    var height: Int?
    var url: String?
    var width: Int?
}

// MARK: - Owner
struct Owner: Codable {
    var display_name: String?
    var external_urls: ExternalUrls?
    var href: String?
    var id: String?
    var type: OwnerType?
    var uri: String?

    enum CodingKeys: String, CodingKey {
        case display_name
        case external_urls
        case href, id, type, uri
    }
}

enum OwnerType: String, Codable {
    case user = "user"
}

// MARK: - Tracks
struct Tracks: Codable {
    var href: String?
    var total: Int?
}

enum ItemType: String, Codable {
    case playlist = "playlist"
}

// MARK: - Toptracks
struct ToptracksResponse: Codable {
    var items: [MusicItem]?
    var total, limit, offset: Int?
    var href: String?
    var previous: String?
    var next: String?
}

// MARK: - Item
struct MusicItem: Codable {
    var album: TopAlbum?
    var artists: [TopArtist]?
    var availableMarkets: [String]?
    var images: [Image]?
    var discNumber, durationMS: Int?
    var explicit: Bool?
    var externalIDS: ExternalIDS?
    var externalUrls: TopExternalUrls?
    var href: String?
    var id: String?
    var isLocal: Bool?
    var name: String?
    var popularity: Int?
    var previewURL: String?
    var trackNumber: Int?
    var type: TopItemType?
    var uri: String?
    var collaborative: Bool?
    var owner: Owner?
//    var snapshotID: String?

    enum CodingKeys: String, CodingKey {
        case album, artists
        case availableMarkets
        case discNumber
        case durationMS
        case explicit
        case externalIDS
        case externalUrls
        case href, id
        case isLocal
        case name, popularity
        case previewURL
        case trackNumber
        case type, uri
        case images
        case owner
//        case colaborative
    }
}

// MARK: - Album
struct TopAlbum: Codable {
    var albumType: AlbumType?
    var artists: [Artist]?
    var availableMarkets: [String]?
    var externalUrls: ExternalUrls?
    var href: String?
    var id: String?
    var images: [TopImage]?
    var name, releaseDate: String?
    var releaseDatePrecision: ReleaseDatePrecision?
    var totalTracks: Int?
    var type: AlbumTypeEnum?
    var uri: String?

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

enum AlbumType: String, Codable {
    case album = "ALBUM"
    case single = "SINGLE"
}

// MARK: - Artist
struct TopArtist: Codable {
    var externalUrls: TopExternalUrls?
    var href: String?
    var id, name: String?
    var type: ArtistType?
    var uri: String?
    var genres: [String]?

    enum CodingKeys: String, CodingKey {
        case externalUrls
        case href, id, name, type, uri, genres
    }
}

// MARK: - ExternalUrls
struct TopExternalUrls: Codable {
    var spotify: String?
}

enum ArtistType: String, Codable {
    case artist = "artist"
}

// MARK: - Image
struct TopImage: Codable {
    var height: Int?
    var url: String?
    var width: Int?
}

enum ReleaseDatePrecision: String, Codable {
    case day = "day"
}

enum AlbumTypeEnum: String, Codable {
    case album = "album"
}

// MARK: - ExternalIDS
struct ExternalIDS: Codable {
    var isrc: String?
}

enum TopItemType: String, Codable {
    case track = "track"
    case playlist = "playlist"
}


//MARK:- End topTracks

// MARK: - RecentlyPlayed
struct RecentlyPlayed: Codable {
    var items: [TrackItem]?
    var next: String?
    var cursors: Cursors?
    var limit: Int?
    var href: String?
}

// MARK: - Cursors
struct Cursors: Codable {
    var after, before: String?
}

// MARK: - Item
struct TrackItem: Codable {
    var track: Track?
    var played_at: String?
    var context: Context?

    enum CodingKeys: String, CodingKey {
        case track
        case played_at
        case context
    }
}

// MARK: - Context
struct Context: Codable {
    var uri: String?
    var external_urls: ExternalUrls?
    var href: String?
    var type: String?

    enum CodingKeys: String, CodingKey {
        case uri
        case external_urls
        case href, type
    }
}

// MARK: - Track
struct Track: Codable {
    var artists: [Artist]?
    var available_markets: [String]?
    var disc_number, durationMS: Int?
    var explicit: Bool?
    var external_urls: ExternalUrls?
    var href: String?
    var id, name: String?
    var previewURL: String?
    var track_number: Int?
    var type, uri: String?

    enum CodingKeys: String, CodingKey {
        case artists
        case available_markets
        case disc_number
        case durationMS
        case explicit
        case external_urls
        case href, id, name
        case previewURL
        case track_number
        case type, uri
    }
}

// MARK: - Artist
struct Artist: Codable {
    var external_urls: ExternalUrls?
    var href: String?
    var id, name, type, uri: String?

    enum CodingKeys: String, CodingKey {
        case external_urls
        case href, id, name, type, uri
    }
}
// MARK: - End RecentlyPlayed

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
