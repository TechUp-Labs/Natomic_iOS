//
//  SetReminderAlertVC.swift
//  Natomic
//
//  Created by Archit Navadiya on 21/08/23.
//

import UIKit
import FittedSheets

class SetReminderAlertVC: AlertBase {
    
    // MARK: - Variable's : -
    
    var writingDelegate : CheckWriting?
    
    // MARK: - ViewController Life Cycle:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Button Action's : -
    
    @IBAction func closeBTNtapped(_ sender: Any) {
        dismiss {
            print("dismiss")
        }
    }
    
    @IBAction func setNowBTNtapped(_ sender: Any) {
        dismiss {
            self.writingDelegate?.checkNotificationState()
        }
    }
    
}
