//
//  HomeViewController.swift
//  SPTLoginSampleAppSwift
//
//  Created by Felipe Petersen on 15/01/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var playerView: RoundedView!
    
    let MUSIC_CELL = "MusicTableViewCell"
    let PLAYLIST_CELL = "PlaylistTableViewCell"
    let SHARE_CELL = "ShareTableViewCell"
    static let numberOfCellsPlaylist = 10
    lazy var fixHeight: CGFloat = CGFloat(140 + HomeViewController.numberOfCellsPlaylist * 36)
    var openedRow: IndexPath?
    var viewModel = HomeViewModel()
    var selectedMusic: MusicItem?
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigation()
        setupShadowView()
        setupViewTaps()
//        self.viewModel.getModel()
        setupPlayer()
        self.tryReconnect()
    }
    
    func tryReconnect() {
        self.showLoader()
        viewModel.tryReconnect(success: {
            self.hideLoader()
            if let _ = UserDefaults.standard.string(forKey: USER_NAME), let _ = UserDefaults.standard.string(forKey: USER_IMAGE_URL) {
//                self.getPlaylists()
                self.getTop()
                self.getPlaylists()
            } else {
                self.getMe()
            }
        }) { (error) in
            self.hideLoader()
            let mainView = SignInViewController(nibName: nil, bundle: nil) //ViewController = Name of your controller
            UIApplication.shared.keyWindow?.rootViewController = mainView
        }
    }
    
    func getMe() {
        self.showLoader()
        viewModel.getMe(success: {
            self.hideLoader()
            self.getTop()
            self.getPlaylists()
//            self.getRecentlyPlayed()
        }) { (error) in
//            self.showErrorAlert(message: error.localizedDescription)
        }
    }
    
    func getPlaylists() {
        self.showLoader()
        viewModel.getPlaylists(success: {
            self.hideLoader()
            self.postTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }) { (error) in
            self.showErrorAlert(message: error.localizedDescription)
        }
    }
    
    func getTop() {
        self.showLoader()
        viewModel.getTop(success: {
            self.hideLoader()
            self.postTableView.reloadData()
            self.postTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }) { (error) in
            self.hideLoader()
            self.showErrorAlert(message: error.localizedDescription)
        }
    }
    
    func getRecentlyPlayed() {
        self.showLoader()
        viewModel.getRecently(success: {
            self.hideLoader()
            self.postTableView.reloadData()
        }) { (error) in
            self.showErrorAlert(message: error.localizedDescription)
        }
    }
    
    func setupPlayer() {
        self.albumImageView.downloaded(from: selectedMusic?.album?.images?[0].url ?? "")
        if let id = selectedMusic?.uri {
//            self.viewModel.play(content_uri: id, success: {
//                print("FOI")
//            }) { (error) in
//                self.showErrorAlert(message: error.localizedDescription)
//            }
            SpotifySingleton.shared().play(id: id, vc: self)
        }
    }
    
    func setupNavigation() {
        self.title = "Syncs"
        let barButton = UIBarButtonItem(image: UIImage(named: "profile"), style: .done, target: self, action: #selector(didTapNavButton))
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func didTapNavButton() {
        let vc = FriendsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func setupTableView() {
        self.postTableView.delegate = self
        self.postTableView.dataSource = self
        self.postTableView.separatorStyle = .none
        self.postTableView.register(UINib(nibName: MUSIC_CELL, bundle: nil), forCellReuseIdentifier: MUSIC_CELL)
        self.postTableView.register(UINib(nibName: SHARE_CELL, bundle: nil), forCellReuseIdentifier: SHARE_CELL)
        self.postTableView.register(UINib(nibName: PLAYLIST_CELL, bundle: nil), forCellReuseIdentifier: PLAYLIST_CELL)
    }
    
    func setupShadowView() {
        playerView.layer.shadowColor = UIColor.black.cgColor
        playerView.layer.shadowOpacity = 1
        playerView.layer.shadowOffset = .zero
        playerView.layer.shadowRadius = 10
    }
    
    func setupViewTaps() {
        let playerTap = UITapGestureRecognizer(target: self, action: #selector(didTapPlayer))
        self.playerView.addGestureRecognizer(playerTap)
    }
    
    func pushTo(vc: UIViewController) {
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func didTapPlayer() {
        if let music = selectedMusic {
            let vc = PlayerModalViewController(music: music)
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapLessButton(_ sender: Any) {
    }
    
    @IBAction func didTapPlayButton(_ sender: Any) {
    }
    
    @IBAction func didTapPlusButton(_ sender: Any) {
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows() + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 140
//        } else if let openedRow = openedRow, indexPath == openedRow {
//            return fixHeight
        } else {
//            return 0
//            switch viewModel.getCellTypeForRow(index: indexPath.row - 1) {
//            case .music:
                return 90
//            case .playlist:
//                return 140
//            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let shareCell = self.postTableView.dequeueReusableCell(withIdentifier: SHARE_CELL, for: indexPath) as! ShareTableViewCell
            shareCell.setup(musics: self.viewModel.getRecentlyPlayedTracks(), playlists: self.viewModel.getPlaylists())
            shareCell.delegate = self
            return shareCell
        } else {
            let musicCell = self.postTableView.dequeueReusableCell(withIdentifier: MUSIC_CELL, for: indexPath) as! MusicTableViewCell
            musicCell.setup(music: self.viewModel.getMusicForRow(index: indexPath.row - 1), isSelected: selectedIndex == indexPath.row)
            return musicCell
//            let playlistCell = self.postTableView.dequeueReusableCell(withIdentifier: PLAYLIST_CELL, for: indexPath) as! PlaylistTableViewCell
//            playlistCell.delegate = self
//            playlistCell.setup(indexPath: indexPath, height: fixHeight, isOpen: self.openedRow == indexPath)
//            //        playlistCell.layoutSubviews()
//            //        playlistCell.layoutIfNeeded()
//            playlistCell.selectionStyle = .none
//            return playlistCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if self.viewModel.getCellTypeForRow(index: indexPath.row) == .music, indexPath.row != 0 {
//            self.selectedMusic = self.viewModel.getMusicForRow(index: indexPath.row - 1)
//            self.selectedIndex = indexPath.row
//            self.postTableView.reloadData()
//            setupPlayer()
//        }
        if indexPath.row != 0 {
            self.selectedMusic = self.viewModel.getMusicForRow(index: indexPath.row - 1)
            self.selectedIndex = indexPath.row
            self.postTableView.reloadData()
            setupPlayer()
        }
        
    }
}

extension HomeViewController: ShareTableViewCellDelegate {
    func didTapItem(item playlist: Item?) {
        let vc = ShareModalViewController(item: playlist, recommended: self.viewModel.playlistResponse.items ?? [Item](), state: .fromPlaylist)
        pushTo(vc: vc)
    }
    
    func didTapSearch() {
        let vc = ShareModalViewController(item: nil, recommended: self.viewModel.topResponse.items ?? [MusicItem](), state: .fromSearch)
        pushTo(vc: vc)
    }
    
    func didTapItem(item: MusicItem?) {
        let vc = ShareModalViewController(item: item, recommended: self.viewModel.topResponse.items ?? [MusicItem](), state: .fromMusic)
        pushTo(vc: vc)
    }
}

extension HomeViewController: PlaylistTableViewCellDelegate {
    func didTapPlaylist(indexPath: IndexPath) {
        if self.openedRow == indexPath {
            openedRow = nil
        } else {
            self.openedRow = indexPath
        }
        self.postTableView.reloadRows(at: [indexPath], with: .fade)
        self.postTableView.reloadData()
    }
}
