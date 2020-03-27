//
//  SearchModalViewModel.swift
//  Synchs
//
//  Created by Felipe Petersen on 17/02/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation
import Alamofire

class ShareModalViewModel {
    
    var playlistTrackResponse = PlaylistTracksResponse()
     
    var searchResult = SearchResponse()
    
    func getNumberOfRowsForSearch() -> Int {
        return searchResult.tracks?.items?.count ?? 0
    }
    
    func getSearchForRow(index: Int) -> MusicItem {
        return searchResult.tracks?.items?[index] ?? MusicItem()
    }
    
    
    func getPlaylist(forId: String, success: @escaping () -> (), erro: @escaping (Error) -> ()) {
        var params = Parameters()
        params = ["auth" : SpotifySingleton.shared().getAccessToken(), "playlist_id": forId]
        Network.shared.request(MusicRouter.getTracksPlaylist, parameters: params, model: PlaylistTracksResponse.self, encoding: URLEncoding.queryString) { result in
            
            switch result {
            case .sucess(let list):
                self.playlistTrackResponse = list
                success()
                break
            case .failure(let error): erro(error)
                break
            }
        }
    }
}
