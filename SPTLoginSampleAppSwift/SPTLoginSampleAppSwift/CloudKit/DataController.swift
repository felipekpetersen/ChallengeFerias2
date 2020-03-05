//
//  DataController.swift
//  Synchs
//
//  Created by Felipe Petersen on 24/02/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import CloudKit
import UIKit

public class DataController {
    private let container: CKContainer
    private let privateDB: CKDatabase
    private let sharedDB: CKDatabase
    private let publicDB: CKDatabase
    
    fileprivate var usuarioID: CKRecord.ID?
    fileprivate var userObject: UsersObject?

    private static func errorHandler(error: CKError, description: String? = nil) {
        switch error.code {
        case .notAuthenticated:
            let alert = UIAlertController(
                title: "Faça o login no iCloud".localized(),
                message: "Esse aplicativo usa o iCloud Drive para manter seus dados seguros.".localized() + " " +
                "Para ativar, vá em ajustes, iCloud, e entre com seu Apple ID.".localized(), preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Cancelar".localized(), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Abrir Ajustes".localized(), style: .default, handler: { (_) in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }))
            if let topController = UIApplication.shared.keyWindow?.rootViewController {
                if let presented = topController.presentedViewController {
                    presented.present(alert, animated: true)
                } else {
                    topController.present(alert, animated: true)
                }
            }
        case .networkUnavailable, .networkFailure:
            let alert = UIAlertController(
                title: "Não foi possível se comunicar com o servidor.".localized(),
                message: "Esse aplicativo depende de uma conexão de internet.".localized() + " " +
                "Cheque sua conexão e tente novamente.".localized(), preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            if let topController = UIApplication.shared.keyWindow?.rootViewController {
                if let presented = topController.presentedViewController {
                    presented.present(alert, animated: true)
                } else {
                    topController.present(alert, animated: true)
                }
            }
        default:
            if let description = description {
                fatalError(description)
            } else {
                fatalError(error.localizedDescription)
            }
        }
    }

    private var completionHandlerDefault: (DataActionAnswer) -> Void = {
        (answer) in
        switch answer {
        case .fail(let error, let desc):
            errorHandler(error: error, description: desc)
        default:
            return
        }
    }

    private var recordsToSave: [EntityObject] = []
    private var recordsToDelete: [EntityObject] = []
    
