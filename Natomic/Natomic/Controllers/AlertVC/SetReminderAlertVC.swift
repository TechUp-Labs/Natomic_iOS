//
//  SetReminderAlertVC.swift
//  Natomic
//
//  Created by Archit Navadiya on 21/08/23.
//

import UIKit
import FittedSheets

class SetReminderAlertVC: UIViewController {
    
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
//        dismiss {
//            print("dismiss")
//        }
        TrackEvent.shared.track(eventName: .doItLaterButtonClick)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func setNowBTNtapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        self.dismiss(animated: false) {
            TrackEvent.shared.track(eventName: .setNowButtonClickReminderAlertScreen)
            self.writingDelegate?.checkNotificationState()

        }
//        dismiss {
//            self.writingDelegate?.checkNotificationState()
//        }
    }
    
}
