//
//  QRCodeGenerator.swift
//  SPTLoginSampleAppSwift
//
//  Created by Felipe Petersen on 22/01/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import UIKit

public class QRCodeGenerator {
    private init() {
    }

    public static func qrImage(from string: String) -> UIImage? {
        return qrImage(from: string, using: .white)
    }

    public static func qrImage(from string: String, using color: UIColor) -> UIImage? {
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        let qrData = string.data(using: String.Encoding.ascii)
        qrFilter.setValue(qrData, forKey: "inputMessage")
        let qrTransform = CGAffineTransform(scaleX: 20, y: 20)

        if let img = qrFilter.outputImage?.transformed(by: qrTransform).tinted(using: color) {
            return UIImage(ciImage: img)
        }
        return nil
    }
}
