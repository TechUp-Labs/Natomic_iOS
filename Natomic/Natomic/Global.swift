//
//  Global.swift
//  Natomic
//
//  Created by Archit's Mac on 26/06/23.
//

import Foundation
import UIKit

var IS_FROME_NOTIFICATION : Bool?

var IS_FROME_NOTE_NOTIFICATION : Bool?

var NOTIFICATION_DESCRIPTION : String?

var homeVC : UIViewController!

var SHARED_IMAGE = "#FFFFFF"

var SHARED_Text = ""

// MARK: - Globale Functions.

var CurrentDate:String{
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.dateFormat = "yyyy-M-d"
    let formattedDate = dateFormatter.string(from: currentDate)
    print("Current date: \(formattedDate)")
    return formattedDate
}

var CurrentTime:String{
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss"
    let formattedTime = dateFormatter.string(from: currentDate)
    print("Current time: \(formattedTime)")
    return formattedTime
}

enum TimeFormatError: Error {
    case invalidHour
    case invalidMinute
    case invalidMeridiem
}

func convertTo24HourFormat(hour: Int, minute: Int, meridiem: String) throws -> (Int, Int) {
    guard hour >= 1 && hour <= 12 else {
        throw TimeFormatError.invalidHour
    }
    
    guard minute >= 0 && minute <= 59 else {
        throw TimeFormatError.invalidMinute
    }
    
    guard meridiem == "AM" || meridiem == "PM" else {
        throw TimeFormatError.invalidMeridiem
    }
    
    var convertedHour = hour
    if meridiem == "PM" {
        if hour != 12 {
            convertedHour += 12
        }
    } else if meridiem == "AM" {
        if hour == 12 {
            convertedHour = 0
        }
    }
    
    return (convertedHour, minute)
}


func flipDateString(_ dateString: String) -> String? {
    let components = dateString.components(separatedBy: "-")
    
    // Ensure that the string has the expected number of components
    guard components.count == 3 else {
        return nil
    }
    
    let flippedDateString = "\(components[2])-\(components[1])-\(components[0])"
    return flippedDateString
}

 // MARK: - Structure for notification :-

struct UsersNotification {
    var hour : Int?
    var minutes : Int?
    var meridiem: String {
        return setMeridiem(value: hour ?? 0)
    }

    func setMeridiem(value: Int) -> String {
        return value >= 12 ? "PM" : "AM"
    }
}

func hasNotch() -> Bool {
    if #available(iOS 11.0, *) {
        let window = UIApplication.shared.windows.first
        return window?.safeAreaInsets.top ?? 0 > 20
    }
    return false
}

    func showAlert(title: String, message: String, okActionHandler: ((UIAlertAction) -> Void)? = nil, cancelActionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add "Ok" action
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: okActionHandler)
        alertController.addAction(okAction)
        
        // Add "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelActionHandler)
        alertController.addAction(cancelAction)
        
        // Get the top-most view controller
        if let topController = UIApplication.shared.keyWindow?.rootViewController?.topMostViewController() {
            topController.present(alertController, animated: true, completion: nil)
        }
    }

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presentedViewController = presentedViewController {
            return presentedViewController.topMostViewController()
        }
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.topMostViewController() ?? self
        }
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topMostViewController() ?? self
        }
        return self
    }
}
