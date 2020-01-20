//
//  ScrollViewExtension.swift
//  SPTLoginSampleAppSwift
//
//  Created by Felipe Petersen on 18/01/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation
import UIKit

//    // MARK: - AutoScrollWhenKeyboardShowsUp
//    /**
//     Sobe a scrollview quando o teclado aparece. Normalmente utilizado em formulários
//     O TextField deve estar dentro de uma s@objc @objc crollView
//     Não se esqueça de dar override no setScrollViewContentInset e dar removeObservers() no viewDidDisappear
//     */
//

var vSpinner:UIView?

extension UIViewController {
    func setupAutoScrollWhenKeyboardShowsUp() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        addObservers()
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (notification) in
            self.keyboardWillShow(notification: notification)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (notification) in
            self.keyboardWillHide(notification: notification)
        }
    }
    
    func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        setScrollViewContentInset(contentInset)
    }
    
    func keyboardWillHide(notification: Notification) {
        setScrollViewContentInset(UIEdgeInsets.zero)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    //    // OVERRIDE IT!
    @objc func setScrollViewContentInset(_ inset: UIEdgeInsets) {
        
    }
    
    //MARK:- Loader
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
