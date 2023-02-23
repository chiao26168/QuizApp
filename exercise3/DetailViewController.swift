//
//  DetailViewController.swift
//  exercise3
//
//  Created by Claire Lee on 11/8/22.
//

import UIKit
class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    var originQuestion: String!
    var originAnswer: String!

    var tabBarControllerItems: [UITabBarItem]?
    
    @IBOutlet var trashButton: UIBarButtonItem!
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var drawButton: UIBarButtonItem!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var questionField: UITextField!
    @IBOutlet var answerField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        // new item
        
        if item.question == "" && item.answer == "" {
            itemStore.allItems.append(item)
            print("Create New Question and Answer")
        }
        cameraButton.isEnabled = true
        drawButton.isEnabled = true
        
        item.question = questionField.text ?? ""
        item.answer = answerField.text ?? ""
        item.tempQuestion = ""
        item.tempAnswer = ""
        print(item.question)
        print(item.answer)
        reset()
        saveButton.isEnabled = false
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        print("Image Picker Conptoller")
        let image = info[.originalImage] as! UIImage
        imageView.image = image
        self.item.photo = true
        self.item.canvas = false
        self.item.myLine.removeAll()
        reset()
        trashButton.isEnabled = true
        imageStore.setImage(image, forKey: item.itemKey)

        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.answerField.delegate = self
        self.questionField.delegate = self
        tabBarControllerItems = self.tabBarController?.tabBar.items
        print("viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // setup
        saveButton.isEnabled = false
        cameraButton.isEnabled = false
        drawButton.isEnabled = false
        trashButton.isEnabled = false
        questionField.text = item.question
        answerField.text = item.answer
//        print(item.tempQuestion)
//        print(item.tempAnswer)
//        if item.tempQuestion != "" {
//            questionField.text = item.tempQuestion
//        }
//        else {
//
//        }
//        if item.tempAnswer != "" {
//            answerField.text = item.tempAnswer
//        }
//        else {
//            answerField.text = item.answer
//        }
//        if item.tempQuestion != "" && item.tempAnswer != "" {
//            saveButton.isEnabled = true
//            item.tempQuestion = ""
//            item.tempAnswer = ""
//        }
        dateLabel.text = item.date
        let key = item.itemKey
        let imageToDisplay = imageStore.image(forKey: key)
        imageView.image = imageToDisplay

        //compare
        originQuestion = item.question
        originAnswer = item.answer
        
        if questionField.text != "" && answerField.text != "" {
            cameraButton.isEnabled = true
            drawButton.isEnabled = true
        }
        if imageView.image != nil {
            trashButton.isEnabled = true
        }
        
    }
    
    
    @IBAction func trashButtonPressed(_ sender: UIBarButtonItem) {
        item.photo = false
        item.canvas = false
        imageView.image = nil
        imageStore.deleteImage(forKey: item.itemKey)
        item.myLine.removeAll()
        reset()
        trashButton.isEnabled = false
    }
    
    
    @IBAction func choosePhotoSource(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.barButtonItem = sender
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                let imagePicker = self.imagePicker(for: .camera)
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            let imagePicker = self.imagePicker(for: .photoLibrary)
            imagePicker.modalPresentationStyle = .popover
            imagePicker.popoverPresentationController?.barButtonItem = sender
            self.present(imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(photoLibraryAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func QuestionTextChanged(_ sender: UITextField) {
        print(sender.text!)
        item.tempQuestion = sender.text!
        if originQuestion != sender.text! && answerField.text != "" && questionField.text != "" {
            saveButton.isEnabled = true
//            cameraButton.isEnabled = true
//            drawButton.isEnabled = true
        }
        else{
//            if answerField.text == "" || questionField.text == "" {
//                cameraButton.isEnabled = false
//                drawButton.isEnabled = false
//            }
            saveButton.isEnabled = false
        }
    }
    
    @IBAction func AnswerTextChanged(_ sender: UITextField) {
        print(sender.text!)
        item.tempAnswer = sender.text!
        if originAnswer != sender.text! && answerField.text != "" && questionField.text != "" {
            saveButton.isEnabled = true

        }
        else{

            saveButton.isEnabled = false
        }
    }

    var item: Item! {
        didSet {
            navigationItem.title = item.question
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "myCanvas":
            let canvasView = segue.destination as! CanvasViewController
            canvasView.item = item
            canvasView.imageStore = imageStore
            canvasView.itemStore = itemStore
            
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    func reset(){
        itemStore.mcqChanged = true
        itemStore.numChanged = true
        itemStore.scoreChanged = true
        Items.sharedInstance.wrong = 0
        Items.sharedInstance.correct = 0
    }
    
    func imagePicker(for sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        return imagePicker
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789+-*/.=? ").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    
}
