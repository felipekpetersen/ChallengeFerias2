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
    func didSelectMusic(indexPath: IndexPath, music: PlaylistTracksItem)
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
    let GENRE_CELL = "GenderCollectionViewCell"
    var delegate: PlaylistTableViewCellDelegate?
    var indexPath: IndexPath?
    var height:CGFloat?
    var isOpen = false
    var tracks = [PlaylistTracksItem]()
    var selectedRow: Int?
    
    var genres = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setupTableView()
        setupCorner()
        setupViewTaps()
        setupCollectionView()
    }
    
    func setup(tracks: PlaylistTracksResponse?, item: MusicItem, indexPath: IndexPath, height: CGFloat, isOpen: Bool, isSelected: Bool, selectedRow: Int?) {
        if let getTracks = tracks {
            self.tracks = getTracks.items ?? [PlaylistTracksItem]()
            self.musicTableView.reloadData()
        }
        if isSelected {
            self.selectedRow = selectedRow
        }
        
        self.genres = item.artists?[0].genres ?? [String]()
        self.genderCollectionView.reloadData()
        
        self.playlistImageView.downloaded(from: item.images?[0].url ?? "")
        self.playlistTitleLabel.text = item.name
        self.ownerLabel.text = item.owner?.display_name
        self.userNameLabel.text = "Felipe"
        self.height = height
        self.indexPath = indexPath
        self.isOpen = isOpen
        setupConstraints()
    }
    
    override func layoutSubviews() {
        self.setupConstraints()
//        self.setupConstraints()
//        self.playlistView.needsUpdateConstraints()
//        self.musicTableView.reloadData()
    }
    
    func setupTableView() {
        self.musicTableView.delegate = self
        self.musicTableView.dataSource = self
        self.musicTableView.register(UINib(nibName: MUSIC_CELL , bundle: nil), forCellReuseIdentifier: MUSIC_CELL)
    }
    
    func setupCollectionView() {
        self.genderCollectionView.delegate = self
        self.genderCollectionView.dataSource = self
        self.genderCollectionView.register(UINib(nibName: GENRE_CELL, bundle: nil), forCellWithReuseIdentifier: GENRE_CELL)
    }
    
    func setupViewTaps() {
        let playlistTap = UITapGestureRecognizer(target: self, action: #selector(didTapPlaylist))
        self.playlistView.addGestureRecognizer(playlistTap)
    }
    
    func setupCorner() {
        self.playlistView.setRadiusToSpecificCorner(corners: [.allCorners], radius: 8)
    }
    
    func setupConstraints() {
        if isOpen {
        self.musicTableViewHeightConstraint.constant = 400
        self.playlistView.needsUpdateConstraints()
        self.musicTableView.needsUpdateConstraints()
        self.musicTableView.layoutIfNeeded()
        self.musicTableView.setNeedsDisplay()
        self.playlistView.setNeedsDisplay()
        self.playlistView.layoutIfNeeded()
        self.contentView.setNeedsDisplay()
        self.contentView.layoutIfNeeded()
        } else {
            self.musicTableViewHeightConstraint.constant = 0
        }
    }
    
    @objc func didTapPlaylist() {
//        UIView.animate(withDuration: 1) {
        delegate?.didTapPlaylist(indexPath: indexPath ?? IndexPath(row: 0, section: 0))
        self.setupConstraints()
//        self.musicTableView.reloadData()
//        }
    }
    
}

extension PlaylistTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.musicTableView.dequeueReusableCell(withIdentifier: MUSIC_CELL, for: indexPath) as! PlaylistMusicTableViewCell
        cell.setup(track: self.tracks[indexPath.row], isSelected: self.selectedRow == indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectMusic(indexPath: indexPath, music: self.tracks[indexPath.row])
    }
}

extension PlaylistTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.genderCollectionView.dequeueReusableCell(withReuseIdentifier: GENRE_CELL, for: indexPath) as! GenderCollectionViewCell
        cell.setup(gender: self.genres[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let item = genres[indexPath.row]
           let itemSize = item.size(withAttributes: [
               NSAttributedString.Key.font : UIFont(name: "SourceSansPro-Light", size: 9)
           ])
           let size = CGSize(width: itemSize.width + 32, height: 15)
           return size
       }
    
    
}
