//
//  McqViewController.swift
//  exercise3
//
//  Created by Claire Lee on 11/8/22.
//


import UIKit

class McqViewController: UIViewController {
    var itemStore: ItemStore!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var myPicker: UIPickerView!
    
    @IBOutlet weak var correctLabel: UILabel!
    
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    let myQuestion = ["1  +  1  =  ? ", "2  +  2  =  ? ", "3  +  3  =  ? "]
    let myAnswer = ["2", "4", "6"]
    let optionArray = [["1", "2", "3", "4"], ["4", "5", "6", "7"], ["6", "7", "8", "9"]]
    
    var currAnswer: String = ""
    var currentQuestionIndex: Int = 0
    var currentAnswerIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myPicker.delegate = self
        myPicker.dataSource = self
        questionLabel.text = myQuestion[currentQuestionIndex]
        nextButton.isEnabled = false
        resetForm()
    }
    func resetForm(){
        submitButton.isEnabled = false
        nextButton.isEnabled = false
        correctLabel.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(itemStore.mcqChanged == true){
            resetForm()
            myPicker.isUserInteractionEnabled = true
            myPicker.reloadComponent(0)
            currentQuestionIndex = 0
            questionLabel.text = myQuestion[currentQuestionIndex]
            itemStore.mcqChanged = false
        }
        
    }

    
    @IBAction func submitButtonPressed(_ sender: Any) {
        print("Submit button pressed.")
        submitButton.isEnabled = false
        myPicker.isUserInteractionEnabled = false
        nextButton.isEnabled = true
        if currentQuestionIndex == myQuestion.count - 1{
            nextButton.isEnabled = false
        }
        else{
            nextButton.isEnabled = true
        }
        if currAnswer == myAnswer[currentQuestionIndex]{
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
        if currentQuestionIndex < myQuestion.count {
            let question: String = myQuestion[currentQuestionIndex]
            questionLabel.text = question
            resetForm()
            myPicker.reloadComponent(0)
            myPicker.isUserInteractionEnabled = true
        }
    }
    
}
extension McqViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return optionArray[currentQuestionIndex].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return optionArray[currentQuestionIndex][row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if optionArray[currentQuestionIndex][row] == myAnswer[currentQuestionIndex]{
            print("Correct")
        }
        else{
            print("Wrong")
        }
        if currentQuestionIndex == myQuestion.count - 1{
            nextButton.isEnabled = false
        }
        currAnswer = optionArray[currentQuestionIndex][row]
        submitButton.isEnabled = true
    }
}

