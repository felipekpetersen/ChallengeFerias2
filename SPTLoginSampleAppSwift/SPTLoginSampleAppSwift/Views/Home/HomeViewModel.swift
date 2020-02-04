//
//  HomeViewModel.swift
//  Synchs
//
//  Created by Felipe Petersen on 02/02/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation

enum HomeCellType {
    case music
    case playlist
}

class HomeViewModel {
    
    var model: [MockModel]?

    func getModel() {
        self.model = MockModel().getModel()
    }
    
    func getNumberOfRows() -> Int {
        return model?.count ?? 0
    }
    
    func getMusicForRow(index: Int) -> MockModel {
        return model?[index] ?? MockModel()
    }
    
    func getCellTypeForRow(index: Int) -> HomeCellType {
        return model?[index].type ?? .music
    }
    
    
    
}
