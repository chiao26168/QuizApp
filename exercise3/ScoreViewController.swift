//
//  ScoreViewController.swift
//  exercise3
//
//  Created by Claire Lee on 11/8/22.
//
import UIKit

class ScoreViewController: UIViewController {

    @IBOutlet weak var yourScoreLabel: UILabel!
    
    @IBOutlet weak var currentScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SCORE")
        
        print(Items.sharedInstance.wrong)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Items.sharedInstance.wrong > Items.sharedInstance.correct {
            self.view.backgroundColor = .systemPink
        }
        else if Items.sharedInstance.wrong < Items.sharedInstance.correct {
            self.view.backgroundColor = .systemMint
        }
        else{
            self.view.backgroundColor = .systemBackground
        }
        currentScoreLabel.text = "\(Items.sharedInstance.correct) - \(Items.sharedInstance.wrong)"
    }


}
