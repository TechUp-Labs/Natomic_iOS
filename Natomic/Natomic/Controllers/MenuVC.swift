//
//  ProfileVC.swift
//  Natomic
//
//  Created by Archit's Mac on 19/07/23.
//

import UIKit
import FirebaseAuth

protocol DismissFeedbackScreen {
    func dismissScreen()
}

protocol DismissDeleteScreen {
    func dismissDeleteVC()
}

class MenuVC: UIViewController,UIGestureRecognizerDelegate {
    
    // MARK: - Outlet's :-
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var usernameLBL: UILabel!
    @IBOutlet weak var userEmailLBL: UILabel!
    
    // MARK: - Variable's : -
    
    var menuArray = [Menu]()
    var dismissDelegate : DismissFeedbackScreen?
    var dismissDeleteScreen : DismissDeleteScreen?
    
    // MARK: - ViewController Life Cycle:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    // MARK: - All Fuction's : -
    
    func setUI(){
        dismissDelegate = self
        dismissDeleteScreen = self
        usernameLBL.text = USER_NAME
        userEmailLBL.text = USER_EMAIL
        menuTableView.registerCell(identifire: "MenuTableViewCell")
//        menuArray.append(Menu(menuImage: "ShareIcon", menuTitle: "Subscription"))
        menuArray.append(Menu(menuImage: "ShareIcon", menuTitle: "Share"))
        menuArray.append(Menu(menuImage: "feedbackIcon", menuTitle: "Feedback"))
        menuArray.append(Menu(menuImage: "deleteIcone", menuTitle: "Delete Account"))
        menuArray.append(Menu(menuImage: "logoutIcon", menuTitle: "Log out"))
        self.menuTableView.reloadData()
        if let navigationController = self.navigationController {
            let leftSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleLeftSwipe(_:)))
            leftSwipeGestureRecognizer.edges = .left
            leftSwipeGestureRecognizer.delegate = self
            navigationController.view.addGestureRecognizer(leftSwipeGestureRecognizer)

            let rightSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleRightSwipe(_:)))
            rightSwipeGestureRecognizer.edges = .right
            rightSwipeGestureRecognizer.delegate = self
            navigationController.view.addGestureRecognizer(rightSwipeGestureRecognizer)
        }

    }
    
    // MARK: - Gesture Handlers

    @objc func handleLeftSwipe(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        if gestureRecognizer.state == .recognized {
            // Handle left swipe (pop or perform custom action)
            navigationController?.popViewController(animated: true)
        }
    }

    @objc func handleRightSwipe(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        if gestureRecognizer.state == .recognized {
            // Handle right swipe (perform custom action if needed)
//            navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Ensure that swipe-to-go-back is only enabled when there is more than one view controller on the navigation stack
        return navigationController?.viewControllers.count ?? 0 > 1
    }

    
    // MARK: - Button Action's : -
    
    @IBAction func backBTNtapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlertOnLogout() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.handleLogout()
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func handleLogout() {
        Loader.shared.startAnimating()
        do {
            try Auth.auth().signOut()
            cancelNotification()
            UserDefaults.standard.removeObject(forKey: "IS_STARTED")
            UserDefaults.standard.removeObject(forKey: "NOTIFICATION_ENABLE")
            UserDefaults.standard.removeObject(forKey: "IS_LOGIN")
            UserDefaults.standard.removeObject(forKey: "Notification_Hour")
            UserDefaults.standard.removeObject(forKey: "Notification_Minutes")
            UserDefaults.standard.removeObject(forKey: "Notification_Meridiem")

            DatabaseManager.Shared.removeAllData()
            Loader.shared.stopAnimating()
            self.navigationController?.pushViewController(SPLASH_VC, animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
            Loader.shared.stopAnimating()
            showAlert(title: "Error", message: "\(signOutError.localizedDescription)")
        }
    }
    
    func cancelNotification() {
        // Specify the identifier of the notification you want to cancel
        let notificationIdentifier = "LocalNotification"
        
        // Remove the scheduled notification with the specified identifier
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
        
        // Optionally, you can also remove delivered notifications with the specified identifier
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notificationIdentifier])
        
        print("Notification canceled successfully")
    }



    
}

extension MenuVC: SetTableViewDelegateAndDataSorce{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        cell.menuImg.image = UIImage(named: menuArray[indexPath.row].menuImage)
        cell.menuLBL.text = menuArray[indexPath.row].menuTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var action = menuArray[indexPath.row].menuTitle
        switch action {
        case "Subscription":
            self.navigationController?.pushViewController(SUBSCRIPTION_VC, animated: true)
        case "Share":
            let url = URL(string: "https://apps.apple.com/us/app/natomic/id6474652222")
            let textToShare = ["Unleash your creativity with Natomic! 🚀📚 Explore the art of writing and track your habits seamlessly. Elevate your writing experience with Natomic app – where ideas flow effortlessly! ✨🖋️ #Natomic #WritingJourney", url] as [Any]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook]
            self.present(activityViewController, animated: true, completion: nil)
        case "Feedback":
            let vc = FEEDBACK_VC
            vc.dismissDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        case "Delete Account":
            let vc = DELETE_ACCOUNT_ALERT_VC
            vc.dismissDeleteScreen = self
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false)
        case "Log out":
            showAlertOnLogout()
        default:
            break
        }
    }
}

extension MenuVC : DismissFeedbackScreen {
    func dismissScreen() {
        self.navigationController?.pushViewController(SUCCESS_FEEDBACK_VC, animated: true)
    }
}
extension MenuVC : DismissDeleteScreen {
    func dismissDeleteVC(){
        Loader.shared.startAnimating()
        do {
            try Auth.auth().signOut()
            cancelNotification()
            UserDefaults.standard.removeObject(forKey: "IS_STARTED")
            UserDefaults.standard.removeObject(forKey: "NOTIFICATION_ENABLE")
            UserDefaults.standard.removeObject(forKey: "IS_LOGIN")
            UserDefaults.standard.removeObject(forKey: "Notification_Hour")
            UserDefaults.standard.removeObject(forKey: "Notification_Minutes")
            UserDefaults.standard.removeObject(forKey: "Notification_Meridiem")
            DatabaseManager.Shared.removeAllData()
            Loader.shared.stopAnimating()
            self.navigationController?.pushViewController(SPLASH_VC, animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
            Loader.shared.stopAnimating()
            showAlert(title: "Error", message: "\(signOutError.localizedDescription)")
        }
    }
    

}
