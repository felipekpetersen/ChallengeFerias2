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

class ShareTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var musicView: RoundedView!
    @IBOutlet weak var playlistView: RoundedView!
    @IBOutlet weak var searchView: RoundedView!
    
    let MUSIC_CELL = "ShareMusicCollectionViewCell"
    var delegate: ShareTableViewCellDelegate?
    
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
        let musicTap = UITapGestureRecognizer(target: self, action: #selector(didTapMusicView))
        let playlistTap = UITapGestureRecognizer(target: self, action: #selector(didTapPlaylistView))
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(didTapSearchView))
        
        self.musicView.addGestureRecognizer(musicTap)
        self.playlistView.addGestureRecognizer(playlistTap)
        self.searchView.addGestureRecognizer(searchTap)
    }
    
    @objc func didTapMusicView() {
        
    }
    
    @objc func didTapPlaylistView() {
        
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
