//
//  WritingVC.swift
//  Natomic
//
//  Created by Archit's Mac on 24/07/23.
//

import UIKit
import IQKeyboardManagerSwift

class WritingVC: UIViewController {
    
    // MARK: - Outlet's :-
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholderLBL: UILabel!
    @IBOutlet weak var postBTN: UIButton!
    @IBOutlet weak var bottomPostBTNbottomCon: NSLayoutConstraint!
    @IBOutlet weak var textCountLBL: UILabel!
    
    // MARK: - Variable's : -
    
    var writingDelegate : CheckWriting?
    let reachability = try! Reachability()
    var pendingDataArray = [PendingData]()
    // MARK: - ViewController Life Cycle:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(keyboardShowNotification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.writingDelegate?.checkUserData()
        self.writingDelegate?.checkNotificationState()
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    
    // MARK: - All Fuction's : -
    
    func setUI(){
        textView.delegate = self
        self.postBTN.layer.opacity = 0.5
        self.postBTN.isUserInteractionEnabled = false
        
        //        addDoneButtonOnKeyboard()
        //        postBTN.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.textView.becomeFirstResponder()
        }
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
            UIView.animate(withDuration: 0.2) {
                if hasNotch() {
                    self.bottomPostBTNbottomCon.constant = keyboardRectangle.height-20
                } else {
                    self.bottomPostBTNbottomCon.constant = keyboardRectangle.height+20
                }
            }
            
        }
    }
    
    func animateButtonTap() {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut,
                       animations: {
            self.postBTN.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.postBTN.transform = .identity
            }
        })
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
            DatabaseManager.Shared.addUserContext(userContext: User.init(userThoughts: textView.text, date: CurrentDate, time: CurrentTime, day: "\(DatabaseManager.Shared.getUserContext().reversed().count)"))
            NotificationCenter.default.post(name: .saveUserData, object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Button Action's : -
    
    @IBAction func postBTNtapped(_ sender: Any) {
        if IS_LOGIN {
            checkInternet()
        }else{
            self.pendingDataArray = getPendingDataModelArray(forKey: "PENDING_DATA_ARRAY") ?? []
            pendingDataArray.append(PendingData.init(userThoughts: self.textView.text, date: CurrentDate, time: CurrentTime, day: "\(DatabaseManager.Shared.getUserContext().count+1)"))
            savePendingDataModelArray(pendingDataArray, forKey: "PENDING_DATA_ARRAY")
        }
        animateButtonTap()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                self.textView.resignFirstResponder()
            DatabaseManager.Shared.addUserContext(userContext: User.init(userThoughts: self.textView.text, date: CurrentDate, time: CurrentTime, day: "\(DatabaseManager.Shared.getUserContext().count+1)"))
                NotificationCenter.default.post(name: .saveUserData, object: nil)
                self.dismiss(animated: true, completion: nil)
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
            postUserData(uid: UID, note: self.textView.text, date: CurrentDate, time: CurrentTime)
        case .cellular:
            print("Cellular Connection 😃")
            postUserData(uid: UID, note: self.textView.text, date: CurrentDate, time: CurrentTime)
        case .unavailable:
            print("No Connection ☹️")
            self.pendingDataArray = getPendingDataModelArray(forKey: "PENDING_DATA_ARRAY") ?? []
            pendingDataArray.append(PendingData.init(userThoughts: self.textView.text, date: CurrentDate, time: CurrentTime, day: "\(DatabaseManager.Shared.getUserContext().count+1)"))
            savePendingDataModelArray(pendingDataArray, forKey: "PENDING_DATA_ARRAY")

        }
    }
    
    func postUserData(uid:String, note:String, date:String, time:String){
        DatabaseHelper.shared.postUserNote(uid: uid, note: note, date: date, time: time) { result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(ResponseModel.self, from: responseData)
                        // Now you have your response object
                        print("Successfully posted data:", response)
                    } catch let error {
                        print("Error decoding response:", error.localizedDescription)
                        // Handle the decoding error if necessary
                    }
                }
                self.dismiss(animated: true)

            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                self.pendingDataArray = getPendingDataModelArray(forKey: "PENDING_DATA_ARRAY") ?? []
                self.pendingDataArray.append(PendingData.init(userThoughts: self.textView.text, date: CurrentDate, time: CurrentTime, day: "\(DatabaseManager.Shared.getUserContext().count+1)"))
                savePendingDataModelArray(self.pendingDataArray, forKey: "PENDING_DATA_ARRAY")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension WritingVC: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText.count <= 250 {
            self.textCountLBL.text = "\(trimmedText.count)/250"
            
            if trimmedText.isEmpty {
                self.postBTN.layer.opacity = 0.5
                self.placeholderLBL.isHidden = false
                self.postBTN.isUserInteractionEnabled = false
            } else {
                self.postBTN.layer.opacity = 1
                self.placeholderLBL.isHidden = true
                self.postBTN.isUserInteractionEnabled = true
            }
        } else {
            // Update the character count label for the first 250 characters
            self.textCountLBL.text = "250/250"
            
            // Limit the text to 250 characters
            textView.text = String(trimmedText.prefix(250))
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Calculate the new text after the replacement
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        // Allow pasting text if the total length (current text + pasted text) is less than or equal to 250 characters
        return newText.count <= 250
    }
    
}