    // MARK: Saving Object
    private func saveObject(database: CKDatabase, object: EntityObject,
                            completionHandler: @escaping ((DataActionAnswer) -> Void)) {
        database.save(object.record) { (_, error) in
            if let error = error as? CKError {
                DispatchQueue.main.async {
                    completionHandler(.fail(error: error, description:
                        "Erro em salvar o objeto na Cloud - Save: \(String(describing: error))"))
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(.successful)
            }
            return
        }
    }
    
    // MARK: Saving Objects
    private func saveData(database: CKDatabase) {
        var savingRecords: [CKRecord] = []
        for obj in recordsToSave {
            savingRecords.append(obj.record)
        }
        recordsToSave = []
        var deletingRecords: [CKRecord.ID] = []
        for obj in recordsToDelete {
            deletingRecords.append(obj.record.recordID)
        }
        recordsToDelete = []

        let operation: CKModifyRecordsOperation = CKModifyRecordsOperation(
            recordsToSave: savingRecords, recordIDsToDelete: deletingRecords)
        
        operation.savePolicy = .allKeys
        database.add(operation)
    }

    public var refreshing: Bool = false {
        didSet {
            if !refreshing {
                completionHandlers = []
            }
        }
    }
    
    private var completionHandlers:[() -> Void] = []

    private var _usuario: UsersObject?
//    private var _campainhas: [Campainha] = []
//    private var _gruposCampainhas: [GrupoCampainha] = []

    public func getEntityByID(_ entityId: CKRecord.ID) -> EntityObject? {
        if _usuario?.record.recordID == entityId {
            return _usuario
        }
        return nil
    }
    
    // MARK: Save object
    public func saveModifications(obj: [EntityObject]) {
        recordsToSave.append(contentsOf: obj)
        saveData(database: publicDB)
    }

    // MARK: Singleton Properties
    private init() {
        container = CKContainer.default()
        privateDB = container.privateCloudDatabase
        sharedDB = container.sharedCloudDatabase
        publicDB = container.publicCloudDatabase
    }

    class func shared() -> DataController {
        return sharedModelController
    }

    private static var sharedModelController: DataController = {
        let mController = DataController()
        return mController
    }()
    
    //MARK:-User functions
    func checkUser(_ user: UserResponse, completionHandler: @escaping (Bool) -> Void)  {
        let predicate = NSPredicate(format: "id == %@", user.id ?? "")
        let query = CKQuery(recordType: "UserType", predicate: predicate)
//        var userObject: UsersObject?
        fetch(query: query) { (answer) in
            switch answer {
            case .successful(let results):
                if results?.count ?? 0 < 1 {
                    self.createUser(user: user)
                    
//                    userObject = results?[0].va
                }
                if results?.count ?? 0 > 0 {
                    if let result = results?[0] {
                        self.userObject = UsersObject(record: result)
                    }
                }
                completionHandler(true)
//                return results?[0] as? UsersObject
                //Ja existe usuario para esse id, logo nao criar
                break
            case .fail(let err, let desc):
                DataController.errorHandler(error: err)
//                return nil
            }
        }
    }
    
    func createUser(user: UserResponse) {
        if let id = user.id {
            let newUser = UsersObject(user: user)
            newUser.id.value = id
            if let country = user.country { newUser.country.value = country }
            if let name = user.display_name { newUser.display_name.value = name }
            if let email = user.email { newUser.email.value = email }
            if let external_urls = user.external_urls {
                let record = CKRecord(recordType: ExternalUrlsResponseObject.recordType)
                let eUrls = ExternalUrlsResponseObject(record: record)
                if let spotify = external_urls.spotify {
                    eUrls.spotify.value = spotify
                    newUser.external_urls.value = eUrls
                    recordsToSave.append(eUrls)
                }
            }
            if let href = user.href { newUser.href.value = href }
            if let id = user.id { newUser.id.value = id }
            if let image = user.images?[0] {
                let record = CKRecord(recordType: ImageObject.recordType)
                let imageObj = ImageObject(record: record)
                if let height = image.height { imageObj.height.value = height }
                if let width = image.width { imageObj.width.value = width }
                if let url = image.url { imageObj.url.value = url }
                newUser.images.value = imageObj
                recordsToSave.append(imageObj)
                
            }
            if let product = user.product { newUser.product.value = product }
            if let type = user.type { newUser.type.value = type }
            if let uri = user.uri { newUser.uri.value = uri }
//            let record = CKRecord(recordType: UsersObject.recordType)
//            let followingObj = [UsersObject(record: record)]
//            newUser.following.
            self.userObject = newUser
            recordsToSave.append(contentsOf: [newUser])
            saveData(database: publicDB)
        }
    }
    
    //MARK:- Following
    func setNewFollowing(followingId: String) {
        let predicate = NSPredicate(format: "id == %@", followingId)
        
        let query = CKQuery(recordType: "UserType", predicate: predicate)
        fetch(query: query) { (answer) in
                    switch answer {
                    case .successful(let results):
                        guard let results = results else {
                            return
                        }
                        if let userObject = self.userObject {
                            let user = UsersObject(record: results[0])
                            if !userObject.following.contains(user) {
                                userObject.following.append(user, action: .none)
//                                user.followers.append(userObject, action: .none)
                            } else {
                                let indexFollowing = userObject.following.firstIndex(of: user)
                                let indexFollowers = user.followers.firstIndex(of: userObject)
                                
                                if let indexFollowing = indexFollowing, let indexFollowers = indexFollowers {
                                    userObject.following.remove(at: indexFollowing)
                                    user.followers.remove(at: indexFollowers)
                                }
                            }
                            self.recordsToSave.append(userObject)
//                            self.recordsToSave.append(user)
                            self.saveData(database: self.publicDB)
                        }
                        break
                    case .fail(let err, let desc):
                        DataController.errorHandler(error: err)
        //                return nil
                    }
                }
    }
    
    //MARK:- Posts
    func createSimplePost(isMusic: Bool, item: MusicItem, playlistMusics: [PlaylistTracksItem]?) {
        if let userObject = self.userObject {
            
            let record = CKRecord(recordType: SimplePostObject.recordType)
            let newPost = SimplePostObject(record: record)
            let recordMusic = CKRecord(recordType: SimpleMusicObject.recordType)
            let newMusic = SimpleMusicObject(record: recordMusic)
           
            newPost.isMusic.value = isMusic ? 1 : 0
            if let url = item.images?[0].url { newPost.imageUrl.value = url }
            if let owner = item.owner?.display_name { newPost.owner.value = owner }
            //            if let name = item.name { newPost.title.value = name }
            //            if let uri = item.uri { newPost.uri.value = uri }
            if let id = item.id { newPost.id.value = id }
            newPost.sharedBy.value = self.userObject
            
            if isMusic {
                
                if let name = item.name { newMusic.title.value = name }
                if let uri = item.uri { newMusic.uri.value = uri }
                if let url = item.images?[0].url { newMusic.imageUrl.value = url }
                if let preview = item.previewURL { newMusic.previewUrl.value = preview }

                newPost.simpleMusics.append(newMusic, action: .none)
                self.recordsToSave.append(newMusic)
            
            } else {
                if let musics = playlistMusics {
                    for music in musics {
                        if let name = music.track?.name { newMusic.title.value = name }
                        if let uri = music.track?.uri { newMusic.uri.value = uri }
                        if let url = music.track?.images?[0].url { newMusic.imageUrl.value = url }
                        if let preview = music.track?.previewURL { newMusic.previewUrl.value = preview }

                        newPost.simpleMusics.append(newMusic, action: .none)
                        self.recordsToSave.append(newMusic)
                    }
                }
            }
            self.recordsToSave.append(newPost)
            self.userObject?.posts.append(newPost, action: .none)
            self.recordsToSave.append(userObject)
            self.saveData(database: publicDB)
        }
    }
    
    func getPosts(response: @escaping ([SimplePostObject]?) -> ()){
//        if let references = userObject?.following.recordReferences {
        if let references = userObject?.following.recordReferences {
            let predicate = NSPredicate(format: "sharedBy IN %@", references)
            let query = CKQuery(recordType: "SimplePost", predicate: predicate)
            var posts = [SimplePostObject]()
            fetch(query: query) { (answer) in
                        switch answer {
                        case .successful(let results):
                            guard let results = results else {
                                return
                            }
                            for result in results {
//                                let user = UsersObject(record: result)
                                let post = SimplePostObject(record: result)
                                posts.append(post)
                            }
                            response(posts)
                            break
                        case .fail(let err, let desc):
                            DataController.errorHandler(error: err)
                            response(nil)
                        }
                    }
        }
    }
    
//    func createNewPost(isMusic: Bool, item: MusicItem) {
//        let record = CKRecord(recordType: PostObject.recordType)
//        let newPost = PostObject(record: record)
//        newPost.isMusic.value = isMusic ? 1 : 0
//        newPost.author?.value = self.userObject
//        if isMusic, let userObject = self.userObject {
//            //Music
//            let musicRecord = CKRecord(recordType: MusicItemObject.recordType)
//            let newItem = MusicItemObject(record: musicRecord)
//            if let href = item.href { newItem.href.value = href }
//            if let id = item.id { newItem.id.value = id }
//            if let name = item.name { newItem.name.value = name }
//            if let preview = item.previewURL { newItem.previewUrl.value = preview}
//            newItem.type.value = "track"
//            if let uri = item.uri {newItem.uri.value = uri }
//
//            //Music - Album
//            let albumRecord = CKRecord(recordType: AlbumObject.recordType)
//            let newAlbum = AlbumObject(record: albumRecord)
//            if let href = item.album?.href { newAlbum.href.value = href }
//            if let id = item.album?.id { newAlbum.id.value = id }
//            if let name = item.album?.name { newAlbum.name.value = name }
//            if let totalTracks = item.album?.totalTracks { newAlbum.totalTracks.value = totalTracks }
//            if let uri = item.album?.uri { newAlbum.uri.value = uri }
//
//            //Music - Album - artist = PEGANDO SO UM E BOA
//            let artistRecord = CKRecord(recordType: ArtistObject.recordType)
//            let newArtist = ArtistObject(record: artistRecord)
//            if let href = item.album?.artists?[0].href { newArtist.href.value = href }
//            if let id = item.album?.artists?[0].id { newArtist.id.value = id }
//            if let name = item.album?.artists?[0].name { newArtist.name.value = name }
//            if let uri = item.album?.artists?[0].uri { newArtist.uri.value = uri }
//
//            //Music - Album - artist - ExternalURL
//            let externalURLRecord = CKRecord(recordType: ExternalUrlsResponseObject.recordType)
//            let newExternal = ExternalUrlsResponseObject(record: externalURLRecord)
//            if let external = item.album?.artists?[0].external_urls?.spotify { newExternal.spotify.value = external }
//            recordsToSave.append(newExternal)
//            newArtist.external_urls?.value = newExternal
//            newAlbum.artists?.recordReferences = []
//            newAlbum.artists?.append(newArtist, action: .none)
//
//            //Music - Album - ExternalURL
//            if let external = item.album?.externalUrls?.spotify { newExternal.spotify.value = external }
//            recordsToSave.append(newExternal)
//            newAlbum.external_urls?.value = newExternal
//
//            //Music - Album - images
//            let imageRecord = CKRecord(recordType: ImageObject.recordType)
//            let newImage = ImageObject(record: imageRecord)
//            if let width = item.album?.images?[0].width { newImage.width.value = width }
//            if let height = item.album?.images?[0].height { newImage.height.value = height }
//            if let url = item.album?.images?[0].url { newImage.url.value = url }
//            recordsToSave.append(newImage)
//            newAlbum.images?.append(newImage, action: .none)
//
//            //Music - Artist
//            if let href = item.artists?[0].href { newArtist.href.value = href }
//            if let id = item.artists?[0].id { newArtist.id.value = id }
//            if let name = item.artists?[0].name { newArtist.name.value = name }
//            if let uri = item.artists?[0].uri { newArtist.uri.value = uri }
//
//            //Music - Artist - ExternalURL
//            if let external = item.artists?[0].externalUrls?.spotify { newExternal.spotify.value = external }
//
//            recordsToSave.append(newExternal)
//            recordsToSave.append(newArtist)
//            newArtist.external_urls?.value = newExternal
//            newItem.artists?.recordReferences = []
//            newItem.artists?.append(newArtist, action: .none)
//
//            //Music - ExternalURL
//            if let external = item.externalUrls?.spotify { newExternal.spotify.value = external }
//            newItem.external_urls?.value = newExternal
//            recordsToSave.append(newExternal)
//
//            //Music - Images
//            if let width = item.images?[0].width { newImage.width.value = width }
//            if let height = item.images?[0].height { newImage.height.value = height }
//            if let url = item.images?[0].url { newImage.url.value = url }
//            newItem.images?.recordReferences = []
//            newItem.images?.append(newImage, action: .none)
//            recordsToSave.append(newImage)
//
//            //Music - Owner
//            let ownerRecord = CKRecord(recordType: OwnerObject.recordType)
//            let newOwner = OwnerObject(record: ownerRecord)
//            if let href = item.owner?.href { newOwner.href.value = href }
//            if let id = item.owner?.id { newOwner.id.value = id }
//            if let name = item.owner?.display_name { newOwner.display_name.value = name }
//            if let uri = item.owner?.uri { newOwner.uri.value = uri }
//
//            //Music - Owner - ExternalURL
//            if let external = item.externalUrls?.spotify { newExternal.spotify.value = external }
//            newOwner.external_urls?.value = newExternal
//            newItem.owner?.value = newOwner
//            recordsToSave.append(newExternal)
//            recordsToSave.append(newOwner)
//
//            newPost.musicItem?.value = newItem
//            self.userObject?.posts.recordReferences = []
////            self.userObject?.posts.
//            self.userObject?.posts.append(newPost, action: .none)
//            self.recordsToSave.append(newItem)
//            self.recordsToSave.append(newPost)
//            self.recordsToSave.append(userObject)
//            self.saveData(database: publicDB)
//        }
//    }

    
    // MARK: Fetching
    private func fetchUserID(completionHandler: @escaping (DataFetchAnswer) -> Void) {
        container.fetchUserRecordID { (userID, error) in
            self.usuarioID = userID
            if let error = error as? CKError {
                DispatchQueue.main.async {
                    completionHandler(.fail(error: error, description:
                        "Erro no Query da Cloud - Fetch: \(String(describing: error))"))
                }
                return
            }
            completionHandler(.successful(results: nil))
        }
    }

    private func fetch(recordType: String, completionHandler: @escaping (DataFetchAnswer) -> Void) {
        let predicate = NSPredicate(value: true)
        fetch(query: CKQuery(recordType: recordType, predicate: predicate), completionHandler: completionHandler)
    }

    private func fetch(query: CKQuery, completionHandler: @escaping (DataFetchAnswer) -> Void) {
        fetch(query: query, database: publicDB, completionHandler: completionHandler)
    }

    private func fetch(query: CKQuery, database: CKDatabase, completionHandler: @escaping (DataFetchAnswer) -> Void ) {
        database.perform(query, inZoneWith: nil) { (results, error) in
            if let error = error as? CKError {
                DispatchQueue.main.async {
                    completionHandler(.fail(error: error, description:
                        "Erro no Query da Cloud - Fetch: \(String(describing: error))"))
                }
                return
            }

            DispatchQueue.main.async {
                completionHandler(.successful(results: results))
            }
        }
    }
}

extension UsersObject {
    fileprivate convenience init(user: UserResponse) {
        let record = CKRecord(recordType: UsersObject.recordType)
        self.init(record: record)
    }
}
