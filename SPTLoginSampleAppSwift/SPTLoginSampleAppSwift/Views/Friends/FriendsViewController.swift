//
//  FriendsViewController.swift
//  SPTLoginSampleAppSwift
//
//  Created by Felipe Petersen on 22/01/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHashLabel: UILabel!
    @IBOutlet weak var shareView: RoundedView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var qrCodeStackView: UIStackView!
    
    let FRIEND_CELL = "FriendTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        self.tableView.register(UINib(nibName: FRIEND_CELL, bundle: nil), forCellReuseIdentifier: FRIEND_CELL)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
    }
    
    func changeHiddenState() {
        self.tableView.isHidden = !self.tableView.isHidden
        self.qrCodeStackView.isHidden = !self.qrCodeStackView.isHidden
    }
}

extension FriendsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: FRIEND_CELL, for: indexPath) as! FriendTableViewCell
        return cell
    }
}

extension FriendsViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.changeHiddenState()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.changeHiddenState()
    }
    
}
