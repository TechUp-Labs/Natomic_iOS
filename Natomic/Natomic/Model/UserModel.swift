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
    var noteID       : String?
}

// MARK: - PendingData Data Model:-

struct PendingData : Codable {
    var userThoughts : String?
    var date         : String?
    var time         : String?
    var day          : String?
    var noteID       : String?
    init(userThoughts: String? = nil, date: String? = nil, time: String? = nil, day: String? = nil, noteID: String? = nil) {
        self.userThoughts = userThoughts
        self.date = date
        self.time = time
        self.day = day
        self.noteID = noteID
    }
}

// MARK: - EditPendingData Data Model:-

struct EditPendingData : Codable {
    var noteID : String?
    var newNote   : String?
    init(noteID: String? = nil, newNote: String? = nil) {
        self.noteID = noteID
        self.newNote = newNote
    }
}

struct DeletePendingData : Codable {
    var noteID : String?
    init(noteID: String? = nil) {
        self.noteID = noteID
    }
}
