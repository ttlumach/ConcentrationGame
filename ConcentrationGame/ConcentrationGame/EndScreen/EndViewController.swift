//
//  EndViewController.swift
//  ConcentrationGame
//
//  Created by Anton Melnychuk on 21.01.2021.
//

import UIKit

class EndViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func restartButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.gameVCIdentifier) as! GameViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        self.present(vc, animated: true, completion: nil)
    }
    
}
