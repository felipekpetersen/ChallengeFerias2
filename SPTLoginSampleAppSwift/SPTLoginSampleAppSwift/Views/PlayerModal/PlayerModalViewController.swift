//
//  PlayerModalViewController.swift
//  SPTLoginSampleAppSwift
//
//  Created by Felipe Petersen on 18/01/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import UIKit

class PlayerModalViewController: UIViewController {
    
    @IBOutlet weak var outsideView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var degradeView: UIView!
    @IBOutlet weak var musicNameLabel: UILabel!
    @IBOutlet weak var artirstNameLabel: UILabel!
    
    
    let colors = Colors()
    var music = TopItem()
    
    convenience init(music: TopItem) {
        self.init()
        self.music = music
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupView()
        setupViewTap()
    }
    
    func setupBackground() {
        degradeView.backgroundColor = .clear
            var backgroundLayer = colors.gl
        backgroundLayer?.frame = degradeView.frame
        degradeView.layer.insertSublayer(backgroundLayer!, at: 0)
    }
    
    func setupView() {
        self.musicNameLabel.text = music.name
        self.artirstNameLabel.text = music.artists?[0].name
        self.backgroundImageView.downloaded(from: music.album?.images?[0].url ?? "")
    }
    
    @IBAction func didTapPrevButton(_ sender: Any) {
    }
    @IBAction func didTapLessButton(_ sender: Any) {
    }
    @IBAction func didTapPlayButton(_ sender: Any) {
    }
    @IBAction func didTapPlusButton(_ sender: Any) {
    }
    @IBAction func didTapNextButton(_ sender: Any) {
    }
    
    func setupViewTap() {
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(didTapDismiss))
        self.outsideView.addGestureRecognizer(dismissTap)
    }
    
    @objc func didTapDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}

class Colors {
    
    var gl:CAGradientLayer!

    init() {
        let colorTop = UIColor(red: 124.0 / 255.0, green: 124.0 / 255.0, blue: 124.0 / 255.0, alpha: 0.72).cgColor
        let colorBottom = UIColor(red: 92.0 / 255.0, green: 92.0 / 255.0, blue: 92.0 / 255.0, alpha: 1.0).cgColor

        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
    }
}
