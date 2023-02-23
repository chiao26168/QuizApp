//
//  CanvasViewController.swift
//  exercise3
//
//  Created by Claire Lee on 11/9/22.
//

import UIKit

class CanvasViewController: UIViewController {
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    var item: Item!
    
    @IBOutlet var drawView: DrawView!


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray6
    
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        drawView.item = item
        drawView.imageStore = imageStore
        drawView.itemStore = itemStore
        drawView.finishedLines = item.myLine
        drawView.start()
    }
    func reset(){
        itemStore.mcqChanged = true
        itemStore.numChanged = true
        itemStore.scoreChanged = true
        Items.sharedInstance.wrong = 0
        Items.sharedInstance.correct = 0
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        print("morning")
        if (drawView.finishedLines.count != 0) {
            item.photo = false
            item.canvas = true
            let image = view.asImage()
            imageStore.setImage(image, forKey: item.itemKey)
            if item.myLine.count != drawView.finishedLines.count {
                reset()
            }
            item.myLine = drawView.finishedLines
        }
        navigationController?.popViewController(animated: true)
    }
}
