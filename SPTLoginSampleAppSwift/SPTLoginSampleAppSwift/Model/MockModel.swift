//
//  MockModel.swift
//  Synchs
//
//  Created by Felipe Petersen on 02/02/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import Foundation

class MockModel {
    var musicName: String?
    var artist: String?
    var albumImage: String?
    var gender: [String]?
    var type: HomeCellType?
    
    func getModel() -> [MockModel] {
        var model = [MockModel]()
        
        let model1 = MockModel()
        model1.musicName = "Dance Monkey"
        model1.artist = "Tones and I"
        model1.gender = ["Pop"]
        model1.type = .music
        model1.albumImage = "placeholder_dance"
        model.append(model1)
        
        let model2 = MockModel()
        model2.musicName = "Circles"
        model2.artist = "Post Malone"
        model2.gender = ["Pop", "Rap"]
        model2.type = .music
        model2.albumImage = "placeholder_circles"
        model.append(model2)
        
        let model3 = MockModel()
        model3.musicName = "Yellow Hearts"
        model3.artist = "Ant Saunders"
        model3.gender = ["Pop"]
        model3.type = .music
        model3.albumImage = "placeholder_yellow"
        model.append(model3)
        
        let model4 = MockModel()
        model4.musicName = "Combatchy"
        model4.artist = "Anitta, Lexa, Luísa Sonza"
        model4.gender = ["Funk"]
        model4.type = .music
        model4.albumImage = "placeholder_combatchy"
        model.append(model4)
        
        let model5 = MockModel()
        model5.musicName = "Tudo Ok"
        model5.artist = "Thiaguinho MT"
        model5.gender = ["Funk"]
        model5.type = .music
        model5.albumImage = "placeholder_ok"
        model.append(model5)
        
        let model6 = MockModel()
        model6.musicName = "Eu não matei Joana d'Arc"
        model6.artist = "Camisa de Vênus"
        model6.gender = ["Rock Nacional"]
        model6.type = .music
        model6.albumImage = "placeholder_joana"
        model.append(model6)
        
        let model7 = MockModel()
        model7.musicName = "Vou deixar"
        model7.artist = "Skank"
        model7.gender = ["Rock Nacional", "Pop Nacional"]
        model7.type = .music
        model7.albumImage = "placeholder_deixar"
        model.append(model7)
        
        let model8 = MockModel()
        model8.musicName = "Memories"
        model8.artist = "Maroon 5"
        model8.gender = ["Pop"]
        model8.type = .music
        model8.albumImage = "placeholder_memories"
        model.append(model8)

        return model
    }
}

