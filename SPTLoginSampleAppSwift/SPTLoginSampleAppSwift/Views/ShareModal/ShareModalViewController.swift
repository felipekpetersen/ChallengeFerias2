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
    case fromMusic
    case fromPlaylist
    case didSearch
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
    var sharingMusicItem: MusicItem?
    var recommendedMusic = [MusicItem]()
    var sharingPlaylistItem: MusicItem?
    var recommendedPlaylist = [MusicItem]()
    var sharingSearchItem: MusicItem?
    var state: ShareModalViewControllerState?
    var viewModel = ShareModalViewModel()
    
    convenience init(item: MusicItem?, recommended: [MusicItem], state: ShareModalViewControllerState) {
        self.init()
        self.sharingMusicItem = item
        if state == .fromMusic {
            self.recommendedMusic = recommended
        } else if state == .fromPlaylist {
            self.recommendedPlaylist = recommended
        }
        self.state = state
    }
    
//    convenience init(item playlist: MusicItem?, recommended: [MusicItem], state: ShareModalViewControllerState) {
//        self.init()
//        self.sharingPlaylistItem = playlist
//        self.recommendedPlaylist = recommended
//        self.state = state 
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupViewState()
        setupViewTap()
        self.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.modalHeight.constant = self.view.frame.height - 80
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
        if let item = sharingMusicItem {
            self.musicView.isHidden = false
            self.musicNameLabel.text = item.name
            self.artistNameLabel.text = item.artists?[0].name
            self.albumImageView.downloaded(from: item.album?.images?[0].url ?? item.images?[0].url ?? "")
        } else if let item = sharingPlaylistItem {
            self.musicView.isHidden = false
            self.musicNameLabel.text = item.name
            self.artistNameLabel.text = item.owner?.display_name
            self.albumImageView.downloaded(from: item.album?.images?[0].url ?? item.images?[0].url ?? "")
        } else if let item = sharingSearchItem{
            self.musicView.isHidden = false
            self.musicNameLabel.text = item.name
            self.artistNameLabel.text = item.artists?[0].name
            self.albumImageView.downloaded(from: item.album?.images?[0].url ?? item.images?[0].url ?? "")
        }
    }
}

extension ShareModalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .fromMusic, .fromSearch:
            return recommendedMusic.count
        case .didSearch:
            return self.viewModel.getNumberOfRowsForSearch()
        default:
            return recommendedPlaylist.count
        }
    }

//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Recommended"
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 16))
        view.backgroundColor = UIColor(red: 92.0 / 255.0, green: 92.0 / 255.0, blue: 92.0 / 255.0, alpha: 1.0)
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: self.view.frame.width - 16, height: 16))
        label.font = UIFont(name: "SourceSansPro-Semibold", size: 18)
        label.textColor = .white
        switch self.state {
        case .fromMusic, .fromPlaylist, .fromSearch:
            label.text = "Recommended"
        default:
            label.text = "Results"
        }
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: SEARCH_CELL, for: indexPath) as! SearchMusicTableViewCell
        switch self.state {
        case .fromMusic,  .fromSearch:
            cell.setup(music: recommendedMusic[indexPath.row])
        case .fromPlaylist:
            cell.setup(music: recommendedPlaylist[indexPath.row])

        default:
            cell.setup(music: self.viewModel.getSearchForRow(index: indexPath.row))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sharingMusicItem = nil
        self.sharingPlaylistItem = nil
        self.sharingSearchItem = nil
        
        switch state {
        case .fromMusic, .fromSearch:
            self.sharingMusicItem = recommendedMusic[indexPath.row]
        case .fromPlaylist:
            self.sharingPlaylistItem = recommendedPlaylist[indexPath.row]
        case .didSearch:
            self.sharingSearchItem = self.viewModel.getSearchForRow(index: indexPath.row)
        case .none:
            break
        }
        self.view.endEditing(true)
        self.setupViewState()
    }
}

extension ShareModalViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        UIView.animate(withDuration: 0.4) {
            self.bottomStackConstraint.constant = 300
            self.view.layoutIfNeeded()
        }
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.4) {
//            self.modalHeight.constant = 360
            self.bottomStackConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let search = searchBar.text {
            self.showLoader()
            SpotifySingleton.shared().getSearch(search: search, success: { (response) in
                self.viewModel.searchResult = response
                self.state = .didSearch
                self.tableView.reloadData()
                self.hideLoader()
            }) { (error) in
                print("nao foi")
                self.hideLoader()
            }

        }
    }
}
