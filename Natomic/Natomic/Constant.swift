//
//  Constant.swift
//  Natomic
//
//  Created by Archit's Mac on 20/07/23.
//

import Foundation
import UIKit


var UID: String {
    return getDataFromUserDefaults(forKey: "UID") as? String ?? ""
}

var USER_NAME: String {
    return getDataFromUserDefaults(forKey: "USER_NAME") as? String ?? "Natomic"
}

var USER_EMAIL: String {
    return getDataFromUserDefaults(forKey: "USER_EMAIL") as? String ?? "User"
}

var PHOTO_URL: String {
    return getDataFromUserDefaults(forKey: "PHOTO_URL") as? String ?? ""
}



let CURRENT_DEVICE_NAME = UIDevice.current.name

var HEIGHT = UIScreen.main.bounds.height

var WIDTH = UIScreen.main.bounds.width

var NOTIFICATION_ENABLE : Bool {
    return getDataFromUserDefaults(forKey: "NOTIFICATION_ENABLE") as? Bool ?? false
}

var IS_LOGIN : Bool {
    return getDataFromUserDefaults(forKey: "IS_LOGIN") as? Bool ?? false
}

var IS_STARTED : Bool {
    return getDataFromUserDefaults(forKey: "IS_STARTED") as? Bool ?? false
}

typealias SetCollectionViewDelegateAndDataSorce = UICollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout

typealias SetTableViewDelegateAndDataSorce = UITableViewDelegate & UITableViewDataSource

var notificationHour : Int {
    return getDataFromUserDefaults(forKey: "Notification_Hour") as? Int ?? 12
}

var notificationMinutes : Int {
    return getDataFromUserDefaults(forKey: "Notification_Minutes") as? Int ?? 00
}

var notificationMeridiem : String {
    return getDataFromUserDefaults(forKey: "Notification_Meridiem") as? String ?? "PM"
}


// MARK: - All ViewControllers SetUP:-

var WELCOME_VC : WelcomeVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
   }
}


var HOME_NAV : UINavigationController {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
   }
}

var WRITING_ALERT_VC : WrirtingAlertVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WrirtingAlertVC") as! WrirtingAlertVC
   }
}


var SPLASH_VC : SplashVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
   }
}

var SIGNUP_NAV : UINavigationController {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpNAV") as! UINavigationController
   }
}

var INTRO_VC : IntroVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IntroVC") as! IntroVC
   }
}

var SIGNUP_VC : SignUpVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
   }
}

var SUBSCRIPTION_VC : SubscriptionVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubscriptionVC") as! SubscriptionVC
   }
}

var HOME_VC : HomeVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
   }
}

var WRITING_VC : WritingVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WritingVC") as! WritingVC
   }
}

var EDIT_NOTE_VC : EditNoteVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditNoteVC") as! EditNoteVC
   }
}

var TEXT_OPEN_VC : TextOpenVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TextOpenVC") as! TextOpenVC
   }
}

var MENU_VC : MenuVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
   }
}

var NOTIFICATION_TIME_VC : NotificationTimeVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationTimeVC") as! NotificationTimeVC
   }
}

var TEXT_DETAIL_VC : TextDetailVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TextDetailVC") as! TextDetailVC
   }
}

var SET_REMINDER_ALERT_VC : SetReminderAlertVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetReminderAlertVC") as! SetReminderAlertVC
   }
}

var DELETE_ACCOUNT_ALERT_VC : DeleteAccountAlertVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeleteAccountAlertVC") as! DeleteAccountAlertVC
   }
}


var FEEDBACK_VC : FeedbackVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackVC") as! FeedbackVC
   }
}

var SUCCESS_FEEDBACK_VC : SuccessFeedbackVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessFeedbackVC") as! SuccessFeedbackVC
   }
}

var IMAGE_CONVERT_VC : ImageConvertVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageConvertVC") as! ImageConvertVC
   }
}


var FRIENDS_NOTE_VC : FriendsNoteVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FriendsNoteVC") as! FriendsNoteVC
   }
}


var SHARE_NOTE_VC : ShareNoteVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShareNoteVC") as! ShareNoteVC
   }
}


var SHARE_IMAGE_VC : ShareImageVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShareImageVC") as! ShareImageVC
   }
}

var STREAK_VC : StreakVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StreakVC") as! StreakVC
   }
}


func saveDataInUserDefault(value:Any?, key: String){
    let Default = UserDefaults.standard
    Default.set(value, forKey: key)
    Default.synchronize()
}

func getDataFromUserDefaults(forKey key: String) -> Any? {
    let defaults = UserDefaults.standard
    return defaults.object(forKey: key)
}

func savePendingDataModelArray(_ modelArray: [PendingData], forKey key: String) {
    let encoder = JSONEncoder()
    if let data = try? encoder.encode(modelArray) {
        UserDefaults.standard.set(data, forKey: key)
    }
}

func getPendingDataModelArray(forKey key: String) -> [PendingData]? {
    if let data = UserDefaults.standard.data(forKey: key) {
        let decoder = JSONDecoder()
        if let modelArray = try? decoder.decode([PendingData].self, from: data) {
            return modelArray
        }
    }
    return nil
}

func saveEditPendingDataModelArray(_ modelArray: [EditPendingData], forKey key: String) {
    let encoder = JSONEncoder()
    if let data = try? encoder.encode(modelArray) {
        UserDefaults.standard.set(data, forKey: key)
    }
}

func getEditPendingDataModelArray(forKey key: String) -> [EditPendingData]? {
    if let data = UserDefaults.standard.data(forKey: key) {
        let decoder = JSONDecoder()
        if let modelArray = try? decoder.decode([EditPendingData].self, from: data) {
            return modelArray
        }
    }
    return nil
}

func saveDeletePendingDataModelArray(_ modelArray: [DeletePendingData], forKey key: String) {
    let encoder = JSONEncoder()
    if let data = try? encoder.encode(modelArray) {
        UserDefaults.standard.set(data, forKey: key)
    }
}

func getDeletePendingDataModelArray(forKey key: String) -> [DeletePendingData]? {
    if let data = UserDefaults.standard.data(forKey: key) {
        let decoder = JSONDecoder()
        if let modelArray = try? decoder.decode([DeletePendingData].self, from: data) {
            return modelArray
        }
    }
    return nil
}



extension UICollectionView {
   func registerCell(identifire:String){
       self.register(UINib(nibName: identifire, bundle: nil), forCellWithReuseIdentifier: identifire)
   }
}

extension UITableView {
   func registerCell(identifire:String){
       self.register(UINib(nibName: identifire, bundle: nil), forCellReuseIdentifier: identifire)
   }
}

extension Array {
    mutating func remove(atOffsets offsets: IndexSet) {
        for offset in offsets.sorted(by: >) {
            self.remove(at: offset)
        }
    }
}
