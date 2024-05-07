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
    let reachability = try! Reachability()
    
    // MARK: - ViewController Life Cycle:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        TrackEvent.shared.track(eventName: .feedbackBackButtonClick)
    }
    
    // MARK: - All Fuction's : -
    
    func setUI(){
        textView.delegate = self
    }
    
    // MARK: - Button Action's : -
    
    @IBAction func backBTNtapped(_ sender: Any) {
        TrackEvent.shared.track(eventName: .feedbackBackButtonClick)
        self.dismiss(animated: true)
//        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBTNtapped(_ sender: Any) {
        if !textView.text.isEmpty {
            checkInternet()
        }else{
            showAlert(title: "Error", message: "Please enter your feedback.")
        }
    }
    
    func checkInternet(){
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Wifi Connection 😃")
            postFeedback()
        case .cellular:
            print("Cellular Connection 😃")
            postFeedback()
        case .unavailable:
            print("No Connection ☹️")
            showAlert(title: "No Internet Connection", message: "Please check your internet connection.")
        }
    }
    
    func postFeedback(){
        DatabaseHelper.shared.postFeedback(response: 1, comment: textView.text) { result in
            switch result {
            case .success(let data):
                // Handle success, e.g., parse the response data
                print("Success: \(data)")
                TrackEvent.shared.track(eventName: .feedbackSubmitButtonClick)
//                self.navigationController?.popViewController(animated: false)
                self.dismiss(animated: false)
                self.dismissDelegate?.dismissScreen()
            case .failure(let error):

                print("Error: \(error)")
                showAlert(title: "Error", message: error.localizedDescription)
            }
        }
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
