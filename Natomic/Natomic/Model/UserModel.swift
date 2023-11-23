//
//  UserModel.swift
//  Natomic
//
//  Created by Archit's Mac on 23/06/23.
//

import Foundation

// MARK: - User Data Model:-

struct User {
    var userThoughts : String?
    var date         : String?
    var time         : String?
    var day          : String?
}

// MARK: - PendingData Data Model:-

struct PendingData : Codable {
    var userThoughts : String?
    var date         : String?
    var time         : String?
    var day          : String?
    
    init(userThoughts: String? = nil, date: String? = nil, time: String? = nil, day: String? = nil) {
        self.userThoughts = userThoughts
        self.date = date
        self.time = time
        self.day = day
    }
}

