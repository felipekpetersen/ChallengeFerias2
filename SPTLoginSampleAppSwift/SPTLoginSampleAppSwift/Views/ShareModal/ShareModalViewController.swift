//
//  ShareModalViewController.swift
//  SPTLoginSampleAppSwift
//
//  Created by Felipe Petersen on 18/01/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import UIKit

enum ShareModalViewControllerState {
    case fromSearch
    case fromCell
}

class ShareModalViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var musicNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var shareView: RoundedView!
    @IBOutlet weak var musicView: UIView!
    @IBOutlet weak var modalHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bottomStackConstraint: NSLayoutConstraint!
    
    let SEARCH_CELL = "SearchMusicTableViewCell"
    var state: ShareModalViewControllerState = .fromSearch
    
    convenience init(state: ShareModalViewControllerState) {
        self.init()
        self.state = state
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupViewState()
        setupViewTap()
        self.searchBar.delegate = self
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: SEARCH_CELL, bundle: nil), forCellReuseIdentifier: SEARCH_CELL)
    }
    
    func setupViewTap() {
        let shareTap = UITapGestureRecognizer(target: self, action: #selector(didTapShare))
        self.shareView.addGestureRecognizer(shareTap)
    }
    
    @objc func didTapShare() {
        
    }
    
    func setupViewState() {
        switch state {
        case .fromCell:
            self.musicView.isHidden = false
        default:
            self.musicView.isHidden = true
        }
    }
}

extension ShareModalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recommended"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 16))
        view.backgroundColor = UIColor(red: 92.0 / 255.0, green: 92.0 / 255.0, blue: 92.0 / 255.0, alpha: 1.0)
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: self.view.frame.width - 16, height: 16))
        label.text = "Recommended"
        label.font = UIFont(name: "SourceSansPro-Semibold", size: 18)
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: SEARCH_CELL, for: indexPath) as! SearchMusicTableViewCell
        return cell
    }
}

extension ShareModalViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        UIView.animate(withDuration: 0.4) {
            self.modalHeight.constant = self.view.frame.height - 80
            self.bottomStackConstraint.constant = 200
            self.view.layoutIfNeeded()
        }
        return true
    }
}
