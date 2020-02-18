//
//  SearchModalViewModel.swift
//  Synchs
//
//  Created by Felipe Petersen on 17/02/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation

class ShareModalViewModel {
     
    var searchResult = SearchResponse()
    
    func getNumberOfRowsForSearch() -> Int {
        return searchResult.tracks?.items?.count ?? 0
    }
    
    func getSearchForRow(index: Int) -> MusicItem {
        return searchResult.tracks?.items?[index] ?? MusicItem()
    }
}
