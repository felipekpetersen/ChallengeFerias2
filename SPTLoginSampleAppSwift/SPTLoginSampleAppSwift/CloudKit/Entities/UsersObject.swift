//
//  UsersObject.swift
//  Synchs
//
//  Created by Felipe Petersen on 25/02/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation
import CloudKit

public class UsersObject: NSObject, EntityObject {
    
    public static let recordType = "UserType"
    public private(set) var record: CKRecord
    public private(set) var country: DataProperty<String?>
    public private(set) var display_name: DataProperty<String?>
    public private(set) var email: DataProperty<String?>
    public private(set) var external_urls: ReferenceField<ExternalUrlsResponseObject>
    public private(set) var images: ReferenceField<ImageObject>
    public private(set) var followers: ReferenceList<UsersObject>
    public private(set) var following: ReferenceList<UsersObject>
    public private(set) var href: DataProperty<String>
    public private(set) var id: DataProperty<String>
    public private(set) var posts: ReferenceList<SimplePostObject>
    public private(set) var product: DataProperty<String>
    public private(set) var type: DataProperty<String>
    public private(set) var uri: DataProperty<String>
    
    public init(record: CKRecord) {
        self.record = record
        self.country = DataProperty(record: record, key: "country")
        self.display_name = DataProperty(record: record, key: "display_name")
        self.email = DataProperty(record: record, key: "email")
        self.external_urls = ReferenceField(record: record, key: "external_urls", action: .deleteSelf)
        self.followers = ReferenceList(record: record, key: "followers")
        self.following = ReferenceList(record: record, key: "following")
        self.href = DataProperty(record: record, key: "href")
        self.id = DataProperty(record: record, key: "id")
        self.posts = ReferenceList(record: record, key: "posts")
        self.product = DataProperty(record: record, key: "product")
        self.type = DataProperty(record: record, key: "type")
        self.uri = DataProperty(record: record, key: "uri")
        self.images = ReferenceField(record: record, key: "images", action: .deleteSelf)
        super.init()
    }

}
