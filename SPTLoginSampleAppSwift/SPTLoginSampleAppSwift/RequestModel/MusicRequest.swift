//
//  MusicRequest.swift
//  Synchs
//
//  Created by Felipe Petersen on 11/02/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation
import Alamofire

enum MusicRouter: RouterProtocol {
    case getUserPlaylists
    case getRecentlyPlayed
    case getTopTracks
    case putPlay
    case getTracksPlaylist
    
    var path: String {
        switch self {
        case .getUserPlaylists: return GET_PLAYLISTS
        case .getRecentlyPlayed: return GET_RECENTLY_PLAYED
        case .getTopTracks: return GET_TOP_TRACKS
        case .putPlay: return PUT_PLAY
        case .getTracksPlaylist: return GET_PLAYLIST_TRACKS
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUserPlaylists, .getRecentlyPlayed, .getTopTracks, .getTracksPlaylist: return .get
        case .putPlay: return .put
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
