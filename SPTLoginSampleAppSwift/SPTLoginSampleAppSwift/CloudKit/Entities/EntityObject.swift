//
//  EntityObject.swift
//  Synchs
//
//  Created by Felipe Petersen on 24/02/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import CloudKit

public protocol EntityObject: NSObject {
    static var recordType: String { get }
    var record: CKRecord { get }
}
