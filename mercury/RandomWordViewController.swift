//
//  RandomWordViewController.swift
//  mercury
//
//  Created by Stanley on 15/02/21.
//

import UIKit

class RandomWordViewController: UIViewController {
    
    var resultViewController: ResultViewController! = nil
    var words = ["Entrance", "Entry", "Book", "Happiness", "Joke", "Leader", "Cart", "Neat", "Root", "Salt"]
    
    var selectedWord: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        resultViewController = children[0] as? ResultViewController
        
        selectedWord = words[Int.random(in: 0..<10)]
        
//        wordViewController.loadWord(word: selectedWord)
    }

}
