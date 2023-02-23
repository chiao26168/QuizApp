//
//  NumViewController.swift
//  exercise3
//
//  Created by Claire Lee on 11/8/22.
//


import UIKit

class NumViewController: UIViewController, UITextFieldDelegate{
    var itemStore: ItemStore!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var answerTextField: UITextField!

    @IBOutlet var imageView: UIImageView!
    var imageStore: ImageStore!
    
    
    var currentQuestionIndex: Int = 0
    var currentAnswerIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.answerTextField.delegate = self
        if itemStore.allItems.count == 0 {
            noAnswer()
        } else{
            resetForm()
            answerTextField.isUserInteractionEnabled = true
            currentQuestionIndex = 0
            questionLabel.text = itemStore.allItems[currentQuestionIndex].question
            itemStore.numChanged = false
            
            let key = itemStore.allItems[currentQuestionIndex].itemKey
            let imageToDisplay = imageStore.image(forKey: key)
            imageView.image = imageToDisplay
            imageView.isHidden = false
        }
        
        
    }
    func noAnswer() {
        questionLabel.text = "Loading ..."
        correctLabel.isHidden = true
        errorLabel.isHidden = true
        submitButton.isHidden = true
        nextButton.isHidden = true
        answerTextField.isHidden = true
        imageView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (itemStore.numChanged == true) {
            if itemStore.allItems.count == 0 {
                noAnswer()
            }
            else {
                resetForm()
                answerTextField.isUserInteractionEnabled = true
                currentQuestionIndex = 0
                questionLabel.text = itemStore.allItems[currentQuestionIndex].question
                itemStore.numChanged = false
                let key = itemStore.allItems[currentQuestionIndex].itemKey
                let imageToDisplay = imageStore.image(forKey: key)
                imageView.image = imageToDisplay
                imageView.isHidden = false
            }
        }
        itemStore.numChanged = false
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func textChanged(_ sender: UITextField) {
        print(sender.text!)
        if !isValid(text: sender.text!){
            submitButton.isEnabled = false
            nextButton.isEnabled = false
            errorLabel.isHidden = false
        }
        else{
            submitButton.isEnabled = true
            errorLabel.isHidden = true
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        print("Submit")
        submitButton.isEnabled = false
        
        errorLabel.isHidden = true
        answerTextField.isUserInteractionEnabled = false
        if currentQuestionIndex == itemStore.allItems.count - 1{
            nextButton.isEnabled = false
        }
        else{
            nextButton.isEnabled = true
        }
        if answerTextField.text == itemStore.allItems[currentQuestionIndex].answer {
            correctLabel.text = "CORRECT"
            correctLabel.textColor = UIColor.systemMint
            correctLabel.isHidden = false
            Items.sharedInstance.correct += 1
            print(Items.sharedInstance.correct)
        }else{
            correctLabel.text = "INCORRECT"
            correctLabel.textColor = UIColor.systemPink
            correctLabel.isHidden = false
            Items.sharedInstance.wrong += 1
            print(Items.sharedInstance.wrong)
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        print("Next")
        currentQuestionIndex += 1
        nextButton.isEnabled = false
        if currentQuestionIndex < itemStore.allItems.count {
            let question: String = itemStore.allItems[currentQuestionIndex].question
            questionLabel.text = question
            resetForm()
            answerTextField.isUserInteractionEnabled = true
            let key = itemStore.allItems[currentQuestionIndex].itemKey
            let imageToDisplay = imageStore.image(forKey: key)
            imageView.image = imageToDisplay
        }
    }
    
    func resetForm(){
        submitButton.isEnabled = false
        submitButton.isHidden = false
        nextButton.isEnabled = false
        nextButton.isHidden = false
        answerTextField.text = ""
        answerTextField.isHidden = false
        errorLabel.isHidden = true
        correctLabel.isHidden = true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789-.").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
        
    }
    func isValid(text: String) -> Bool{
        let nf = NumberFormatter()
        nf.numberStyle = .none
        let x = nf.number(from: text)?.intValue
        if x == nil{
            print("fewf")
            return false
        }
        else{
            return true
        }
    }

}
