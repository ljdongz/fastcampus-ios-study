//
//  ViewController.swift
//  KTV
//
//  Created by hyeonggyu.kim on 2023/09/06.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 19
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor(resource: .mainBrown).cgColor
    }

    @IBAction func loginButtonDidTapped(_ sender: Any) {
        self.view.window?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "tabbar")
    }
    
}

