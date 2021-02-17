//
//  WordViewController.swift
//  mercury
//
//  Created by Stanley on 15/02/21.
//

import UIKit
import SkeletonView
import Kingfisher
import SweetLike
import CoreData

class WordViewController: UIViewController, UITableViewDelegate, SkeletonTableViewDataSource, SweetLikeDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var likeButton: SweetLike!
    
    var theWord: String = ""
    var definitions: [Definition] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.isHidden = true
        
        likeButton.isHidden = true
        likeButton.delegate = self
        
        loadWord(word: theWord)
        
        print("auo")
    }
    
    func likeAction() {
        unlike(word: theWord)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: context)
        
        let newItem = NSManagedObject(entity: entity!, insertInto: context)
        
        newItem.setValue(theWord, forKey: "word")
        
        do {
            try context.save()
        } catch {
            print("assdasdasdasd")
        }
    }
    
    func unlikeAction() {
        unlike(word: theWord)
    }
    
    func unlike(word: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        
        var res = [NSManagedObject]()
         
        do {
            res = try context.fetch(req as! NSFetchRequest<NSManagedObject>)
        } catch {
            print("assdasdasdasd")
        }
        
        for el in res {
            if (el.value(forKeyPath: "word") as! String == word) {
                
                context.delete(el)
            }
        }
        
        
        do {
            try context.save()
        } catch {
            print("assdasdasdasd")
        }
    }
    
    
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "DefinitionCell"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if definitions.count > 0 {
            return definitions.count
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefinitionCell", for: indexPath) as! DefinitionTableViewCell
        
        cell.showLoadingAnimation()
        
        if definitions.count > 0 {
            cell.setType(type: definitions[indexPath.row].type)
            cell.setDefinition(definition: definitions[indexPath.row].definition)
            
            let resource = ImageResource(downloadURL: URL.init(string: definitions[indexPath.row].imageUrl) ?? URL.init(string: "#")!)

            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                    case .success(let value):
                        print("Image: \(value.image). Got from: \(value.cacheType)")
                        
                        cell.setFoto(foto: value.image)
                        
                    case .failure(let error):
                        print("Error: \(error)")
                }
            }
            
            
            cell.hideLoadingAnimation()
        }
        
        return cell
    }
    
    public func loadWord(word: String) {
        theWord = word
        titleText.text = theWord
        
        if theWord.count > 0 {
            tableView.isHidden = false
            likeButton.isHidden = false
        }
        
        tableView.reloadData()
        
        // check if liked
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        
        var res = [NSManagedObject]()
         
        do {
            res = try context.fetch(req as! NSFetchRequest<NSManagedObject>)
        } catch {
            print("assdasdasdasd")
        }
        
        for el in res {
            if (el.value(forKeyPath: "word") as! String == theWord) {
                
                likeButton.setStatus(SweetLikeStatus.liked)
            }
        }
    }
    
    public func setWord(word: String) {
        theWord = word
    }
    
    public func setDefinitions(definitions: [Definition]) {
        self.definitions = definitions
    }
}
