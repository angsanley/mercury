//
//  ViewController.swift
//  mercury
//
//  Created by Stanley on 12/02/21.
//

import UIKit
import SkeletonView

class ViewController: UIViewController, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchWord(text: searchBar.text!)
    }
    
    func searchWord(text: String) {
        
    }
}
