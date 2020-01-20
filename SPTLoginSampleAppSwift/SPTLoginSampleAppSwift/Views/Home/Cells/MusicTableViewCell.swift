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
}

extension MusicTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let genderCell = self.genderCollectionView.dequeueReusableCell(withReuseIdentifier: GENDER_CELL, for: indexPath) as! GenderCollectionViewCell
        return genderCell
    }
}
