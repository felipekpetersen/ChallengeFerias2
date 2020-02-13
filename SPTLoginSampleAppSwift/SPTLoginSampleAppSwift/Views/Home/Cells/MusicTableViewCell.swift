//
//  MusicTableViewCell.swift
//  SPTLoginSampleAppSwift
//
//  Created by Felipe Petersen on 15/01/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var genderCollectionView: UICollectionView!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var musicTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!

    let GENDER_CELL = "GenderCollectionViewCell"
    var genders = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        // Initialization code
    }
    
    func setupCollectionView() {
        self.genderCollectionView.dataSource = self
        self.genderCollectionView.delegate = self
        self.genderCollectionView.register(UINib(nibName: GENDER_CELL, bundle: nil), forCellWithReuseIdentifier: GENDER_CELL)
    }
    
    func setup(music: TopItem, isSelected: Bool) {
        self.musicTitleLabel.text = music.name
        self.artistLabel.text = music.artists?[0].name
        self.userNameLabel.text = "Felipe Kaça"
        self.albumImageView.image = UIImage(named: "music_placeholder")
        self.albumImageView.downloaded(from: music.album?.images?[0].url ?? "")
        self.genders = music.artists?[0].genres ?? [String]()
        if isSelected {
            self.musicTitleLabel.textColor = UIColor().hexStringToUIColor(hex: "#C9484F")
            self.artistLabel.textColor = UIColor().hexStringToUIColor(hex: "#C9484F")
        } else {
            self.musicTitleLabel.textColor = .white
            self.artistLabel.textColor = .white
        }
    }
}

extension MusicTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let genderCell = self.genderCollectionView.dequeueReusableCell(withReuseIdentifier: GENDER_CELL, for: indexPath) as! GenderCollectionViewCell
        genderCell.setup(gender: self.genders[indexPath.row])
        return genderCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = genders[indexPath.row]
        let itemSize = item.size(withAttributes: [
            NSAttributedString.Key.font : UIFont(name: "SourceSansPro-Light", size: 9)
        ])
        let size = CGSize(width: itemSize.width + 32, height: 15)
        return size
    }
}
