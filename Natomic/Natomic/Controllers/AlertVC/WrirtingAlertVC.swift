//
//  WrirtingAlertVC.swift
//  Natomic
//
//  Created by Archit Navadiya on 25/08/23.
//

import UIKit

class WrirtingAlertVC: UIViewController {

    // MARK: - Variable's : -
    
    var writingDelegate : CheckWriting?
    var is_letsWrite = false
    
    // MARK: - ViewController Life Cycle:-
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if is_letsWrite{
            self.writingDelegate?.checkUserText()
        }else{
            self.writingDelegate?.checkNotificationState()
        }
    }
    
    // MARK: - Button Action's : -
    
    @IBAction func closeBTNtapped(_ sender: Any) {
        is_letsWrite = false
//        dismiss()
        self.dismiss(animated: false, completion: nil)

    }
    
    @IBAction func letsWriteBTNtapped(_ sender: Any) {
        is_letsWrite = true
//        dismiss()
        self.dismiss(animated: false, completion: nil)

    }
    
}
