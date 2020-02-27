//
//  ExtensionString.swift
//  Synchs
//
//  Created by Felipe Petersen on 24/02/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
