//
//  Picture.swift
//  Project-3
//
//  Created by Sheena on 18/02/22.
//

import Foundation

class Picture: Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}


