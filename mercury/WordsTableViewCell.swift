//
//  WordViewController.swift
//  mercury
//
//  Created by Stanley on 15/02/21.
//

import UIKit
import SkeletonView
import Alamofire

class WordsTableViewCell: UITableViewCell, UITableViewDelegate, SkeletonTableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleText: UILabel!
    var theWord: String = ""
    let API_URL: String = "https://myawesomedictionary.herokuapp.com/words?q="
    
    struct Definition {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.isHidden = true
    }

    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "DefinitionCell"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefinitionCell", for: indexPath) as! DefinitionTableViewCell
        
        cell.showLoadingAnimation()
        
        return cell
    }
    
    public func loadWord(word: String) {
        tableView.isHidden = false
        theWord = word
        titleText.text = theWord
        AF.request("\(API_URL)\(theWord)").response { response in
            debugPrint(response)
        }
    }
}
