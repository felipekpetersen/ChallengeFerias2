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
        fetch(query: query) { (answer) in
            switch answer {
            case .successful(let results):
                if results?.count ?? 0 < 1 {
                    self.createUser(user: user)
                }
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
            recordsToSave.append(contentsOf: [newUser])
            saveData(database: publicDB)
        }
    }
    
    //MARK:- Following
    func setNewFollowing(userId: String) {
        
    }
    
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
