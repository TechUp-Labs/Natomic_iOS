//
//  HomeVC.swift
//  Natomic
//
//  Created by Archit's Mac on 19/07/23.
//

import UIKit
import UserNotifications
import FittedSheets


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
    
    // MARK: - Variable's :-
    
    var notificationTrigger : UsersNotification?
    var userData : [UserEntity]?
    let testView : TestView = .fromNib()
    var selectedCell = -1
    var writingDelegate : CheckWriting?
    
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
        self.historyTBV.reloadData()
    }
    
    // MARK: - All Fuction's : -
    
    func setUI(){
        writingDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadUsersData(notification:)), name: .saveUserData, object: nil)
        homeVC = self
        historyTBV.registerCell(identifire: "HistoryTableCell")
        self.userData = DatabaseMabager.Shared.getUserContext().reversed()
        if IS_FROME_NOTIFICATION ?? false {
            let vc = WRITING_VC
            self.present(vc, animated: true, completion: nil)
        }
        
        if self.userData?.count == 0 {
            let vc = WRITING_VC
            vc.writingDelegate = self
            self.present(vc, animated: true, completion: nil)
        }
        
        
    }
    
    @objc func reloadUsersData(notification:Notification) {
        self.userData = DatabaseMabager.Shared.getUserContext().reversed()
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
        
        
        /*
         let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationTimeVC") as! NotificationTimeVC
         var options = SheetOptions()
         options.pullBarHeight = 0
         var controllerHeight : CGFloat = 480
         if hasNotch(){controllerHeight = 480+40}
         let sheet = SheetViewController(controller: controller, sizes: [.fixed(controllerHeight), .fullscreen],options: options)
         sheet.cornerRadius = 15
         sheet.allowPullingPastMaxHeight = false
         self.present(sheet, animated: true, completion: nil)
         */
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = indexPath.row
        self.historyTBV.reloadData()
        
        let vc = TEXT_OPEN_VC
        vc.selectedData = userData?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
        //        let viewControllerToPresent = TEXT_DETAIL_VC
        //        viewControllerToPresent.selectedData = userData?[indexPath.row]
        //        viewControllerToPresent.modalPresentationStyle = .overCurrentContext
        //        self.present(viewControllerToPresent, animated: false, completion: nil)
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
        if DatabaseMabager.Shared.getUserContext().reversed().count == 0 {
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

extension Notification.Name {
    static let saveUserData = Notification.Name("SaveUserData")
}
