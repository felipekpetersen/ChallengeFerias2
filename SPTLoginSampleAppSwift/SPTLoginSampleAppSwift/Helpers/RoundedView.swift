//
//  RoundedView.swift
//  SPTLoginSampleAppSwift
//
//  Created by Felipe Petersen on 17/01/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation
import UIKit

class RoundedView: UIView{
    
    //MARK: - Definindo cornerRadius
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.masksToBounds = true
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    //MARK: - Definindo largura da borda da célula
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    //MARK: - Definindo cor da borda da célula
    @IBInspectable var borderColor: UIColor = .white{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
