//
//  TextDeatilVC.swift
//  Natomic
//
//  Created by Archit Navadiya on 31/08/23.
//

import UIKit
import Alamofire

protocol ShowShareImageScreen {
    func showShareImageScreen()
    func updatedNote(noteText:String)
}


class TextOpenVC : UIViewController {
    
    // MARK: - Outlet's :-
    
    @IBOutlet weak var textLBL: UILabel!
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var timeLBL: UILabel!
    @IBOutlet weak var secondThemeImageView: UIImageView!
    @IBOutlet weak var moreAlertHeight: NSLayoutConstraint!
    @IBOutlet weak var moreAlertWidth: NSLayoutConstraint!
    @IBOutlet weak var moreOptionView: UIView!
    
    // MARK: - Variable's : -
    
    var selectedData : UserEntity?
    var delegate: ShowShareImageScreen?
    var isMoreOptionVisible = false
    var deleteNoteID = "0"
    var pendingDeleteDataArray = [DeletePendingData]()
    var userData : [UserEntity]?
    // MARK: - ViewController Life Cycle:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    // MARK: - All Fuction's : -
    
    func setUI(){
//        moreAlertHeight.constant = 0
//        moreAlertWidth.constant = 0
        moreOptionView.isHidden = true
        delegate = self
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        view.addGestureRecognizer(swipeGesture)
        textLBL.text = selectedData?.userThoughts ?? ""
        dateLBL.text = DatabaseManager.Shared.convertDateFormat(selectedData?.date ?? "")
        timeLBL.text = DatabaseManager.Shared.convertTo12HourFormat(selectedData?.time ?? "")!
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideMoreOption(_:)))
        // Add the gesture recognizer to your main view
        view.addGestureRecognizer(tapGesture)
        
        self.userData = DatabaseManager.Shared.getUserContext()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Combine date and time in a single format

        self.userData?.sort { (entity1, entity2) in
            if let dateTime1 = dateFormatter.date(from: "\(entity1.date ?? "") \(entity1.time ?? "")"),
               let dateTime2 = dateFormatter.date(from: "\(entity2.date ?? "") \(entity2.time ?? "")") {
                return dateTime1 > dateTime2
            }
            return false // Return false as a fallback
        }
    }
    
    @objc func handleTapOutsideMoreOption(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        
        // Check if the tap was outside the moreOptionView
        if moreOptionView.isHidden == false, !moreOptionView.frame.contains(location) {
            moreOptionView.isHidden = true
        }
    }

    @objc func handleSwipeGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        if gesture.state == .ended {
            // Check if the user swiped from left to right (positive x-translation)
            if translation.x > 50 {
                // Perform the pop action if the swipe was significant enough
                TrackEvent.shared.track(eventName: .backButtonClickNoteDeatilScreen)
                navigationController?.popViewController (animated: true)
            }
        }
    }
    
    
    func deleteNote(){
        let alertController = UIAlertController(title: "Delete Note", message: "Are you sure you want to delete this note?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            if IS_LOGIN {
                guard let noteID = self.selectedData?.noteID  else {return}
                self.deleteNoteID = noteID
                self.checkInternet()
            }
            
            
            var pendingDataArray : [PendingData] = getPendingDataModelArray(forKey: "PENDING_DATA_ARRAY") ?? []

            if let index = pendingDataArray.firstIndex(where: { $0.day ==  self.selectedData?.day ?? ""}) {
               pendingDataArray.remove(at: index)
                savePendingDataModelArray(pendingDataArray, forKey: "PENDING_DATA_ARRAY")
            } else {
                print("Item not found in array")
            }

//                else{
//                    var pendingDataArray : [PendingData] = getPendingDataModelArray(forKey: "PENDING_DATA_ARRAY") ?? []
//                    pendingDataArray.removeAll { $0.userThoughts == self.userData![indexPath.row].userThoughts ?? "" && $0.time == self.userData![indexPath.row].time ?? ""}
//                    savePendingDataModelArray(pendingDataArray, forKey: "PENDING_DATA_ARRAY")
//                }
            
            DatabaseManager.Shared.deleteUserContext(userContext: self.selectedData!)
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    

    }
    
    func checkInternet(){
        guard let isInternetAvailable = NetworkReachabilityManager()?.isReachable, isInternetAvailable else {
            print("No internet connection")
            self.pendingDeleteDataArray = getDeletePendingDataModelArray(forKey: "DELETE_PENDING_DATA_ARRAY") ?? []
            self.pendingDeleteDataArray.append(DeletePendingData.init(noteID: self.deleteNoteID))
            saveDeletePendingDataModelArray(self.pendingDeleteDataArray, forKey: "DELETE_PENDING_DATA_ARRAY")
            return
        }
        self.deleteUserNoteByID(noteID: self.deleteNoteID)
    }
    
    func deleteUserNoteByID(noteID:String){
        DatabaseHelper.shared.deleteUserNoteByID(noteId: noteID) { result in
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
                self.pendingDeleteDataArray = getDeletePendingDataModelArray(forKey: "DELETE_PENDING_DATA_ARRAY") ?? []
                self.pendingDeleteDataArray.append(DeletePendingData.init(noteID: self.deleteNoteID))
                saveDeletePendingDataModelArray(self.pendingDeleteDataArray, forKey: "DELETE_PENDING_DATA_ARRAY")
            }
        }

    }

    // MARK: - Button Action's : -
    
    @IBAction func backBTNtapped(_ sender: Any) {
        TrackEvent.shared.track(eventName: .backButtonClickNoteDeatilScreen)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func moreBTNtapped(_ sender: Any) {
        TrackEvent.shared.track(eventName: .shareNoteButtonClickNoteDeatilScreen)
        showShareImageScreen()
//        moreOptionView.isHidden.toggle()
    }
    
    @IBAction func shareBTNtapped(_ sender: Any) {
        moreOptionView.isHidden.toggle()

        let vc = SHARE_NOTE_VC
        vc.noteText = textLBL.text ?? ""
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    @IBAction func editBTNtapped(_ sender: Any) {
        moreOptionView.isHidden.toggle()
        let vc = EDIT_NOTE_VC
        vc.delegate = self
        vc.userData = selectedData
        vc.isFromTextOpenScreen = true
        self.present(vc, animated:true)
    }
    
    @IBAction func deleteBTNtapped(_ sender: Any) {
        moreOptionView.isHidden.toggle()
        deleteNote()
    }
    
    @IBAction func viewMoreBTNtapped(_ sender: Any) {
        let vc = SHARE_IMAGE_VC
        vc.noreText = textLBL.text ?? ""
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    @IBAction func firstThemeShareBTNtapped(_ sender: Any) {
        let vc = SHARE_IMAGE_VC
        vc.noreText = textLBL.text ?? ""
        vc.fromTextOpenVC = true
        vc.textColor = .white
        vc.hexColor = "#F9C780"
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    @IBAction func secondThemeShareBTNtapped(_ sender: Any) {
        let vc = SHARE_IMAGE_VC
        vc.noreText = textLBL.text ?? ""
        vc.fromTextOpenVC = true
        vc.selectedImage = secondThemeImageView.image ?? UIImage()
        vc.textColor = .black
        vc.hexColor = ""
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    
}


extension TextOpenVC : ShowShareImageScreen{
    func updatedNote(noteText:String) {
        self.textLBL.text = noteText

    }
    
    func showShareImageScreen() {
        let vc = SHARE_IMAGE_VC
        vc.noreText = textLBL.text ?? ""
//        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
}
