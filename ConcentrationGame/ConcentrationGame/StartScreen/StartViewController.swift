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
        setupSegmentControl()
    }
    
    func setupSegmentControl() {
        let gradientImage = gradient(size: difficultySC.frame.size, color: [UIColor.green, UIColor.red])!
        difficultySC.backgroundColor = UIColor(patternImage: gradientImage)
        
        let notSelectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        difficultySC.setTitleTextAttributes(notSelectedTitleTextAttributes, for: .normal)
        
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        difficultySC.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        
//        difficultySC.layer.borderColor = UIColor.black.cgColor
//        difficultySC.selectedSegmentTintColor = UIColor.white
//        difficultySC.layer.borderWidth = 3
    }
    
    func gradient(size:CGSize,color:[UIColor]) -> UIImage?{
        //turn color into cgcolor
        let colors = color.map{$0.cgColor}
        //begin graphics context
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        // From now on, the context gets ended if any return happens
        defer {UIGraphicsEndImageContext()}
        //create core graphics context
        let locations:[CGFloat] = [0.0,1.0]
        guard let gredient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as NSArray as CFArray, locations: locations) else {
            return nil
        }
        //draw the gradient
        context.drawLinearGradient(gredient, start: CGPoint(x:0.0,y:size.height), end: CGPoint(x:size.width,y:size.height), options: [])
        // Generate the image (the defer takes care of closing the context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    @IBAction func difficultyChanged(_ sender: UISegmentedControl) {
        switch difficultySC.selectedSegmentIndex {
        case 0:
            difficulty = .easy
        case 1:
            difficulty = .medium
        case 2:
            difficulty = .hard
        case 3:
            difficulty = .extreme
        default:
            print("Error")
        }
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.gameVCIdentifier) as! GameViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .partialCurl
        vc.difficulty = self.difficulty
        self.present(vc, animated: true, completion: nil)
    }

}
