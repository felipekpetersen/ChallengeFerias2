import UIKit

class ViewController: UIViewController, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {

//    fileprivate let SpotifyClientID = "9a41d6d229754090b8cd983dacfc89e7"
//    fileprivate let SpotifyRedirectURI = URL(string: "spotify-login-sdk-test-app://spotify-login-callback")!
    static let SpotifyClientID = "9a41d6d229754090b8cd983dacfc89e7"
    static let SpotifyRedirectURI = URL(string: "syncs-login://callback")!
    
    var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURI
    )
    
    lazy var sessionManager: SPTSessionManager = {
        if let tokenSwapURL = URL(string: "http://fepetersenspotify.herokuapp.com/api/token"),
           let tokenRefreshURL = URL(string: "http://fepetersenspotify.herokuapp.com/api/refresh_token") {
            self.configuration.tokenSwapURL = tokenSwapURL
            self.configuration.tokenRefreshURL = tokenRefreshURL
            self.configuration.playURI = ""
        } else {
            fatalError("Não rolou")
        }
        let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
        manager.delegate = self
        return manager
    }()
//    lazy var configuration: SPTConfiguration = {
//        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURL)
//        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect/
//        // otherwise another app switch will be required
//        configuration.playURI = ""
//
//        // Set these url's to your backend which contains the secret to exchange for an access token
//        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
//        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
//        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
//        return configuration
//    }()
//
//    lazy var sessionManager: SPTSessionManager = {
//        let manager = SPTSessionManager(configuration: configuration, delegate: self)
//        return manager
//    }()

    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()

    fileprivate var lastPlayerState: SPTAppRemotePlayerState?

    // MARK: - Subviews

    fileprivate lazy var connectLabel: UILabel = {
        let label = UILabel()
        label.text = "Connect your Spotify account"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    fileprivate lazy var connectButton = ConnectButton(title: "CONNECT")
    fileprivate lazy var disconnectButton = ConnectButton(title: "DISCONNECT")

    fileprivate lazy var pauseAndPlayButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapPauseOrPlay), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate lazy var nextButton: UIButton = {
         let button = UIButton()
         button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
         button.translatesAutoresizingMaskIntoConstraints = false
         return button
     }()


    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    fileprivate lazy var trackLabel: UILabel = {
        let trackLabel = UILabel()
        trackLabel.translatesAutoresizingMaskIntoConstraints = false
        trackLabel.textAlignment = .center
        return trackLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        view.addSubview(connectLabel)
        view.addSubview(connectButton)
        view.addSubview(disconnectButton)
        view.addSubview(imageView)
        view.addSubview(trackLabel)
        view.addSubview(pauseAndPlayButton)
        view.addSubview(nextButton)

        let constant: CGFloat = 16.0

        connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        connectButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        disconnectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        disconnectButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true

        connectLabel.centerXAnchor.constraint(equalTo: connectButton.centerXAnchor).isActive = true
        connectLabel.bottomAnchor.constraint(equalTo: connectButton.topAnchor, constant: -constant).isActive = true

        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        imageView.bottomAnchor.constraint(equalTo: trackLabel.topAnchor, constant: -constant).isActive = true

        trackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        trackLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: constant).isActive = true
        trackLabel.bottomAnchor.constraint(equalTo: connectLabel.topAnchor, constant: -constant).isActive = true

        pauseAndPlayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pauseAndPlayButton.topAnchor.constraint(equalTo: trackLabel.bottomAnchor, constant: constant).isActive = true
        pauseAndPlayButton.widthAnchor.constraint(equalToConstant: 50)
        pauseAndPlayButton.heightAnchor.constraint(equalToConstant: 50)
        pauseAndPlayButton.sizeToFit()
        
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 150).isActive = true
        nextButton.topAnchor.constraint(equalTo: trackLabel.bottomAnchor, constant: constant).isActive = true

        nextButton.widthAnchor.constraint(equalToConstant: 50)
        nextButton.heightAnchor.constraint(equalToConstant: 50)
        nextButton.setImage(UIImage(named: "right_arrow"), for: .normal)
        nextButton.sizeToFit()

        connectButton.sizeToFit()
        disconnectButton.sizeToFit()

        connectButton.addTarget(self, action: #selector(didTapConnect(_:)), for: .touchUpInside)
        disconnectButton.addTarget(self, action: #selector(didTapDisconnect(_:)), for: .touchUpInside)

        updateViewBasedOnConnected()
    }

    func update(playerState: SPTAppRemotePlayerState) {
        if lastPlayerState?.track.uri != playerState.track.uri {
            fetchArtwork(for: playerState.track)
        }
        lastPlayerState = playerState
        trackLabel.text = playerState.track.name
        if playerState.isPaused {
            pauseAndPlayButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            pauseAndPlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
    }

    func updateViewBasedOnConnected() {
        DispatchQueue.main.async {
            if (self.appRemote.isConnected) {
                self.connectButton.isHidden = true
                self.disconnectButton.isHidden = false
                self.connectLabel.isHidden = true
                self.imageView.isHidden = false
                self.trackLabel.isHidden = false
                self.pauseAndPlayButton.isHidden = false
                self.nextButton.isHidden = false
            } else {
                self.disconnectButton.isHidden = true
                self.connectButton.isHidden = false
                self.connectLabel.isHidden = false
                self.imageView.isHidden = true
                self.trackLabel.isHidden = true
                self.pauseAndPlayButton.isHidden = true
                self.nextButton.isHidden = true
            }
        }
    }

    func fetchArtwork(for track:SPTAppRemoteTrack) {
        appRemote.imageAPI?.fetchImage(forItem: track, with: CGSize.zero, callback: { [weak self] (image, error) in
            if let error = error {
                print("Error fetching track image: " + error.localizedDescription)
            } else if let image = image as? UIImage {
                self?.imageView.image = image
            }
        })
    }

    func fetchPlayerState() {
        appRemote.playerAPI?.getPlayerState({ [weak self] (playerState, error) in
            if let error = error {
                print("Error getting player state:" + error.localizedDescription)
            } else if let playerState = playerState as? SPTAppRemotePlayerState {
                self?.update(playerState: playerState)
            }
        })
    }

    // MARK: - Actions

    @objc func didTapPauseOrPlay(_ button: UIButton) {
        if let lastPlayerState = lastPlayerState, lastPlayerState.isPaused {
            appRemote.playerAPI?.resume(nil)
        } else {
            appRemote.playerAPI?.pause(nil)
        }
    }
    
    @objc func didTapNext(_ button: UIButton) {
        appRemote.playerAPI?.skip(toNext: .none)
    }

    @objc func didTapDisconnect(_ button: UIButton) {
        if (appRemote.isConnected) {
            appRemote.disconnect()
        }
    }

    @objc func didTapConnect(_ button: UIButton) {
        /*
         Scopes let you specify exactly what types of data your application wants to
         access, and the set of scopes you pass in your call determines what access
         permissions the user is asked to grant.
         For more information, see https://developer.spotify.com/web-api/using-scopes/.
         */
        if self.appRemote.isConnected {
            getAccessToken()
            print("AccessToken")
        } else {
            connect()
            print("Connect")
        }
        
//            sessionManager,
        
    }
    
    func connect() {
        let scope: SPTScope = [.appRemoteControl, .playlistModifyPublic, .playlistReadCollaborative, .playlistReadPrivate, .playlistModifyPrivate, .userFollowRead]
        if #available(iOS 11, *) {
            self.sessionManager.initiateSession(with: scope, options: .default)
        } else {
            self.sessionManager.initiateSession(with: scope, options: .default, presenting: self)
        }
    }
    
    func getAccessToken() {
        UserRequest().refreshToken { (success, error) in
            if let accessToken = success?["access_token"] as? String {
                self.appRemote.connectionParameters.accessToken = accessToken
                self.appRemote.connect()
            } else {
                self.connect()
            }
        }
        updateViewBasedOnConnected()
    }


    // MARK: - SPTSessionManagerDelegate

    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        updateViewBasedOnConnected()
        presentAlertController(title: "Authorization Failed", message: error.localizedDescription, buttonTitle: "Bummer")
    }

    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        updateViewBasedOnConnected()
