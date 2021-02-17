//
//  RandomWordViewController.swift
//  mercury
//
//  Created by Stanley on 15/02/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class RandomWordViewController: UIViewController {
    
    let API_URL = "https://myawesomedictionary.herokuapp.com/words"
    
    var wordViewController: WordViewController! = nil
    var words: [Word] = []
    var wordsDict = ["Entrance", "Entry", "Book", "Happiness", "Joke", "Leader", "Cart", "Neat", "Root", "Salt"]
    
    var selectedWord: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        wordViewController = children[0] as? WordViewController
        
        selectedWord = wordsDict[Int.random(in: 0..<10)]
        
        wordViewController.loadWord(word: selectedWord)
        searchWord(text: selectedWord)
    }
    
    func searchWord(text: String) {
        // reset
        self.words = []
              
        // request api
        AF.request(API_URL, parameters: ["q": text])
          .validate(statusCode: 200..<300)
          .validate(contentType: ["application/json"])
            .response{ response in
                switch response.result {
                    case .success(let value):
                        let json = JSON(value!)
                        
                        for word in json.arrayValue {
                            let theWord = word["word"]
                            let definitionJson = JSON(word["definitions"])
                            
                            var definitions: [Definition] = []
                            
                            for definition in definitionJson.arrayValue {
                                definitions.append(Definition(imageUrl: definition["image_url"].stringValue, type: definition["type"].stringValue, definition: definition["definition"].stringValue))
                            }
                            
                            self.words.append(Word(word: theWord.stringValue, definitions: definitions))
                            
                        }
                        
                        
                        self.wordViewController.setDefinitions(definitions: self.words[0].definitions)
                        self.wordViewController.loadWord(word: self.selectedWord)
                        
//                        print("JSON: \(json[0]["word"])")
                        
                    case .failure(let error):
                        print(error)
                    }
            }
    }
}
