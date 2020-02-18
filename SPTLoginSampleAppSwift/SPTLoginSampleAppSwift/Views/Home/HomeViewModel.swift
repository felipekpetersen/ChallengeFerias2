//
//  HomeViewModel.swift
//  Synchs
//
//  Created by Felipe Petersen on 02/02/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation
import Alamofire

enum HomeCellType {
    case music
    case playlist
}

class HomeViewModel {
    
//    var model: [MockModel]?
    var recentlyPlayed = RecentlyPlayed()
    var topResponse = ToptracksResponse()
    var playlistResponse = PlaylistResponse()
    
    func tryReconnect(success: @escaping () -> (), erro: @escaping (Error) -> ()) {
        var params = Parameters()
        params = ["refresh_token" : SpotifySingleton.shared().getRefreshToken()!]
        Network.shared.request(UserRouter.refreshToken, parameters: params, model: RefreshResponse.self, encoding: URLEncoding.queryString) { result in
            
            switch result {
                
            case .sucess(let list):
                SpotifySingleton.shared().setAcessToken(access: list.access_token)
                success()
                break
            case .failure(let error):
                SpotifySingleton.shared().cleanRefreshToken()
                erro(error)
                break
            }
        }
    }

    func getMe(success: @escaping () -> (), erro: @escaping (Error) -> ()) {
        var params = Parameters()
        params = ["auth" : SpotifySingleton.shared().getAccessToken()]
        Network.shared.request(UserRouter.me, parameters: params, model: UserResponse.self, encoding: URLEncoding.queryString) { result in
            
            switch result {
            case .sucess(let list):
                UserDefaults.standard.set(list.display_name, forKey: USER_NAME)
                UserDefaults.standard.set(list.images?[0].url, forKey: USER_IMAGE_URL)
                success()
                break
            case .failure(let error): erro(error)
                break
            }
        }
    }
    
    func getPlaylists(success: @escaping () -> (), erro: @escaping (Error) -> ()) {
        var params = Parameters()
        params = ["auth" : SpotifySingleton.shared().getAccessToken()]
        Network.shared.request(MusicRouter.getUserPlaylists, parameters: params, model: PlaylistResponse.self, encoding: URLEncoding.queryString) { result in
            
            switch result {
            case .sucess(let list):
                self.playlistResponse = list
                success()
                break
            case .failure(let error): erro(error)
                break
            }
        }
    }
    
    func getRecently(success: @escaping () -> (), erro: @escaping (Error) -> ()) {
        var params = Parameters()
        params = ["auth" : SpotifySingleton.shared().getAccessToken()]
        Network.shared.request(MusicRouter.getRecentlyPlayed, parameters: params, model: RecentlyPlayed.self, encoding: URLEncoding.queryString) { result in
            
            switch result {
            case .sucess(let list):
                self.recentlyPlayed = list
                success()
                break
            case .failure(let error): erro(error)
                break
            }
        }
    }
    
    func getTop(success: @escaping () -> (), erro: @escaping (Error) -> ()) {
        var params = Parameters()
        params = ["auth" : SpotifySingleton.shared().getAccessToken()]
        Network.shared.request(MusicRouter.getTopTracks, parameters: params, model: ToptracksResponse.self, encoding: URLEncoding.queryString) { result in
            
            switch result {
            case .sucess(let list):
                self.topResponse = list
                success()
                break
            case .failure(let error): erro(error)
                break
            }
        }
    }
    
    func play(content_uri: String, success: @escaping () -> (), erro: @escaping (Error) -> ()) {
        var params = Parameters()
        params = ["auth" : SpotifySingleton.shared().getAccessToken()]
        
        Network.shared.request(MusicRouter.putPlay, parameters: params, model: ToptracksResponse.self, encoding: URLEncoding.queryString) { result in
            
            switch result {
            case .sucess(let list):
//                self.topResponse = list
                success()
                break
            case .failure(let error): erro(error)
                break
            }
        }
    }
    
//    func getModel() {
//        self.model = MockModel().getModel()
//    }
//
    func getNumberOfRows() -> Int {
        return topResponse.items?.count ?? 0
    }

    func getMusicForRow(index: Int) -> MusicItem {
        return topResponse.items?[index] ?? MusicItem()
    }
    
//    func getCellTypeForRow(index: Int) -> HomeCellType {
//        return model?[index].type ?? .music
//    }
    
//    func getRecentlyPlayedNumberOfRows() -> Int {
//        return recentlyPlayed.items?.count ?? 0
//    }
    
    func getRecentlyPlayedTracks() -> [MusicItem] {
        return topResponse.items ?? [MusicItem]()
    }
    
    func getPlaylists() -> [MusicItem] {
        return playlistResponse.items ?? [MusicItem]()
    }
    
}
