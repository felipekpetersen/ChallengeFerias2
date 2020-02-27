//
//  DataActionAnswer.swift
//  Synchs
//
//  Created by Felipe Petersen on 24/02/20.
//  Copyright © 2020 Spotify. All rights reserved.
//
import CloudKit

public enum DataActionAnswer {
    case fail(error: CKError, description: String)
    case successful
}
