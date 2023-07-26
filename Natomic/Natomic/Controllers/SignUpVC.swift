//
//  SignUpVC.swift
//  Natomic
//
//  Created by Archit's Mac on 26/07/23.
//

import UIKit

class SignUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func SignUpBTNtapped(_ sender: Any) {
        self.navigationController?.pushViewController(SUBSCRIPTION_VC, animated: true)
    }
    

}
