//
//  ConcentrationModel.swift
//  ConcentrationGame
//
//  Created by Anton Melnychuk on 22.01.2021.
//

import Foundation

class Concentration {
    private var countOfPairs: Int
    var cards:[Card] = []
    
    var facedUpCardToPair: Card? = nil
    var lastPickedCard: Card!
    
    var isGameEnd = false
    
    init(elementsCount: Int) {
        countOfPairs = (elementsCount + 1) / 2
    }
    
    func createCards() {
        for index in 0..<countOfPairs {
            let card1 = Card(content: "&&", id: index)
            let card2 = Card(content: "&&", id: index)
            cards.append(card1)
            cards.append(card2)
            
            cards.shuffle()
        }
    }
    
    func chooseCard(_ card: Card) {
        
        self.lastPickedCard = card
        lastPickedCard.rotateCard()
        
        if facedUpCardToPair != nil {
            
            if canMatch(facedUpCardToPair!, and: lastPickedCard) {
                matchCards(facedUpCardToPair!, lastPickedCard)
                isGameEnd = isGameEnded()
            } else {
                lastPickedCard.rotateCard()
                facedUpCardToPair!.rotateCard()
            }
            facedUpCardToPair = nil
        } else {
            facedUpCardToPair = lastPickedCard
        }
        
    }
    
    private func canMatch(_ firstCard: Card, and secondCard: Card) -> Bool {
        if firstCard.id == secondCard.id {
            return true
        } else {
            return false
        }
    }
    
    private func matchCards(_ firstCard: Card, _ secondCard: Card) {
        firstCard.matchCard()
        secondCard.matchCard()
    }
    
    private func isGameEnded() -> Bool {
        for card in cards {
            if !card.isMatched {
                return false
            }
        }
        return true
    }
    
}
