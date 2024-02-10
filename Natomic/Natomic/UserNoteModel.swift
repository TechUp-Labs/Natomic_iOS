//
//  UserNoteModel.swift
//  Demo_Natomic_API_Test
//
//  Created by Archit Navadiya on 14/09/23.
//

import Foundation

// MARK: - UserNoteModel
struct UserNoteModel: Codable {
    let code: Int?
    let mesage: String?
    let response: [Response]?
}

// MARK: - Response
struct Response: Codable {
    let uid, email, name, note, notedate, notetime, noteID: String?
    let createAt: String?

    enum CodingKeys: String, CodingKey {
        case uid, email, name, note
        case createAt = "create_at"
        case notedate = "note_date"
        case notetime = "note_time"
        case noteID = "id"
    }
}


// MARK: - Response
struct ResponseModel: Codable {
    let code: Int
    let message: String
}


// MARK: - Response Model For Notes
struct ResponseModelNotes: Codable {
    let code: Int
    let message: String
    let noteID: Int
}
