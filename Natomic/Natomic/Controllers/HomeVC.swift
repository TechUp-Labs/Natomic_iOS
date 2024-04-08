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
    @IBOutlet weak var tableTopCon: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBottomLine: UIView!
    @IBOutlet weak var noteCollectionview: UICollectionView!
    @IBOutlet weak var collectionTopCon: NSLayoutConstraint!
    
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
        searchBar.delegate = self
        searchBar.showsCancelButton = true
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
        searchBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadUsersData(notification:)), name: .saveUserData, object: nil)
        homeVC = self
        historyTBV.registerCell(identifire: "HistoryTableCell")
        self.searchBarHeight.constant = 0
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
        
        if IS_FROME_NOTE_NOTIFICATION ?? false {
            let data = DatabaseManager.Shared.getUserContext(forNoteText: NOTIFICATION_DESCRIPTION ?? "")
            
            if data.isEmpty {
                let vc = WRITING_VC
                vc.writingDelegate = self
                self.present(vc, animated: true, completion: nil)
            }
            
            let vc = TEXT_OPEN_VC
            vc.selectedData = data.first
            self.navigationController?.pushViewController(vc, animated: true)
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
        
        noteCollectionview.delegate = self
        noteCollectionview.dataSource = self
        noteCollectionview.registerCell(identifire: "NoteCollectionViewCell")
        
        self.noteCollectionview.reloadData()
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
        
//        let MENU_VC = MENU_VC // Replace ProfileViewController with your actual profile view controller class
//             navigationController?.pushViewController(MENU_VC, animated: false)
//
//             // Animate the transition
//             UIView.animate(withDuration: 0.3, animations: {
//                 let transition = CATransition()
//                 transition.duration = 0.3
//                 transition.type = CATransitionType.push
//                 transition.subtype = CATransitionSubtype.fromLeft
//                 self.navigationController?.view.layer.add(transition, forKey: nil)
//             })
        
        
        
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        
        // Disable user interaction during the transition
        navigationController?.view.isUserInteractionEnabled = false
        
        // Perform the transition animation within a UIView animation block
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        }) { (_) in
            // Re-enable user interaction after the transition completes
            self.navigationController?.view.isUserInteractionEnabled = true
            
            // Push the appropriate view controller
            if IS_LOGIN {
                self.navigationController?.pushViewController(MENU_VC, animated: false)
            } else {
                self.navigationController?.pushViewController(SIGNUP_VC, animated: false)
            }
        }
        
        
//        if IS_LOGIN {
////            self.presentDetail(MENU_VC)
//            self.navigationController?.pushViewController(MENU_VC, animated: true)
//        } else {
////            self.presentDetail(SIGNUP_VC)
//            self.navigationController?.pushViewController(SIGNUP_VC, animated: true)
//        }

        
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

extension HomeVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
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

        } else {
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

            userData = userData?.filter { userEntity in
                userEntity.userThoughts?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
        self.historyTBV.reloadData()
        self.noteCollectionview.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Optionally, you can also trigger the search here
        // This is useful if you want to perform the search only when the search button is tapped,
        // instead of filtering the results in real-time as the user types
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel button clicked")

        searchBar.text = nil
        searchBar.resignFirstResponder() // Dismiss the keyboard
        // Handle the case when cancel button is clicked, e.g., reset the data to original
        // Load your original or unfiltered dataset to userData again

        self.historyTBV.reloadData() // Reload tableView to show original/unfiltered data
        self.noteCollectionview.reloadData()
    }
}




extension HomeVC: SetTableViewDelegateAndDataSorce {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let offsetY = scrollView.contentOffset.y
        print(offsetY)
      if offsetY <= -0 {
          UIView.animate(withDuration: 0.5) {
              self.searchBar.isHidden = false
              self.searchBottomLine.isHidden = false
              self.searchBarHeight.constant = 56
              self.tableTopCon.constant = 56
              self.collectionTopCon.constant = 56
              self.view.layoutIfNeeded()
          }
      }
        
//        if offsetY > 200{
//            UIView.animate(withDuration: 0.5) {
//                self.searchBarHeight.constant = 0
//                self.tableTopCon.constant = 0
//                self.view.layoutIfNeeded()
//            }
//        }

    }

    
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
            editCustomView.iconeIMGView.image = UIImage.init(named: "edit")
            editCustomView.textLbl.text = "Edit"
            editCustomView.textLbl.textColor = #colorLiteral(red: 0.06300000101, green: 0.05900000036, blue: 0.05099999905, alpha: 1)
//            editCustomView.iconeIMGView.image = UIImage.init(systemName: "pencil")
            editCustomView.BGViewforCell.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1) //pencil

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
            deleteCustomView.iconeIMGView.image =  UIImage.init(named: "delete") // trash
            deleteCustomView.textLbl.text = "Delete"
            deleteCustomView.textLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            deleteCustomView.iconeIMGView.image =  UIImage.init(systemName: "trash") // trash
            deleteCustomView.BGViewforCell.backgroundColor = #colorLiteral(red: 0.06274509804, green: 0.05882352941, blue: 0.05098039216, alpha: 1)
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
                
                
                var pendingDataArray : [PendingData] = getPendingDataModelArray(forKey: "PENDING_DATA_ARRAY") ?? []

                if let index = pendingDataArray.firstIndex(where: { $0.day ==  self.userData![indexPath.row].day ?? ""}) {
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

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCollectionViewCell", for: indexPath) as! NoteCollectionViewCell
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = noteCollectionview.frame.width / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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

extension UIViewController {

    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.30
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        viewControllerToPresent.modalPresentationStyle = .overCurrentContext
        present(viewControllerToPresent, animated: false)
    }

    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.30
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)

        dismiss(animated: false)
    }
}


