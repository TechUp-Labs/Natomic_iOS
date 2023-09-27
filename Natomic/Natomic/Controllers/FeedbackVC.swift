//
//  FeedbackVC.swift
//  Natomic
//
//  Created by Archit Navadiya on 25/08/23.
//

import UIKit
import IQKeyboardManagerSwift

class FeedbackVC: UIViewController {
    
    // MARK: - Outlet's :-
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholderLBL: UILabel!
    
    // MARK: - Variable's : -
    
    var dismissDelegate : DismissFeedbackScreen?
    
    // MARK: - ViewController Life Cycle:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    // MARK: - All Fuction's : -
    
    func setUI(){
        textView.delegate = self
    }
    
    // MARK: - Button Action's : -
    
    @IBAction func backBTNtapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBTNtapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
        self.dismissDelegate?.dismissScreen()
    }
    
}


extension FeedbackVC : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedText.count != 0 {
            if textView.text.isEmpty {
                self.placeholderLBL.isHidden = false
            }else{
                self.placeholderLBL.isHidden = true
            }
        }else{
            self.placeholderLBL.isHidden = false
        }
    }
    
}
