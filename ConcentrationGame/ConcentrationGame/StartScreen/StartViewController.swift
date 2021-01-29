//
//  StartViewController.swift
//  ConcentrationGame
//
//  Created by Anton Melnychuk on 21.01.2021.
//

import UIKit

class StartViewController: UIViewController {

    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var difficultySC: UISegmentedControl!
    
    var difficulty: DifficultyMode = .easy
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func difficultyChanged(_ sender: UISegmentedControl) {
        switch difficultySC.selectedSegmentIndex {
        case 0:
            difficulty = .easy
        case 1:
            difficulty = .medium
        case 2:
            difficulty = .hard
        default:
            print("Error")
        }
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.gameVCIdentifier) as! GameViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        vc.difficulty = self.difficulty
        self.present(vc, animated: true, completion: nil)
    }

}
