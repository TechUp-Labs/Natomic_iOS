//
//  WritingVC.swift
//  Natomic
//
//  Created by Archit's Mac on 24/07/23.
//

import UIKit
import IQKeyboardManagerSwift
import WidgetKit

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
    let feedbackGenerator = UISelectionFeedbackGenerator()
    let sentences = [
        "What is one thing you learned today, and how did it change your perspective?",
        "Describe a moment from today that you would like to remember forever.",
        "What is something you're looking forward to tomorrow, and why?",
        "Reflect on a piece of advice you've received recently. How can you apply it to your life?",
        "Think about a person who made a positive impact on your day. What did they do, and how did it make you feel?",
        "Describe a challenge you faced today. How did it make you feel, and how did you overcome it?",
        "What is one goal you have for the upcoming week, and what is one small step you can take towards achieving it?",
        "Identify something in your life you're grateful for today. Why does it hold significance for you?",
        "If you could change one thing about today, what would it be and why?",
        "Describe a moment today when you felt truly at peace or happy. What triggered that feeling?"
    ]
    var shared_text = ""
    // MARK: - ViewController Life Cycle:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        setUI()
    }
    deinit {
        // Unregister the keyboard notifications when the view controller is deallocated
        NotificationCenter.default.removeObserver(self)
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

    
    override func viewWillAppear(_ animated: Bool) {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(handle(keyboardShowNotification:)),
//                                               name: UIResponder.keyboardDidShowNotification,
//                                               object: nil)
        
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.writingDelegate?.checkUserData()
        self.writingDelegate?.checkNotificationState()
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
        UserDefaults(suiteName: "group.natomic.share")?.removeObject(forKey: "sharedText")
    }
    
    // MARK: - All Fuction's : -
    
    func setUI(){
        textView.delegate = self
        self.postBTN.layer.opacity = 0.5
        self.postBTN.isUserInteractionEnabled = false
        if !shared_text.isEmpty{
            textView.text = shared_text
            let characterCount = textView.text.count
            self.textCountLBL.text = "\(characterCount)"
            self.postBTN.layer.opacity = characterCount > 0 ? 1 : 0.5
            self.placeholderLBL.isHidden = characterCount > 0
            self.postBTN.isUserInteractionEnabled = characterCount > 0
        }
        feedbackGenerator.prepare()
        
        // Add long press gesture recognizer to the button
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        postBTN.addGestureRecognizer(longPressGesture)
        //        addDoneButtonOnKeyboard()
        //        postBTN.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        showRandomPlaceholder()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.textView.becomeFirstResponder()
        }
    }
    
    func showRandomPlaceholder() {
        let randomIndex = Int(arc4random_uniform(UInt32(sentences.count)))
        placeholderLBL.text = sentences[randomIndex] // sentences
    }

    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            // Start haptic feedback when button is pressed
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            generator.impactOccurred()
        } else if gesture.state == .ended || gesture.state == .cancelled {
            // Reset the feedback generator when button is released
            feedbackGenerator.prepare()
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
    
    @IBAction func closeBTNtapped(_ sender: Any) {
        TrackEvent.shared.track(eventName: .closeWritingScreeneButtonClick)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func postBTNtapped(_ sender: Any) {
        TrackEvent.shared.track(eventName: .postNoteButtonClick)
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
        animateButtonTap()
        
        sharedUserDefaults?.set(self.textView.text ?? "", forKey: SharedUserDefaults.Keys.userNote)
        sharedUserDefaults?.set(CurrentTime, forKey: SharedUserDefaults.Keys.noteTime)
        sharedUserDefaults?.set(CurrentDate, forKey: SharedUserDefaults.Keys.noteDate)
        sharedUserDefaults?.set("\(DatabaseManager.Shared.calculateStreak())", forKey: SharedUserDefaults.Keys.streak)
        
        let weekData = DatabaseManager.Shared.getCurrentWeekData()
        saveWeekDataToUserDefaults(weekData: weekData)

        sharedUserDefaults?.synchronize()
        
        DispatchQueue.main.async {
            WidgetCenter.shared.reloadAllTimelines()
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                self.textView.resignFirstResponder()
            DatabaseManager.Shared.addUserContext(userContext: User.init(userThoughts: self.textView.text, date: CurrentDate, time: CurrentTime, day: "\(DatabaseManager.Shared.getUserContext().count+1)"))
                NotificationCenter.default.post(name: .saveUserData, object: nil)
            sharedUserDefaults?.set("\(DatabaseManager.Shared.calculateStreak())", forKey: SharedUserDefaults.Keys.streak)
            TrackEvent.shared.track(eventName: .noteAddedSuccessfullyButtonClick)
                self.dismiss(animated: true, completion: nil)
        }
        if IS_LOGIN {
            checkInternet()
        }
        else{
            self.pendingDataArray = getPendingDataModelArray(forKey: "PENDING_DATA_ARRAY") ?? []
            pendingDataArray.append(PendingData.init(userThoughts: self.textView.text, date: CurrentDate, time: CurrentTime, day: "\(DatabaseManager.Shared.getUserContext().count+1)"))
            savePendingDataModelArray(pendingDataArray, forKey: "PENDING_DATA_ARRAY")
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
            if UID != "" {
                postUserData(uid: UID, note: self.textView.text, date: CurrentDate, time: CurrentTime)
            }
        case .cellular:
            print("Cellular Connection 😃")
            if UID != "" {
                postUserData(uid: UID, note: self.textView.text, date: CurrentDate, time: CurrentTime)
            }
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
                        let response = try decoder.decode(ResponseModelNotes.self, from: responseData)
                        // Now you have your response object
                        print("Successfully posted data:", response)

                        guard let oldUserContext = DatabaseManager.Shared.getUserContext().last else {return}
                        DatabaseManager.Shared.editUserContext(oldUserContext: oldUserContext, newUserContext: User.init(userThoughts: oldUserContext.userThoughts ?? "", date: oldUserContext.date ?? "", time: oldUserContext.time ?? "", day: oldUserContext.day ?? "", noteID: String(response.noteID)))

                    } catch let error {
                        print("Error decoding response:", error.localizedDescription)
                        // Handle the decoding error if necessary
                    }
                }
//                self.dismiss(animated: true)

            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                self.pendingDataArray = getPendingDataModelArray(forKey: "PENDING_DATA_ARRAY") ?? []
                self.pendingDataArray.append(PendingData.init(userThoughts: self.textView.text, date: CurrentDate, time: CurrentTime, day: "\(DatabaseManager.Shared.getUserContext().count+1)"))
                savePendingDataModelArray(self.pendingDataArray, forKey: "PENDING_DATA_ARRAY")
//                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension WritingVC: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        // Count all characters including spaces and new lines
        let characterCount = textView.text.count
        
        self.textCountLBL.text = "\(characterCount)"
        
        let isWithinLimit = characterCount <= 250
        self.postBTN.layer.opacity = characterCount > 0 ? 1 : 0.5
        self.placeholderLBL.isHidden = characterCount > 0
        self.postBTN.isUserInteractionEnabled = characterCount > 0
        
//        if !isWithinLimit {
//            // Limit the text to 250 characters
//            textView.text = String(textView.text.prefix(250))
//            self.textCountLBL.text = "250/250"
//        }
    }

//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        // Predict the new text length
//        let currentText = textView.text as NSString
//        let newText = currentText.replacingCharacters(in: range, with: text)
//        
//        return newText.count <= 250
//    }
    
}

//The               Only Thing That I.       Love.      💕 Love 💕 is my love 😍 Love 💕 to all the girls 👧 out in my world 🌍 that love 💕 and to everyone.     The world has a lot to do fort1
// MARK: - Twitter share code :-

//let tweetText = "This is the text I want to share on Twitter!"
//let escapedTweetText = tweetText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//
//let urlString = "https://twitter.com/intent/tweet?text=\(escapedTweetText)"
//guard let url = URL(string: urlString) else { return }
//
//if UIApplication.shared.canOpenURL(url) {
//    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//} else {
//    showAlert(title: "Error", message: "Twitter app is not installed")
//}

// MARK: - Twitter share code :-

//guard let url = URL(string: "instagram://sharesheet?text=\("This is the text I want to share on Instagram!")") else { return }
//if UIApplication.shared.canOpenURL(url) {
//    UIApplication.shared.open(url, options: [])
//} else {
//    // Show some error message or suggest installing Instagram
//    showAlert(title: "Error", message: "Something went wrong")
//}
