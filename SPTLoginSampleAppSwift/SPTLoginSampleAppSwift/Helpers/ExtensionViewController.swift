//
//  ExtensionViewController.swift
//  Synchs
//
//  Created by Felipe Petersen on 04/02/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation
import MobileCoreServices

//private var loaderViewAssociationKey: NVActivityIndicatorView?

extension UIViewController {
    
//    var loaderView: NVActivityIndicatorView! {
//        get { return objc_getAssociatedObject(self, &loaderViewAssociationKey) as? NVActivityIndicatorView }
//        set(newValue) { objc_setAssociatedObject(self, &loaderViewAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
//    }
    
    // MARK: - ShowModal
    func showModal(viewController controller: UIViewController) {
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true, completion: nil)
    }
    //
    //    // MARK: - Alert
    //
    func showNotImplementedAlert(){
        showAlert(title: "Alerta", message: "Função não implementada!", okBlock: nil, cancelBlock: nil)
    }
    //
    func showSuccessAlert(message: String, okBlock:(() -> Void)?, cancelBlock: (() -> Void)?){
        showAlert(title: "Sucesso", message: message, okBlock: okBlock, cancelBlock: cancelBlock)
    }
    //
    func showSuccessAlert(message: String){
        showAlert(title: "Sucesso", message: message, okBlock: nil, cancelBlock: nil)
    }
    //
    func showErrorAlert(message: String){
        showAlert(title: "Erro", message: message, okBlock: nil, cancelBlock: nil)
    }
    //
    func showErrorAlert(message: String, okBlock:(() -> Void)?, cancelBlock: (() -> Void)?){
        showAlert(title: "Erro", message: message, okBlock: okBlock, cancelBlock: cancelBlock)
    }
    
    func showAlert(title: String, message: String, okBlock:(() -> Void)?, cancelBlock: (() -> Void)?){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let titleOkAction = "Ok"
        let titleCancelAction = "Cancelar"
        
        //        if (cancelBlock != nil) {
        //            titleOkAction = NSLocalizedString(key: "Sim")
        //            titleCancelAction = NSLocalizedString(key: "Não")
        //        }
        
        
        let ok = UIAlertAction(title: titleOkAction, style: .default) { (action) in
            if let okBl = okBlock {
                okBl()
            }
            alert.dismiss(animated: true, completion: nil);
        }
        
        alert.addAction(ok)
        
        if let cancelBl = cancelBlock {
            let cancel = UIAlertAction(title: titleCancelAction, style: .cancel) { (action) in
                cancelBl()
            }
            alert.addAction(cancel)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Loader
    //    /**
    //     Github: https://github.com/ninjaprox/NVActivityIndicatorView
    //     Mostra o loader na tela. Cor default = MAIN_COLOR
    //     Escolha um estilo (listados no github)
    //     */
//    func showLoader() {
//
//        if(loaderView == nil) {
//            loaderView = UIActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.size.width/2) - 15, y: UIScreen.main.bounds.size.height/2, width: 35, height: 35) , type: UIActivityIndicatorView.ballTrianglePath, color: Colors.MAIN_COLOR, padding: 0)
//        }
//
//        self.lockView(self.view)
//
//        if(loaderView.isAnimating == false){
//            loaderView.startAnimating()
//        }
//
//        if self.navigationController ==  nil {
//            self.view.addSubview(loaderView)
//        }
//        else {
//            self.navigationController?.view.addSubview(loaderView)
//        }
//        //
//    }
//    //
//    func hideLoader () {
//        if(loaderView != nil){
//            self.unlockView(self.view)
//            loaderView.stopAnimating()
//            loaderView.removeFromSuperview()
//        }
//    }
//
//    // MARK: - Views
//    /**
//     Desativa a interação do usuário naquela view
//     */
//    func lockView(_ view: UIView){
//        view.isUserInteractionEnabled = false
//    }
//
//    func unlockView(_ view: UIView) {
//        view.isUserInteractionEnabled = true
//    }
//
    
    func showLoader() {
        let alert = UIAlertController(title: nil, message: "Carregando...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func hideLoader() {
        dismiss(animated: false, completion: nil)
    }
}
