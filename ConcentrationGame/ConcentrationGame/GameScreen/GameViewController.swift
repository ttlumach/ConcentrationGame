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
    static let width = CGFloat(60)
    static let height = CGFloat(40)
}

enum DifficultyMode {
    case easy
    case medium
    case hard
    case extreme
    case hardcore
}

class GameViewController: UIViewController {

    @IBOutlet weak var cardsStackView: UIStackView!
    
    @IBOutlet weak var cardsView: UIView!
    
    private var cardsStackViewsArray: [UIStackView] = []
    
    lazy var concentrationGame = Concentration(elementsCount: numberOfCards)
    var buttons: [UIButton] = []
    
    var previousButton: UIButton? = nil
    var cards: [UIButton:Card] = [:]
    
    var difficulty: DifficultyMode = .easy
    var numberOfCards: Int = 10
    
    lazy var animator = UIDynamicAnimator(referenceView: cardsView)
    lazy var cardBehavior = CardBehavior(animator: animator)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startGame()
        makeCardsStackViewsCorrect()
    }
    
    //MARK: Cards Stack View correcting
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard difficulty != DifficultyMode.extreme else { return }
        makeCardsStackViewsCorrect()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if difficulty == .extreme {
            return .portrait
        } else {
            return .all
        }
    }
    
    func makeCardsStackViewsCorrect() {
        if cardsStackViewsArray.count < 5 { // 5 elements in row(stack view)(static) chek if heigth < width
            
            if view.traitCollection.verticalSizeClass == .compact {
                cardsStackView.axis = .vertical
                for stackView in cardsStackViewsArray {
                    stackView.axis = .horizontal
                }
            } else {
                
                cardsStackView.axis = .horizontal
                for stackView in cardsStackViewsArray {
                    stackView.axis = .vertical
                }
            }
        } else {
            
            if view.traitCollection.verticalSizeClass == .compact {
                cardsStackView.axis = .horizontal
                for stackView in cardsStackViewsArray {
                    stackView.axis = .vertical
                }
            } else {
                cardsStackView.axis = .vertical
                for stackView in cardsStackViewsArray {
                    stackView.axis = .horizontal
                }
            }
        }
    }
    
    
    //MARK: Setup Game
    
    func setupCards() {
        for _ in 0..<numberOfCards / 5 {
            
            let stackView = UIStackView()
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = 5
            
            for _ in 0..<5 {
                let button = UIButton()
                button.backgroundColor = colors.cardBackgroundColor
                button.setTitleColor(colors.cardTextColor, for: .normal)
                button.isExclusiveTouch = true
                buttons.append(button)
                button.addTarget(self, action: #selector(GameViewController.cardPressed(_:)), for: .touchUpInside)
                button.aspectRatio(1).isActive = true
                stackView.addArrangedSubview(button)
                
            }
            
            cardsStackViewsArray.append(stackView)
            cardsStackView.addArrangedSubview(stackView)
        }
        
        for index in 0..<buttons.count {
            cards[buttons[index]] = concentrationGame.cards[index]
        }
    }
    
    func setupCardsForExtreme() {
        
        for _ in 0..<numberOfCards {
            let button = UIButton()
            button.backgroundColor = colors.cardBackgroundColor
            button.setTitleColor(colors.cardTextColor, for: .normal)
            button.addTarget(self, action: #selector(GameViewController.cardPressed(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.frame = CGRect(x: self.view.bounds.midX , y: self.view.bounds.midY, width: cardSize.width, height: cardSize.height)
            button.isExclusiveTouch = true
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
    
    //MARK: Animation
    
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
    
    //MARK: Businness logic
    
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
        vc.difficulty = difficulty
        vc.numberOfCards = numberOfCards
        self.present(vc, animated: true, completion: nil)
    }
    
    func checkForGameEnd(){
        if concentrationGame.isGameEnd {
            endGame()
        }
    }
    
    //MARK: Actions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.startVCIdentifier) as! StartViewController
        vc.modalTransitionStyle = .crossDissolve
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
                        case .medium:
                            self.animateMatchCard(key) {_ in
                                let height = self.cardsStackView.frame.size.height
                                key.removeFromSuperview()
                                self.cardsStackView.frame.size.height = height
                            }
                        case .hard:
                            self.animateMatchCard(key) {_ in
                                key.backgroundColor = colors.cardBackgroundColor
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

