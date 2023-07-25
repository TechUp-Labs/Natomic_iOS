//
//  Global.swift
//  Natomic
//
//  Created by Archit's Mac on 26/06/23.
//

import Foundation
import UIKit




var IS_FROME_NOTIFICATION : Bool?


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
