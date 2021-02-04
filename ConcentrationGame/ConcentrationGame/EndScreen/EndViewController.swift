//
//  EndViewController.swift
//  ConcentrationGame
//
//  Created by Anton Melnychuk on 21.01.2021.
//

import UIKit

class EndViewController: UIViewController {
    
    var difficulty: DifficultyMode!
    var numberOfCards: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func restartButtonPressed(_ sender: UIButton) {
        guard let number = numberOfCards else { return }
        guard let difficulty = difficulty else { return }
        restartGameWithMode(difficulty, andNuberOfCards: number)
    }
    
    @IBAction func homeButtonPressed(_ sender: UIButton) {
        presentStartScreen()
    }
    
    private func presentStartScreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.startVCIdentifier) as! StartViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        self.present(vc, animated: true, completion: nil)
    }
    
    private func restartGameWithMode(_ mode: DifficultyMode, andNuberOfCards number: Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.gameVCIdentifier) as! GameViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        vc.difficulty = mode
        vc.numberOfCards = number
        self.present(vc, animated: true, completion: nil)
    }
    
}
