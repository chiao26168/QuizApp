//
//  Item.swift
//  exercise3
//
//  Created by Claire Lee on 11/8/22.
//

import UIKit

class Item: Equatable, Codable {

    var question: String
    var answer: String
    var date: String
    let itemKey: String
    var myLine: [Line]
    var tempAnswer = ""
    var tempQuestion = ""
    var photo = false
    var canvas = false
    
    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.date = dateFormatter.string(from: date)
        self.itemKey = UUID().uuidString

        self.myLine = [Line]()
    }

    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.question == rhs.question && lhs.answer == rhs.answer
    }
    
}
