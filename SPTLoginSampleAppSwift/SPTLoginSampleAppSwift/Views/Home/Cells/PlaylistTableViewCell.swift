//
//  PlaylistTableViewCell.swift
//  SPTLoginSampleAppSwift
//
//  Created by Felipe Petersen on 23/01/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import UIKit

protocol PlaylistTableViewCellDelegate {
    func didTapPlaylist(indexPath: IndexPath)
}

class PlaylistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var genderCollectionView: UICollectionView!
    @IBOutlet weak var playlistImageView: UIImageView!
    @IBOutlet weak var playlistTitleLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var musicTableView: UITableView!
    @IBOutlet weak var playlistView: UIView!
    @IBOutlet weak var musicTableViewHeightConstraint: NSLayoutConstraint!
    
    let MUSIC_CELL = "PlaylistMusicTableViewCell"
    var delegate: PlaylistTableViewCellDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setupTableView()
        setupCorner()
        setupViewTaps()
    }
    
    func setup(indexPath: IndexPath) {
        self.indexPath = indexPath
    }
    
    override func layoutSubviews() {
        self.setupConstraints()
        self.musicTableView.layoutIfNeeded()
        self.musicTableView.setNeedsDisplay()
        self.playlistView.setNeedsDisplay()
        self.playlistView.layoutIfNeeded()
        self.playlistView.needsUpdateConstraints()
        self.musicTableView.reloadData()
    }
    
    func setupTableView() {
        self.musicTableView.delegate = self
        self.musicTableView.dataSource = self
        self.musicTableView.register(UINib(nibName: MUSIC_CELL , bundle: nil), forCellReuseIdentifier: MUSIC_CELL)
    }
    
    func setupViewTaps() {
        let playlistTap = UITapGestureRecognizer(target: self, action: #selector(didTapPlaylist))
        self.playlistView.addGestureRecognizer(playlistTap)
    }
    
    func setupCorner() {
        self.playlistView.setRadiusToSpecificCorner(corners: [.allCorners], radius: 8)
    }
    
    func setupConstraints() {
        self.musicTableViewHeightConstraint.constant = 300
    }
    
    @objc func didTapPlaylist() {
//        UIView.animate(withDuration: 1) {
        delegate?.didTapPlaylist(indexPath: indexPath ?? IndexPath(row: 0, section: 0))
//        self.setupConstraints()
//        self.musicTableView.reloadData()
//        }
    }
    
}

extension PlaylistTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.musicTableView.dequeueReusableCell(withIdentifier: MUSIC_CELL, for: indexPath) as! PlaylistMusicTableViewCell
        return cell
    }
}
