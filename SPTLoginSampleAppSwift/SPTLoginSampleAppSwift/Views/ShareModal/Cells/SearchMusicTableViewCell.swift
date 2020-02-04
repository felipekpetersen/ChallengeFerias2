//
//  SearchMusicTableViewCell.swift
//  SPTLoginSampleAppSwift
//
//  Created by Felipe Petersen on 18/01/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import UIKit

class SearchMusicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var musicTitleLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    
    func setup(music: MockModel) {
        self.musicTitleLabel.text = music.musicName
        self.artistNameLabel.text = music.artist
        self.albumImageView.image = UIImage(named: music.albumImage ?? "")
    }
    
}
