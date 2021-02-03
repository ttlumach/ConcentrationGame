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

enum cardSize {
    static let width = CGFloat(40)
    static let height = CGFloat(20)
}

enum DifficultyMode: Int {
    case easy = 15
    case medium = 20
    case hard = 30
    case extreme = 8
    case hardcore = 45
}

class GameViewController: UIViewController {

    @IBOutlet weak var cardsStackView: UIStackView!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cardsView: UIView!
    
    lazy var concentrationGame = Concentration(elementsCount: difficulty.rawValue)
    var buttons: [UIButton] = []
    
    var previousButton: UIButton? = nil
    var cards: [UIButton:Card] = [:]
    
    var difficulty: DifficultyMode = .easy
    
    lazy var animator = UIDynamicAnimator(referenceView: cardsView)
    lazy var cardBehavior = CardBehavior(animator: animator)
    
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
        concentrationGame.createCards()
        setupGameMode()
    }
    
    func endGame()  {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.endVCidentifier) as! EndViewController
        vc.modalPresentationStyle = .fullScreen
        vc.gameEndWithDifficulty = difficulty
        self.present(vc, animated: true, completion: nil)
    }
    
    func checkForGameEnd(){
        if concentrationGame.isGameEnd {
            endGame()
        }
    }
    
    func setupCards() {
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
    
    func setupCardsForExtreme() {
        
        for _ in 0..<difficulty.rawValue {
            let button = UIButton()
            button.backgroundColor = colors.cardBackgroundColor
            button.setTitleColor(colors.cardTextColor, for: .normal)
            button.addTarget(self, action: #selector(GameViewController.cardPressed(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.frame = CGRect(x: self.view.bounds.midX , y: self.view.bounds.midY, width: cardSize.width, height: cardSize.height)
            buttons.append(button)
            cardsView.addSubview(button)
        }
        
        for index in 0..<buttons.count {
            cards[buttons[index]] = concentrationGame.cards[index]
        }
    }
    
    func setupEasyMode() {
        setupCards()
    }
    
    func setupMediumMode() {
        setupCards()
    }
    
    func setupHardMode() {
        setupCards()
    }
    
    func setupHardcoreMode() {
        
    }
    
    func setupExtremeMode() {
        setupCardsForExtreme()
        for button in buttons {
            cardBehavior.addItem(button)
        }
    }
    
    func setupGameMode() {
        
        switch self.difficulty {
        case .easy:
            setupEasyMode()
        case .medium:
            setupMediumMode()
        case .hard:
            setupHardMode()
        case .hardcore:
            setupHardcoreMode()
        case .extreme:
            setupExtremeMode()
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
    
    func animateMatchCard(_ button: UIButton, completion: ((Bool) -> Void)? = nil) {
        UIView.transition(with: button, duration: 0.5, options: .transitionCurlDown, animations: {
            button.backgroundColor = colors.cardMatchedColor
            button.setTitle("", for: .normal)
        }, completion: completion)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.startVCIdentifier) as! StartViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func cardPressed(_ sender: UIButton) {
        
        //choosing picked card
        let pickedCard = cards[sender]!
        concentrationGame.chooseCard(pickedCard)
        
        if concentrationGame.lastPickedCard.isMatched { //Matched(already in model)
            
            animateFlipToFaceCard(sender, withId: pickedCard.id)
            
            for (key, value) in cards {//find cards with the same ID ang remove those
                if value.id == pickedCard.id {
                    lockAllButtons()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {//need time between showing cards face and removing it
                        key.isUserInteractionEnabled = false

                        switch self.difficulty {// add animation depending on difficulty need
                        case .hard:
                            self.animateMatchCard(key) {_ in
                                key.removeFromSuperview()
                            }
                        case .extreme:
                            self.animateMatchCard(key) {_ in
                                key.isHidden = true
                                self.cardBehavior.removeItem(key)
                            }
                            
                        default:
                            self.animateMatchCard(key, completion: nil)
                        }

                        self.enableAllButtons()
                    }
                }
            }
            previousButton = nil
            checkForGameEnd()
        } else {
            if concentrationGame.facedUpCardToPair != nil{ // is the first card on board
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

