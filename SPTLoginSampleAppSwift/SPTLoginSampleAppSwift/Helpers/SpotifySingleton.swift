//
//  SpotifySingleton.swift
//  SPTLoginSampleAppSwift
//
//  Created by Felipe Petersen on 26/01/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation

class SpotifySingleton: NSObject, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate  {
    
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
    
    @objc func didFailWith(error: Error) {
        returnError(error: error)
    }
    
    @objc func didEstablishConnection() {
        returnStablish()
    }
    
//    func setupResponses(error: Error?) {
//        self.addObserver()
//    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didFailWith(error:)), name: .didFailWith, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEstablishConnection), name: .didFailWith, object: nil)
    }
    
    //override it
    @objc func returnError(error: Error){}
    @objc func returnStablish(){}

    //MARK:- Delegate
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        <#code#>
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        self.didFailWith(error: error)
    }
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        self.didEstablishConnection()
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        <#code#>
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        <#code#>
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        <#code#>
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
}
