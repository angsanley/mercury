//
//  FavoriteViewController.swift
//  mercury
//
//  Created by Stanley on 18/02/21.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let API_URL = "https://myawesomedictionary.herokuapp.com/words"
    
    var wordsRes: [Word] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    var words: [String] = []
    var selectedWord = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadFromDb()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.textLabel!.text = words[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedWord = words[indexPath.row]
        searchWord(text: selectedWord)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWordSegue" {
            let vc = segue.destination as! WordViewController
            vc.setWord(word: selectedWord)
            vc.setDefinitions(definitions: self.wordsRes[0].definitions)
        }
    }
    
    func loadFromDb() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        
        var res = [NSManagedObject]()
         
        do {
            res = try context.fetch(req as! NSFetchRequest<NSManagedObject>)
        } catch {
            print("assdasdasdasd")
        }
        
        for el in res {
            words.append(el.value(forKeyPath: "word") as! String)
        }
        
        
        do {
            try context.save()
        } catch {
            print("assdasdasdasd")
        }
    }
    
    func searchWord(text: String) {
        // reset
        self.wordsRes = []
              
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
                            
                            self.wordsRes.append(Word(word: theWord.stringValue, definitions: definitions))
                        }
//                        print("JSON: \(json[0]["word"])")
                        self.performSegue(withIdentifier: "ShowWordSegue", sender: nil)
                        
                    case .failure(let error):
                        print(error)
                    }
            }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
