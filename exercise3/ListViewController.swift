//
//  ListViewController.swift
//  exercise3
//
//  Created by Claire Lee on 11/8/22.
//


import UIKit

class ListViewController: UIViewController{
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    
    @IBOutlet weak var myTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myTableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if myTableView.isEditing{
            myTableView.setEditing(false, animated: true)
            sender.title = "Edit"
            editButtonItem.isEnabled = true
        }else{
            myTableView.setEditing(true, animated: true)
            sender.title = "Done"
            editButtonItem.isEnabled = false
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            
        case "showItem":
            if let row = myTableView.indexPathForSelectedRow?.row {
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
                detailViewController.itemStore = itemStore
            }
        case "addItem":
            if let selectedIndexpath = myTableView.indexPathForSelectedRow{
                myTableView.deselectRow(at: selectedIndexpath, animated: true)
            }
            let item = Item(question: "", answer: "")
            
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.item = item
            detailViewController.imageStore = imageStore
            detailViewController.itemStore = itemStore
        default:
            preconditionFailure("Unexpected segue identifier.")
            
        }
    }
        
    
    

}
extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print("numberOfRowsInSection")
        return itemStore.allItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        print("cellForRowAt", indexPath.row, itemStore.allItems[indexPath.row])
        let item = itemStore.allItems[indexPath.row]
        myCell.textLabel!.text = item.question
        myCell.detailTextLabel!.text = item.answer
        return myCell
    }
    func reset(){
        itemStore.mcqChanged = true
        itemStore.numChanged = true
        itemStore.scoreChanged = true
        Items.sharedInstance.wrong = 0
        Items.sharedInstance.correct = 0
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            itemStore.allItems.remove(at: indexPath.row)
            imageStore.deleteImage(forKey: item.itemKey)
            tableView.deleteRows(at: [indexPath], with: .fade)
            reset()
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
        if(sourceIndexPath.row != destinationIndexPath.row){
            reset()
        }
    }
}

