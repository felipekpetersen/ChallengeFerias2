//
//  PlaylistItemObject.swift
//  Synchs
//
//  Created by Felipe Petersen on 26/02/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation
import CloudKit

public class PlaylistItemObject: NSObject, EntityObject {
    
    public static let recordType = "PlaylistItem"
    public private(set) var record: CKRecord
    public private(set) var album: ReferenceField<AlbumObject>
    public private(set) var artists: ReferenceList<ArtistObject>
    public private(set) var external_urls: ReferenceField<ExternalUrlsResponseObject>
    public private(set) var href: DataProperty<String?>
    public private(set) var id: DataProperty<String?>
    public private(set) var images: ReferenceList<ImageObject>
    public private(set) var musicItems: ReferenceList<MusicItemObject>
    public private(set) var name: DataProperty<String?>
    public private(set) var owner: ReferenceField<OwnerObject>
    public private(set) var total: DataProperty<String?>
    public private(set) var uri: DataProperty<String?>
    
    public init(record: CKRecord) {
        self.record = record
        self.album = ReferenceField(record: record, key: "album", action: .deleteSelf)
        self.artists = ReferenceList(record: record, key: "artists")
        self.external_urls = ReferenceField(record: record, key: "external_urls", action: .deleteSelf)
        self.href = DataProperty(record: record, key: "href")
        self.id = DataProperty(record: record, key: "id")
        self.images = ReferenceList(record: record, key: "images")
        self.musicItems = ReferenceList(record: record, key: "musicItems")
        self.name = DataProperty(record: record, key: "name")
        self.owner = ReferenceField(record: record, key: "owner", action: .deleteSelf)
        self.total = DataProperty(record: record, key: "total")
        self.uri = DataProperty(record: record, key: "uri")
        super.init()
    }

}
