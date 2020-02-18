//
//  ShareMusicCollectionViewCell.swift
//  SPTLoginSampleAppSwift
//
//  Created by Felipe Petersen on 17/01/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import UIKit

class ShareMusicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(of music: MusicItem) {
        self.titleLabel.text = music.name
        self.albumImageView.image = UIImage(named: "music_placeholder")
        self.albumImageView.downloaded(from: music.album?.images?[0].url ?? "")
    }
    
    func setup(of playlist: Item) {
        self.titleLabel.text = playlist.name
        self.albumImageView.image = UIImage(named: "music_placeholder")
        self.albumImageView.downloaded(from: playlist.images?[0].url ?? "")
    }

}
