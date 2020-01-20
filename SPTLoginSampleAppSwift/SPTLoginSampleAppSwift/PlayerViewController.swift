//
//  PlayerViewController.swift
//  SPTLoginSampleAppSwift
//
//  Created by Felipe Petersen on 05/11/19.
//  Copyright © 2019 Spotify. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var playButtonOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func setupTableView() {
        
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
    }
    
    @IBAction func previousButtonTapped(_ sender: Any) {
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
    }
    
}
