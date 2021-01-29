//
//  Card.swift
//  ConcentrationGame
//
//  Created by Anton Melnychuk on 22.01.2021.
//

import Foundation

class Card {
    var isFacedUp = false
    let content: String
    let id: Int
    var isMatched = false
    
    init(content: String, id: Int) {
        self.content = content
        self.id = id
    }
    
    func rotateCard() {
        isFacedUp = !isFacedUp
    }
    
    func matchCard() {
        isMatched = true
    }
    
}
