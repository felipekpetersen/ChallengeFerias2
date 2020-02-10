//
//  SpotifySingleton.swift
//  SPTLoginSampleAppSwift
//
//  Created by Felipe Petersen on 26/01/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation

class SpotifySingleton: NSObject, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    
    
    static let SpotifyClientID = "9a41d6d229754090b8cd983dacfc89e7"
    static let SpotifyRedirectURI = URL(string: "syncs-login://callback")!
    
    var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURI
    )
    
    let tokenSwapURL = URL(string: "http://fepetersenspotify.herokuapp.com/api/token")
    let tokenRefreshURL = URL(string: "http://fepetersenspotify.herokuapp.com/api/refresh_token")
    
    lazy var sessionManager: SPTSessionManager = {
        self.configuration.tokenSwapURL = tokenSwapURL
        self.configuration.tokenRefreshURL = tokenRefreshURL
        self.configuration.playURI = ""
        let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
        manager.delegate = self
        return manager
    }()
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()

    fileprivate var lastPlayerState: SPTAppRemotePlayerState?

    private override init() {
    }

    private static let _shared = SpotifySingleton()
    
    class func shared() -> SpotifySingleton {
        return sharedSpotify
    }

    private static var sharedSpotify: SpotifySingleton = {
        let manager = SpotifySingleton()
        return manager
    }()
    
    //MARK:- Actions
    func connect(vc: UIViewController) {
        let scope: SPTScope = [.appRemoteControl, .playlistModifyPublic, .playlistReadCollaborative, .playlistReadPrivate, .playlistModifyPrivate, .userFollowRead]
        if #available(iOS 11, *) {
            self.sessionManager.initiateSession(with: scope, options: .default)
        } else {
            self.sessionManager.initiateSession(with: scope, options: .default, presenting: vc)
        }
    }
    
    func connectTapper(vc: UIViewController) {
        if self.appRemote.isConnected {
//            getAccessToken()
            print("AccessToken")
        } else {
            connect(vc: vc)
            print("Connect")
        }
    }
    
    //MARK:- Observers
    
    func observerDidEstablish(vc:UIViewController, function: Selector ) {
        NotificationCenter.default.addObserver(vc, selector: function, name: .didEstablish, object: nil)
    }
    
    func observerDidFail(vc:UIViewController, function: Selector ) {
        NotificationCenter.default.addObserver(vc, selector: function, name: .didFailWith, object: nil)
    }
    
    //MARK:- Player
    
    func getAccessToken() -> String {
        return appRemote.connectionParameters.accessToken ?? ""
    }
    
    func getRefreshToken() -> String {
        return UserDefaults.standard.string(forKey: "REFRESH") ?? ""
    }
    
    func playerIsPaused() -> Bool {
        return lastPlayerState?.isPaused ?? true
    }
    
    func fetchArtwork(for track:SPTAppRemoteTrack) -> UIImage {
        var receivedImage = UIImage()
         appRemote.imageAPI?.fetchImage(forItem: track, with: CGSize.zero, callback: { [weak self] (image, error) in
             if let error = error {
                 print("Error fetching track image: " + error.localizedDescription)
             } else if let image = image as? UIImage {
                receivedImage = image
             }
         })
        return receivedImage
     }
    
    func getMusic() {
//        self.lastPlayerState?.track.artist.name
    }
    
    
    //MARK:- Delegate
    
        func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
            NotificationCenter.default.post(name: .didEstablish, object: nil)
        }
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("conectou nessa budega")
        appRemote.connectionParameters.accessToken = session.accessToken
        UserDefaults.standard.set(session.refreshToken, forKey: "REFRESH")
        appRemote.connect()
        
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        NotificationCenter.default.post(name: .didFailWith, object: nil)
    }
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        NotificationCenter.default.post(name: .didEstablish, object: nil)
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        lastPlayerState = nil
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        lastPlayerState = nil
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("mudar")
    }
    
}

extension Notification.Name {
    static var didFailWith: Notification.Name {
        return .init(rawValue: "SpotifySingleton.didFailWith")
    }

    static var playbackStarted: Notification.Name {
        return .init(rawValue: "SpotifySingleton.playbackStarted")
    }

    static var playbackPaused: Notification.Name {
        return .init(rawValue: "SpotifySingleton.playbackPaused")
    }

    static var playbackStopped: Notification.Name {
        return .init(rawValue: "SpotifySingleton.playbackStopped")
    }
    
    static var didEstablish: Notification.Name {
        return .init(rawValue: "SpotifySingleton.didEstablish")
    }
}

//extension UIViewController {
//    func addObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(SpotifySingleton.shared().didFailWith(error:)), name: .didFailWith, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(SpotifySingleton.shared().didEstablishConnection), name: .didFailWith, object: nil)
//    }
//
//    //override it
//    @objc func returnError(error: Error){}
//    @objc func returnStablish(){}
//
//}
