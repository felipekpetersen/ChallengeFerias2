//
//  PostObject.swift
//  Synchs
//
//  Created by Felipe Petersen on 25/02/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation
import CloudKit

public class PostObject: NSObject, EntityObject {
    
    public static let recordType = "Post"
    public private(set) var record: CKRecord
    public private(set) var author: ReferenceField<UsersObject>?
    public private(set) var isMusic: DataProperty<Int?>
    public private(set) var musicItem: ReferenceField<MusicItemObject>?
    public private(set) var playlistItem: ReferenceField<PlaylistItemObject>?
    
    public init(record: CKRecord) {
        self.record = record
        self.author = ReferenceField(record: record, key: "author", action: .deleteSelf)
        self.isMusic = DataProperty(record: record, key: "isMusic")
        self.musicItem = ReferenceField(record: record, key: "musicItem", action: .deleteSelf)
        self.playlistItem = ReferenceField(record: record, key: "playlistItem", action: .deleteSelf)
        super.init()
    }
}


public class SimplePostObject: NSObject, EntityObject {
    
    public static let recordType = "SimplePost"
    public private(set) var record: CKRecord
    public private(set) var imageUrl: DataProperty<String?>
    public private(set) var isMusic: DataProperty<Int?>
    public private(set) var owner: DataProperty<String?>
    public private(set) var sharedBy: ReferenceField<UsersObject>
//    public private(set) var title: DataProperty<String?>
//    public private(set) var uri: DataProperty<String?>
    public private(set) var id: DataProperty<String?>
    public private(set) var simpleMusics: ReferenceList<SimpleMusicObject>


    public init(record: CKRecord) {
        self.record = record
        self.sharedBy = ReferenceField(record: record, key: "sharedBy", action: .deleteSelf)
        self.imageUrl = DataProperty(record: record, key: "imageUrl")
        self.isMusic = DataProperty(record: record, key: "isMusic")
        self.owner = DataProperty(record: record, key: "owner")
        self.id = DataProperty(record: record, key: "id")
        self.simpleMusics = ReferenceList(record: record, key: "simpleMusics")

        super.init()
    }
}
