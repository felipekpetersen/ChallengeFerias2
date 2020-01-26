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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigation()
        setupShadowView()
        setupViewTaps()
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
    
    @objc func didTapPlayer() {
        let vc = PlayerModalViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(vc, animated: true, completion: nil)
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        } else if let openedRow = openedRow, indexPath == openedRow {
            return fixHeight
        } else {
            return 140
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let shareCell = self.postTableView.dequeueReusableCell(withIdentifier: SHARE_CELL, for: indexPath) as! ShareTableViewCell
            shareCell.delegate = self
            return shareCell
        } else {
            let playlistCell = self.postTableView.dequeueReusableCell(withIdentifier: PLAYLIST_CELL, for: indexPath) as! PlaylistTableViewCell
            playlistCell.delegate = self
            playlistCell.setup(indexPath: indexPath, height: fixHeight, isOpen: self.openedRow == indexPath)
            //        playlistCell.layoutSubviews()
            //        playlistCell.layoutIfNeeded()
            playlistCell.selectionStyle = .none
            return playlistCell
        }
//        let musicCell = self.postTableView.dequeueReusableCell(withIdentifier: MUSIC_CELL, for: indexPath) as! MusicTableViewCell
    }
}

extension HomeViewController: ShareTableViewCellDelegate {
    func didTapItem(state: ShareModalViewControllerState) {
        let vc = ShareModalViewController(state: state)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(vc, animated: true, completion: nil)
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
