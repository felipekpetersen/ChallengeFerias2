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
    public private(set) var author: ReferenceField<UsersObject>
    public private(set) var isMusic: DataProperty<Int?>
    public private(set) var musicItem: ReferenceField<MusicItemObject>
    public private(set) var playlistItem: ReferenceField<PlaylistItemObject>
    
    public init(record: CKRecord) {
        self.record = record
        self.author = ReferenceField(record: record, key: "author", action: .deleteSelf)
        self.isMusic = DataProperty(record: record, key: "isMusic")
        self.musicItem = ReferenceField(record: record, key: "musicItem", action: .deleteSelf)
        self.playlistItem = ReferenceField(record: record, key: "playlistItem", action: .deleteSelf)
        super.init()
    }
}
