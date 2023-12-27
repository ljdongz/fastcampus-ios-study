//
//  MyViewController.swift
//  KTV
//
//  Created by 이정동 on 12/27/23.
//

import UIKit

class MyViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func bookmarkDidTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "bookmark", sender: nil)
    }
    
    @IBAction func favoriteDidTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "favorite", sender: nil)
    }
}
