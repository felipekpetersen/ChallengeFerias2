//
//  OwnerObject.swift
//  Synchs
//
//  Created by Felipe Petersen on 26/02/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation
import CloudKit

public class OwnerObject: NSObject, EntityObject {
    
    public static let recordType = "Owner"
    public private(set) var record: CKRecord
    public private(set) var display_name: DataProperty<String?>
    public private(set) var external_urls: ReferenceField<ExternalUrlsResponseObject>
    public private(set) var href: DataProperty<String?>
    public private(set) var id: DataProperty<String?>
    public private(set) var uri: DataProperty<String?>
    
    public init(record: CKRecord) {
        self.record = record
        self.display_name = DataProperty(record: record, key: "display_name")
        self.external_urls = ReferenceField(record: record, key: "external_urls", action: .deleteSelf)
        self.href = DataProperty(record: record, key: "href")
        self.id = DataProperty(record: record, key: "id")
        self.uri = DataProperty(record: record, key: "uri")
        super.init()
    }

}
