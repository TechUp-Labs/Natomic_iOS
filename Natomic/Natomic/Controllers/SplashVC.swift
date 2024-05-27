//
//  ViewController.swift
//  Natomic
//
//  Created by Archit's Mac on 23/06/23.
//

import UIKit
import WidgetKit

let sharedUserDefaults = UserDefaults(suiteName: SharedUserDefaults.suiteName)


class SplashVC: UIViewController {
    
    // MARK: - Outlet's :-
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var logoWidth: NSLayoutConstraint!
    @IBOutlet weak var logoHeight: NSLayoutConstraint!
    
    // MARK: - Variable's :-
    var userData : [UserEntity]?

    
    // MARK: - ViewController Life Cycle:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        saveUserData()
        
        if let loadedWeekData = retrieveWeekDataFromUserDefaults() {
            for dayData in loadedWeekData {
                print("Date: \(dayData.date), Day: \(dayData.dayName), Has Note: \(dayData.hasNote)")
            }
        } else {
            print("No week data found in UserDefaults")
        }
        
        if IS_STARTED {
            self.navigationController?.pushViewController(HOME_VC, animated: true)
        }else{
            self.navigationController?.pushViewController(WELCOME_VC, animated: true)
        }
        
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        //            self.increaseLogoSize()
        //            self.startRotationAnimation()
        //        }
        
    }
    
    // MARK: - Save Widget to UserDefaults

    
    func saveUserData() {
        sharedUserDefaults?.set(self.userData?.first?.userThoughts ?? "It's time to write one line today!", forKey: SharedUserDefaults.Keys.userNote)
        sharedUserDefaults?.set(self.userData?.first?.time ?? "", forKey: SharedUserDefaults.Keys.noteTime)
        sharedUserDefaults?.set(self.userData?.first?.date ?? "", forKey: SharedUserDefaults.Keys.noteDate)
        sharedUserDefaults?.set("\(DatabaseManager.Shared.calculateStreak())", forKey: SharedUserDefaults.Keys.streak)
        
        let weekData = DatabaseManager.Shared.getCurrentWeekData()
        saveWeekDataToUserDefaults(weekData: weekData)
        
        // Synchronize the UserDefaults
        sharedUserDefaults?.synchronize()
        
        DispatchQueue.main.async {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    

    
    // MARK: - All Fuction's : -
    
    func startRotationAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 1.5) // 360 degrees
        rotationAnimation.duration = 1.0 // Duration of the rotation animation (in seconds)
        rotationAnimation.repeatCount = 1 // Repeat indefinitely
        imgLogo.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func increaseLogoSize() {
        UIView.animate(withDuration: 1.0) {
            self.logoWidth.constant = 154
            self.logoHeight.constant = 154
            self.view.layoutIfNeeded()
        }completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.navigationController!.pushViewController(HOME_VC, animated: false)
            }
        }
    }
    
    
}

