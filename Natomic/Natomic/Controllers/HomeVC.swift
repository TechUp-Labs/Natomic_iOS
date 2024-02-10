//
//  HomeVC.swift
//  Natomic
//
//  Created by Archit's Mac on 19/07/23.
//

import UIKit
import UserNotifications
import FittedSheets
import Alamofire

protocol CheckWriting {
    func checkUserData()
    func checkUserText()
    func checkNotificationState()
    func changeNotificationBTNicon()
}


class HomeVC: UIViewController {
    
    // MARK: - Outlet's :-
    
    @IBOutlet weak var historyTBV: UITableView!
    @IBOutlet weak var notificationBTN: UIButton!
    @IBOutlet weak var profileBTN: UIButton!
    @IBOutlet weak var blureView: UIView!
    
    // MARK: - Variable's :-
    
    let reachability = try! Reachability()
    var pendingDeleteDataArray = [DeletePendingData]()
    var notificationTrigger : UsersNotification?
    var userData : [UserEntity]?
    let testView : TestView = .fromNib()
    var selectedCell = -1
    var writingDelegate : CheckWriting?
    var userNotes : [Response]?
    var blurView: UIVisualEffectView!
    var gradientLayer: CAGradientLayer!
    var deleteNoteID = "0"
    // MARK: - ViewController Life Cycle:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationBTN.setImage(NOTIFICATION_ENABLE ? UIImage(named: "notificationEnabledImage") : UIImage(named: "notificationDisabledImage"), for: .normal)
        profileBTN.setImage(IS_LOGIN ? UIImage(named: "ProfileDisableIcon") : UIImage(named: "ProfileEnableIcon"), for: .normal)
        
