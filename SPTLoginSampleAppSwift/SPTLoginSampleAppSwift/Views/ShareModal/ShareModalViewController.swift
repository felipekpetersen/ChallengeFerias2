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
    
    
    @IBOutlet weak var outsideView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var musicNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var shareView: RoundedView!
    @IBOutlet weak var musicView: UIView!
    @IBOutlet weak var modalHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bottomStackConstraint: NSLayoutConstraint!
    
    let SEARCH_CELL = "SearchMusicTableViewCell"
    var sharingItem: MockModel?
    var recommended = [MockModel]()
    
    convenience init(item: MockModel?, recommended: [MockModel]) {
        self.init()
        self.sharingItem = item
        self.recommended = recommended
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
        self.tableView.separatorStyle = .none
    }
    
    func setupViewTap() {
        let shareTap = UITapGestureRecognizer(target: self, action: #selector(didTapShare))
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(didTapDismiss))
        self.shareView.addGestureRecognizer(shareTap)
        self.outsideView.addGestureRecognizer(dismissTap)
    }
    
    @objc func didTapShare() {
        
    }
    
    @objc func didTapDismiss() {
         self.dismiss(animated: true, completion: nil)
    }
    
    func setupViewState() {
        if let item = sharingItem {
            self.musicView.isHidden = false
            self.musicNameLabel.text = item.musicName
            self.artistNameLabel.text = item.artist
            self.albumImageView.image = UIImage(named: item.albumImage ?? "")
        } else {
            self.musicView.isHidden = true
        }
    }
}

extension ShareModalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommended.count
    }

//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Recommended"
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 16))
        view.backgroundColor = UIColor(red: 92.0 / 255.0, green: 92.0 / 255.0, blue: 92.0 / 255.0, alpha: 1.0)
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: self.view.frame.width - 16, height: 16))
        label.text = "Recommended"
        label.font = UIFont(name: "SourceSansPro-Semibold", size: 18)
        label.textColor = .white
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: SEARCH_CELL, for: indexPath) as! SearchMusicTableViewCell
        cell.setup(music: recommended[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sharingItem = recommended[indexPath.row]
        self.view.endEditing(true)
        self.setupViewState()
    }
}

extension ShareModalViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        UIView.animate(withDuration: 0.4) {
            self.modalHeight.constant = self.view.frame.height - 80
            self.bottomStackConstraint.constant = 300
            self.view.layoutIfNeeded()
        }
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.4) {
            self.modalHeight.constant = 360
            self.bottomStackConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
