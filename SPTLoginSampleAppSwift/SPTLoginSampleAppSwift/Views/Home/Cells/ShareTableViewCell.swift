//
//  ShareTableViewCell.swift
//  SPTLoginSampleAppSwift
//
//  Created by Felipe Petersen on 17/01/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import UIKit

protocol ShareTableViewCellDelegate {
    func didTapItem(state: ShareModalViewControllerState)
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        setupViewTap()
    }
    
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: MUSIC_CELL, bundle: nil), forCellWithReuseIdentifier: MUSIC_CELL)
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
    }
    
    @objc func didTapSearchView() {
        delegate?.didTapItem(state: .fromSearch)
    }
}

extension ShareTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MUSIC_CELL, for: indexPath) as? ShareMusicCollectionViewCell
        return cell ?? UICollectionViewCell()
    }
    
    
}
