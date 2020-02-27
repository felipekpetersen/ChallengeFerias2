//
//  ExternalUrlsResponseObject.swift
//  Synchs
//
//  Created by Felipe Petersen on 25/02/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation
import CloudKit

public class ExternalUrlsResponseObject: NSObject, EntityObject {
    
    public static let recordType = "ExternalUrlsResponse"
    public private(set) var record: CKRecord
    public private(set) var spotify: DataProperty<String>

    public init(record: CKRecord) {
           self.record = record
           self.spotify = DataProperty(record: record, key: "spotify")
           super.init()
       }

}
