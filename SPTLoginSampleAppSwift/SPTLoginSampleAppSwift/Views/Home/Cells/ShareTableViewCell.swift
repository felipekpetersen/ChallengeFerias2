//
//  ShareTableViewCell.swift
//  SPTLoginSampleAppSwift
//
//  Created by Felipe Petersen on 17/01/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import UIKit

protocol ShareTableViewCellDelegate {
    func didTapItem(item: MusicItem?, isMusic: Bool)
//    func didTapItem(item playlist: MusicItem?)
    func didTapSearch()
}

enum SelectedSharedType {
    case playlist
    case music
}

class ShareTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var musicView: RoundedView!
    @IBOutlet weak var playlistView: RoundedView!
    @IBOutlet weak var searchView: RoundedView!
    
    let MUSIC_CELL = "ShareMusicCollectionViewCell"
    var delegate: ShareTableViewCellDelegate?
    var selectedType: SelectedSharedType = .music
    var musics = [MusicItem]()
    var playlists = [MusicItem]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.musicView.backgroundColor = .red
    }
    
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: MUSIC_CELL, bundle: nil), forCellWithReuseIdentifier: MUSIC_CELL)
    }
    
    func setup(musics: [MusicItem], playlists: [MusicItem]) {
        self.musics = musics
        self.playlists = playlists
        setupCollectionView()
        setupViewTap()
        self.collectionView.reloadData()
    }
    
    func setupViewTap() {
        let musicTap = UITapGestureRecognizer(target: self, action: #selector(didTapMusicView(_:)))
        let playlistTap = UITapGestureRecognizer(target: self, action: #selector(didTapPlaylistView(_:)))
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(didTapSearchView))
        
        self.musicView.addGestureRecognizer(musicTap)
        self.playlistView.addGestureRecognizer(playlistTap)
        self.searchView.addGestureRecognizer(searchTap)
    }
    
    @objc func didTapMusicView(_ sender: UITapGestureRecognizer? = nil) {
        setupSelected(sender: sender)
    }
    
    @objc func didTapPlaylistView(_ sender: UITapGestureRecognizer? = nil) {
        setupSelected(sender: sender)
    }
    
    func setupSelected(sender: UITapGestureRecognizer?) {
        self.musicView.backgroundColor = UIColor().hexStringToUIColor(hex: "#4a4a4a")
        self.playlistView.backgroundColor = UIColor().hexStringToUIColor(hex: "#4a4a4a")
        sender?.view?.backgroundColor = .red
        self.selectedType = sender?.view == musicView ? .music : .playlist
        self.collectionView.reloadData()
    }
    
    @objc func didTapSearchView() {
        delegate?.didTapSearch()
    }
}

extension ShareTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedType == .music {
            return musics.count
        }
        return playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MUSIC_CELL, for: indexPath) as? ShareMusicCollectionViewCell
        if selectedType == .music {
            cell?.setup(of: self.musics[indexPath.row])
        } else {
            cell?.setup(of: self.playlists[indexPath.row])
        }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedType == .music {
            delegate?.didTapItem(item: musics[indexPath.row], isMusic: true)
        } else {
            delegate?.didTapItem(item: playlists[indexPath.row], isMusic: false)
        }
    }
    
    
}
