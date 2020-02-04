//
//  GenderCollectionViewCell.swift
//  SPTLoginSampleAppSwift
//
//  Created by Felipe Petersen on 17/01/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import UIKit

class GenderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var genderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(gender: String) {
        self.genderLabel.text = gender
    }

}
