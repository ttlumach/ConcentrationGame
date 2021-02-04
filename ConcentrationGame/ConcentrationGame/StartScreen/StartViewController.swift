//
//  StartViewController.swift
//  ConcentrationGame
//
//  Created by Anton Melnychuk on 21.01.2021.
//

import UIKit

class StartViewController: UIViewController {
    
    enum Colors {
        static let eazy = UIColor(red: 0.01, green: 0.49, blue: 0.31, alpha: 1.00)
        static let medium = UIColor(red: 0.80, green: 0.80, blue: 0.00, alpha: 1.00)
        static let hard = UIColor.orange
        static let extreme = UIColor.red
    }
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var difficultySC: UISegmentedControl!
    @IBOutlet weak var numberOfCardsSegmControl: UISegmentedControl!
    
    var difficulty: DifficultyMode = .easy
    var numberOfCards: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.setTitleColor(Colors.eazy, for: .normal)
        setupSegmentControls()
    }
    
    func setupSegmentControls() {
        var gradientImage = gradient(size: difficultySC.frame.size, color: [UIColor.green, UIColor.red])!
        difficultySC.backgroundColor = UIColor(patternImage: gradientImage)
        
        var notSelectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        difficultySC.setTitleTextAttributes(notSelectedTitleTextAttributes, for: .normal)
        
        var selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        difficultySC.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        
        gradientImage = gradient(size: numberOfCardsSegmControl.frame.size, color: [UIColor.cyan, UIColor.blue])!
        numberOfCardsSegmControl.backgroundColor = UIColor(patternImage: gradientImage)
        
        notSelectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        numberOfCardsSegmControl.setTitleTextAttributes(notSelectedTitleTextAttributes, for: .normal)
        
        selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        numberOfCardsSegmControl.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)

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
            startButton.setTitleColor(Colors.eazy, for: .normal)
        case 1:
            difficulty = .medium
            startButton.setTitleColor(Colors.medium, for: .normal)
        case 2:
            difficulty = .hard
            startButton.setTitleColor(Colors.hard, for: .normal)
        case 3:
            difficulty = .extreme
            startButton.setTitleColor(Colors.extreme, for: .normal)
        default:
            print("Error")
        }
    }
    @IBAction func numberOfCardsChanged(_ sender: UISegmentedControl) {
        guard let numberOfCards = Int(String(sender.titleForSegment(at: sender.selectedSegmentIndex)!)) else { return }
        self.numberOfCards = numberOfCards
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.gameVCIdentifier) as! GameViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.difficulty = self.difficulty
        vc.numberOfCards = numberOfCards
        self.present(vc, animated: true, completion: nil)
    }

}
