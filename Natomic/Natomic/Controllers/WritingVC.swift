//
//  WritingVC.swift
//  Natomic
//
//  Created by Archit's Mac on 24/07/23.
//

import UIKit
import IQKeyboardManagerSwift

class WritingVC: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bottomPostBTNbottomCon: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
//        addDoneButtonOnKeyboard()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.textView.becomeFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(keyboardShowNotification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    @objc
    private func handle(keyboardShowNotification notification: Notification) {
        // 1
        print("Keyboard show notification")
        
        // 2
        if let userInfo = notification.userInfo,
            // 3
            let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            print(keyboardRectangle.height)
            UIView.animate(withDuration: 0.5) {
                if hasNotch() {
                    self.bottomPostBTNbottomCon.constant = keyboardRectangle.height-20
                } else {
                    self.bottomPostBTNbottomCon.constant = keyboardRectangle.height+20
                }
            }

        }
    }
    
    @IBAction func postBTNtapped(_ sender: Any) {
        if textView.text.isEmpty {
            
        }else{
            textView.resignFirstResponder()
            DatabaseMabager.Shared.addUserContext(userContext: User.init(userThoughts: textView.text, date: CurrentDate, time: CurrentTime))
            NotificationCenter.default.post(name: .saveUserData, object: nil)
            self.dismiss(animated: true, completion: nil)
        }

    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = #colorLiteral(red: 0.06300000101, green: 0.05900000036, blue: 0.05099999905, alpha: 1)
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textView.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        if textView.text.isEmpty {
            
        }else{
            textView.resignFirstResponder()
            DatabaseMabager.Shared.addUserContext(userContext: User.init(userThoughts: textView.text, date: CurrentDate, time: CurrentTime))
            NotificationCenter.default.post(name: .saveUserData, object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}

extension WritingVC : UITextViewDelegate {
    
}