//        enterApp()
        presentAlertController(title: "Session Renewed", message: session.description, buttonTitle: "Sweet")
    }

    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
//        enterApp()
        print("conectou nessa budega")
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
    }
    
    func enterApp() {
        DispatchQueue.main.async {
            let nav1 = UINavigationController()
            nav1.navigationBar.barTintColor = UIColor(red: 41.0 / 255.0, green: 41.0 / 255.0, blue: 41.0 / 255.0, alpha: 1.0)
            nav1.navigationBar.tintColor = .white
            let mainView = HomeViewController(nibName: nil, bundle: nil) //ViewController = Name of your controller
            nav1.viewControllers = [mainView]
            UIApplication.shared.keyWindow?.rootViewController = nav1
        }
    }

    // MARK: - SPTAppRemoteDelegate

    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        updateViewBasedOnConnected()
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
            if let error = error {
                print("Error subscribing to player state:" + error.localizedDescription)
//            } else {
//                self.enterApp()
            }
        })
        enterApp()
        fetchPlayerState()
    }

    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        updateViewBasedOnConnected()
        lastPlayerState = nil
    }

    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        connect()
        updateViewBasedOnConnected()
        lastPlayerState = nil
    }

    // MARK: - SPTAppRemotePlayerAPIDelegate

    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        update(playerState: playerState)
    }

    // MARK: - Private Helpers

    fileprivate func presentAlertController(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        controller.addAction(action)
            self.present(controller, animated: true)
        }
        
    }
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
