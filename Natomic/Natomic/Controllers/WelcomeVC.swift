//
//  WelcomeVC.swift
//  Natomic
//
//  Created by Archit Navadiya on 25/08/23.
//

import UIKit

class WelcomeVC: UIViewController {
    
    // MARK: - ViewController Life Cycle:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Button Action's : -
    
    @IBAction func startBTNtapped(_ sender: Any) {
        saveDataInUserDefault(value:true, key: "IS_STARTED")
        self.navigationController?.pushViewController(HOME_VC, animated: true)
    }
    
}
