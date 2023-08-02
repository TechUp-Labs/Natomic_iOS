//
//  Constant.swift
//  Natomic
//
//  Created by Archit's Mac on 20/07/23.
//

import Foundation
import UIKit

var HEIGHT = UIScreen.main.bounds.height

var WIDTH = UIScreen.main.bounds.width

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

var HOME_NAV : UINavigationController {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
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

var PROFILE_VC : ProfileVC {
   get{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
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

func saveDataInUserDefault(value:Any?, key: String){
    let Default = UserDefaults.standard
    Default.set(value, forKey: key)
    Default.synchronize()
}

func getDataFromUserDefaults(forKey key: String) -> Any? {
    let defaults = UserDefaults.standard
    return defaults.object(forKey: key)
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

