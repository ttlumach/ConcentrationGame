//
//  ViewController.swift
//  ConcentrationGame
//
//  Created by Anton Melnychuk on 21.01.2021.
//

import UIKit

enum Constants {
    static let startVCIdentifier = "StartViewController"
    static let endVCidentifier = "EndViewController"
    static let gameVCIdentifier = "GameViewController"
}

enum colors {
    static let cardBackgroundColor = UIColor.orange
    static let cardTextColor = UIColor.black
    static let cardFaceColor = UIColor.yellow
    static let cardMatchedColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0)
}

enum DifficultyMode: Int {
    case easy = 10
    case medium = 20
    case hard = 40
}

class GameViewController: UIViewController {

    @IBOutlet weak var cardsStackView: UIStackView!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    
    lazy var concentrationGame = Concentration(elementsCount: difficulty.rawValue)
    var buttons: [UIButton] = []
    
    var previousButton: UIButton? = nil
    var cards: [UIButton:Card] = [:]
    
    var difficulty: DifficultyMode = .easy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackViewHeight.constant = stackViewHeight.constant * CGFloat(difficulty.rawValue) / CGFloat(10.0)
        startGame()
    }
    
    func lockAllButtons() {
        for button in buttons {
            button.isEnabled = false
        }
    }
    
    func enableAllButtons() {
        for button in buttons {
            button.isEnabled = true
        }
    }
    
    func lockButton(button: UIButton) {
        button.isEnabled = false
        
    }
    
    func enableButton(button: UIButton) {
        button.isEnabled = true
    }
    
    func startGame() {
        setupCards()
    }
    
    func endGame()  {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.endVCidentifier) as! EndViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func checkForGameEnd(){
        if concentrationGame.isGameEnd {
            endGame()
        }
    }

    func setupCards() {
        
        concentrationGame.createCards()
        
        for _ in 0..<difficulty.rawValue / 5 {
            
            let stackView = UIStackView()
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = 5
            
            for _ in 0..<5 {
                let button = UIButton()
                button.backgroundColor = colors.cardBackgroundColor
                button.setTitleColor(colors.cardTextColor, for: .normal)
                buttons.append(button)
                button.addTarget(self, action: #selector(GameViewController.cardPressed(_:)), for: .touchUpInside)
                stackView.addArrangedSubview(button)
            }
            cardsStackView.addArrangedSubview(stackView)
        }
        
        for index in 0..<buttons.count {
            cards[buttons[index]] = concentrationGame.cards[index]
        }
    }
    
    func animateFlipToFaceCard(_ button: UIButton, withId id: Int) {
        UIView.transition(with: button, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            button.backgroundColor = colors.cardFaceColor
            button.setTitle(String(id), for: .normal)
        }, completion: nil)
    }
    
    func animateFlipToBackCard(_ button: UIButton){
        UIView.transition(with: button, duration: 0.4, options: .transitionFlipFromLeft, animations: {
            button.backgroundColor = colors.cardBackgroundColor
            button.setTitle("", for: .normal)
        }, completion: nil)
    }
    
    func animateMatchCard(_ button: UIButton) {
        UIView.transition(with: button, duration: 0.5, options: .transitionCurlDown, animations: {
            button.backgroundColor = colors.cardMatchedColor
            button.setTitle("", for: .normal)
        }, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.startVCIdentifier) as! StartViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func cardPressed(_ sender: UIButton) {
        
        let pickedCard = cards[sender]!
        concentrationGame.chooseCard(pickedCard)
        
        if concentrationGame.lastPickedCard.isMatched { //Matched
            
            animateFlipToFaceCard(sender, withId: pickedCard.id)
            
            for (key, value) in cards {
                if value.id == pickedCard.id {
                    lockAllButtons()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        key.isUserInteractionEnabled = false
                        self.animateMatchCard(key)
                        self.enableAllButtons()
                    }
                }
            }
            previousButton = nil
            checkForGameEnd()
        } else {
            if concentrationGame.facedUpCardToPair != nil{ // 1 card on board
                animateFlipToFaceCard(sender, withId: pickedCard.id)
                lockButton(button: sender)
                previousButton = sender
            } else { //failed to match
                
                animateFlipToFaceCard(sender, withId: pickedCard.id)
                lockAllButtons()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.animateFlipToBackCard(sender)
                    self.animateFlipToBackCard(self.previousButton!)
                    
                    self.previousButton = nil
                    self.enableAllButtons()
                }
                
            }
        }
    }
    

}

