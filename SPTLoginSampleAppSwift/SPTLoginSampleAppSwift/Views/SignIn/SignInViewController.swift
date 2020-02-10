//
//  SignInViewController.swift
//  SPTLoginSampleAppSwift
//
//  Created by Felipe Petersen on 25/01/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var connectView: RoundedView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewTaps()
    }
    
    func setupViewTaps() {
        self.connectView.backgroundColor = UIColor(red:(29.0 / 255.0), green:(185.0 / 255.0), blue:(84.0 / 255.0), alpha:1.0)

        let connectTap = UITapGestureRecognizer(target: self, action: #selector(didTapConnect(_:)))
        self.connectView.addGestureRecognizer(connectTap)
        SpotifySingleton.shared().observerDidEstablish(vc: self, function: #selector(didStablish))
        SpotifySingleton.shared().observerDidFail(vc: self, function: #selector(didFail))
    }

    // MARK: - Actions

//    @objc func didTapPauseOrPlay(_ button: UIButton) {
//        if let lastPlayerState = lastPlayerState, lastPlayerState.isPaused {
//            appRemote.playerAPI?.resume(nil)
//        } else {
//            appRemote.playerAPI?.pause(nil)
//        }
//    }
//
//    @objc func didTapNext(_ button: UIButton) {
//        appRemote.playerAPI?.skip(toNext: .none)
//    }
//
//    @objc func didTapDisconnect(_ button: UIButton) {
//        if (appRemote.isConnected) {
//            appRemote.disconnect()
//        }
//    }

    @objc func didTapConnect(_ button: UIButton) {
        /*
         Scopes let you specify exactly what types of data your application wants to
         access, and the set of scopes you pass in your call determines what access
         permissions the user is asked to grant.
         For more information, see https://developer.spotify.com/web-api/using-scopes/.
         */
        SpotifySingleton.shared().connectTapper(vc: self)
        self.showLoader()
//            sessionManager,
        
    }
    
    @objc func didStablish() {
        self.hideLoader()
        print(SpotifySingleton.shared().getAccessToken())
        print(SpotifySingleton.shared().getRefreshToken())
        enterApp()
    }
    
    @objc func didFail() {
        self.hideLoader()
        self.showErrorAlert(message: "Tente novamente")
    }
    
    func enterApp() {
        DispatchQueue.main.async {
            let nav1 = UINavigationController()
            nav1.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Mattilda", size: 28)!]
            nav1.navigationBar.barTintColor = UIColor(red: 41.0 / 255.0, green: 41.0 / 255.0, blue: 41.0 / 255.0, alpha: 1.0)
            nav1.navigationBar.tintColor = .white
            let mainView = HomeViewController(nibName: nil, bundle: nil) //ViewController = Name of your controller
            nav1.viewControllers = [mainView]
            UIApplication.shared.keyWindow?.rootViewController = nav1
        }
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
