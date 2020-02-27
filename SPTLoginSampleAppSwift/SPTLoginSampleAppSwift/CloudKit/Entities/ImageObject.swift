//
//  ImageObject.swift
//  Synchs
//
//  Created by Felipe Petersen on 26/02/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation
import CloudKit

public class ImageObject: NSObject, EntityObject {
    
    public static let recordType = "ImageResponse"
    public private(set) var record: CKRecord
    public private(set) var width: DataProperty<Int?>
    public private(set) var height: DataProperty<Int?>
    public private(set) var url: DataProperty<String?>
    
    public init(record: CKRecord) {
        self.record = record
        self.width = DataProperty(record: record, key: "width")
        self.height = DataProperty(record: record, key: "height")
        self.url = DataProperty(record: record, key: "url")
        super.init()
    }

}
