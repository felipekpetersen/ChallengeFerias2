//
//  PlaylistMusicTableViewCell.swift
//  SPTLoginSampleAppSwift
//
//  Created by Felipe Petersen on 23/01/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import UIKit

class PlaylistMusicTableViewCell: UITableViewCell {

    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    
    func setup(track: PlaylistTracksItem, isSelected: Bool) {
        if isSelected {
            self.trackNameLabel.textColor = .red
        }
        trackNameLabel.text = track.track?.name
        artistNameLabel.text = track.track?.artists?[0].name
        albumImageView.downloaded(from: track.track?.album?.images?[0].url ?? "")
    }

}
