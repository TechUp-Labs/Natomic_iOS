//
//  EditNoteVC.swift
//  Natomic
//
//  Created by Archit Navadiya on 22/01/24.
//

import UIKit
import IQKeyboardManagerSwift

class EditNoteVC: UIViewController {
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholderLBL: UILabel!
    @IBOutlet weak var postBTN: UIButton!
    @IBOutlet weak var bottomPostBTNbottomCon: NSLayoutConstraint!
    @IBOutlet weak var textCountLBL: UILabel!
    
    var userData : UserEntity?
    let reachability = try! Reachability()
    var editPendingDataArray = [EditPendingData]()


    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        setUI()

    }
    deinit {
        // Unregister the keyboard notifications when the view controller is deallocated
        NotificationCenter.default.removeObserver(self)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
    }
    
    @objc func keyboardWillChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        // Extract the height of the keyboard
        let keyboardHeight = keyboardFrame.height

        // Now you can use the keyboardHeight variable as needed
        print("Keyboard Height: \(keyboardHeight)")
        bottomPostBTNbottomCon.constant = keyboardHeight
        
        if hasNotch() {
            self.bottomPostBTNbottomCon.constant = keyboardHeight-20
        } else {
            self.bottomPostBTNbottomCon.constant = keyboardHeight+20
        }

        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }

    
    func setUI(){
        textView.delegate = self
        placeholderLBL.isHidden = true
        self.postBTN.layer.opacity = 0.5
        self.postBTN.isUserInteractionEnabled = false
        //        addDoneButtonOnKeyboard()
        //        postBTN.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.textView.text = self.userData?.userThoughts ?? ""
            if !self.textView.text.isEmpty {
                self.placeholderLBL.isHidden = true
                self.textCountLBL.text = "\(self.textView.text.count)/250"
                self.postBTN.layer.opacity = 1
                self.placeholderLBL.isHidden = true
                self.postBTN.isUserInteractionEnabled = true
            }
            self.textView.becomeFirstResponder()
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
    
    @IBAction func postBTNtapped(_ sender: Any) {
        if IS_LOGIN {
            checkInternet()
        }
        DatabaseManager.Shared.editUserContext(oldUserContext: self.userData!, newUserContext: User.init(userThoughts: self.textView.text, date: self.userData?.date ?? "", time: self.userData?.time ?? "", day: self.userData?.day ?? "", noteID: self.userData?.noteID ?? ""))
        NotificationCenter.default.post(name: .saveUserData, object: nil)
        self.dismiss(animated: true, completion: nil)

    }

    @IBAction func closeBTNtapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
            guard let noteID = userData?.noteID else {return}
            editUserData(noteId: noteID, newNote: self.textView.text)
        case .cellular:
            print("Cellular Connection 😃") 
            guard let noteID = userData?.noteID else {return}
            editUserData(noteId: noteID, newNote: self.textView.text)
        case .unavailable:
            print("No Connection ☹️")
            DatabaseManager.Shared.editUserContext(oldUserContext: self.userData!, newUserContext: User.init(userThoughts: self.textView.text, date: self.userData!.date ?? "", time: self.userData!.time ?? "", day: self.userData!.day ?? "", noteID: self.userData?.noteID ?? ""))
            guard let noteID = userData?.noteID else {return}
            self.editPendingDataArray = getEditPendingDataModelArray(forKey: "EDIT_PENDING_DATA_ARRAY") ?? []
            editPendingDataArray.append(EditPendingData.init(noteID: noteID, newNote: self.textView.text))
            saveEditPendingDataModelArray(self.editPendingDataArray, forKey: "EDIT_PENDING_DATA_ARRAY")
        }
    }
    
    
    func editUserData(noteId: String, newNote: String){
        DatabaseHelper.shared.editUserNoteByID(noteId: noteId, newNote: newNote){ result in
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
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }


}

extension EditNoteVC : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedText.count != 0 {
            if textView.text.isEmpty {
                self.postBTN.layer.opacity = 0.5
                self.placeholderLBL.isHidden = false
                self.postBTN.isUserInteractionEnabled = false
            }else{
                self.postBTN.layer.opacity = 1
                self.placeholderLBL.isHidden = true
                self.postBTN.isUserInteractionEnabled = true
            }
        }else{
            self.postBTN.layer.opacity = 0.5
            self.placeholderLBL.isHidden = false
            self.postBTN.isUserInteractionEnabled = false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Calculate the new text after the replacement
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        self.textCountLBL.text = "\(newText.count)/250"
        // Limit the text to 250 characters
        return newText.count < 250
    }
    
}