        selectedCell = -1
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
        self.historyTBV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        self.historyTBV.reloadData()
    }
    
    // MARK: - All Fuction's : -
    
    func setUI(){
        writingDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadUsersData(notification:)), name: .saveUserData, object: nil)
        homeVC = self
        historyTBV.registerCell(identifire: "HistoryTableCell")
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

        
        if IS_FROME_NOTIFICATION ?? false {
            let vc = WRITING_VC
            self.present(vc, animated: true, completion: nil)
        }
        
        if self.userData?.count == 0 {
            let vc = WRITING_VC
            vc.writingDelegate = self
            self.present(vc, animated: true, completion: nil)
        }
        
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = blureView.bounds

        // Create a blur effect
        let blurEffect = UIBlurEffect(style: .light)

        // Create a blur effect view with the blur effect
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = blureView.bounds

        // Add the gradient layer as a mask to the blur effect view
        blurView.layer.mask = gradientLayer

        // Add the blur effect view to your existing blurView
        blureView.addSubview(blurView)
        blureView.layoutIfNeeded()

        
        self.historyTBV.reloadData()
        
    }
    
    func getUserData(){
        DatabaseHelper.shared.fetchUserData { result in
            switch result {
            case .success(let NoteModel):
                self.userNotes = NoteModel.response?.reversed()
//                self.noteTBLView.reloadData()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    
    @objc func reloadUsersData(notification:Notification) {
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

        self.historyTBV.reloadData()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.testView.alpha = 0.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            self.testView.removeFromSuperview()
            sender.view?.removeFromSuperview()
        }
        
    }
    
    func convertTo12HourFormat(hour: Int) ->  Int {
        if hour >= 0 && hour <= 23 {
            let convertedHour = hour % 12 == 0 ? 12 : hour % 12
            return convertedHour
        } else {
            fatalError("Invalid hour value. Hour should be between 0 and 23.")
        }
    }
    
    // MARK: - Button Action's : -
    
    @IBAction func profileBTNtapped(_ sender: Any) {
        if IS_LOGIN {
            self.navigationController?.pushViewController(MENU_VC, animated: true)
        }else{
            self.navigationController?.pushViewController(SIGNUP_VC, animated: true)
        }
    }
    @IBAction func addNewLineBTNtapped(_ sender: Any) {
        let vc = WRITING_VC
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func notificationBTNtapped(_ sender: Any) {
        
        let vc = NOTIFICATION_TIME_VC
        vc.writingDelegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
        
    }
    
}

extension HomeVC: SetTableViewDelegateAndDataSorce {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableCell", for: indexPath) as! HistoryTableCell
        if selectedCell == indexPath.row {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.8941176471, blue: 0.8196078431, alpha: 1)
        }else{
            cell.contentView.backgroundColor = .clear
        }
        if let data = userData?[indexPath.row]{
            cell.displayData(data: data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, completionHandler) in
            // Handle edit action
            self.editItemAt(indexPath)
            completionHandler(true)
        }

        editAction.backgroundColor = UIColor.init(named: "BackgroundColor")!
        editAction.title = ""
        
        let cellHeight = tableView.rectForRow(at: indexPath).height

        // Load custom view from XIB for editAction
        if let editCustomView = Bundle.main.loadNibNamed("EditDeleteTableView", owner: nil, options: nil)?.first as? EditDeleteTableView {
            editCustomView.iconeIMGView.image = UIImage.init(named: "editTableIcon")

            let desiredWidth: CGFloat = 80 // Set your desired width
            let desiredHeight: CGFloat = cellHeight // Set your desired height


            editCustomView.frame = CGRect(x: 0, y: 0, width: desiredWidth, height: desiredHeight) // Set your custom view's frame
            editAction.backgroundColor = UIColor(patternImage: UIImage.imageWithView(view: editCustomView)) // Use a pattern image with your custom view
        }

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
            // Handle delete action
            self.deleteItemAt(indexPath)
            completionHandler(true)
        }

        deleteAction.backgroundColor = UIColor.init(named: "BackgroundColor")!
        deleteAction.title = ""

        // Load custom view from XIB for deleteAction
        if let deleteCustomView = Bundle.main.loadNibNamed("EditDeleteTableView", owner: nil, options: nil)?.first as? EditDeleteTableView {
            deleteCustomView.iconeIMGView.image =  UIImage.init(named: "deleteTableIcon")
            let desiredWidth: CGFloat = 80 // Set your desired width
            let desiredHeight: CGFloat = cellHeight // Set your desired height

            // Set the frame of deleteCustomView based on the calculated width and height
            deleteCustomView.frame = CGRect(x: 0, y: 0, width: desiredWidth, height: desiredHeight)
            deleteAction.backgroundColor = UIColor(patternImage: UIImage.imageWithView(view: deleteCustomView)) // Use a pattern image with your custom view
        }

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func editItemAt(_ indexPath: IndexPath) {
        let vc = EDIT_NOTE_VC
        vc.userData = userData?[indexPath.row]
        self.present(vc, animated:true)
    }   

    func deleteItemAt(_ indexPath: IndexPath) {
        
        
            
            let alertController = UIAlertController(title: "Delete Note", message: "Are you sure you want to delete this note?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                if IS_LOGIN {
                    guard let noteID = self.userData?[indexPath.row].noteID  else {return}
                    self.deleteNoteID = noteID
                    self.checkInternet()
                }
                
                DatabaseManager.Shared.deleteUserContext(userContext: self.userData!.remove(at: indexPath.row))
                        
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

                self.historyTBV.reloadData()
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true, completion: nil)
        

        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = indexPath.row
        self.historyTBV.reloadData()
        
        let vc = TEXT_OPEN_VC
        vc.selectedData = userData?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeVC {
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
}

extension HomeVC : CheckWriting {
    func changeNotificationBTNicon() {
        notificationBTN.setImage(NOTIFICATION_ENABLE ? UIImage(named: "notificationEnabledImage") : UIImage(named: "notificationDisabledImage"), for: .normal)
        if !NOTIFICATION_ENABLE {
            let vc = SET_REMINDER_ALERT_VC
            vc.writingDelegate = self
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false)
        }
    }
    
    
    func checkNotificationState() {
        if !NOTIFICATION_ENABLE {
            let vc = NOTIFICATION_TIME_VC
            vc.writingDelegate = self
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false)
        }
    }
    
    func checkUserData() {
        if DatabaseManager.Shared.getUserContext().reversed().count == 0 {
            let vc = WRITING_ALERT_VC
            vc.writingDelegate = self
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false)
        }
    }
    
    func checkUserText() {
        if self.userData?.count == 0 {
            let vc = WRITING_VC
            vc.writingDelegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}

extension UIImage {
    static func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImage!
    }
}


extension Notification.Name {
    static let saveUserData = Notification.Name("SaveUserData")
}
