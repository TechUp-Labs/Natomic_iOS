//
//  DatabaseManager.swift
//  Natomic
//
//  Created by Archit's Mac on 23/06/23.
//

import Foundation
import UIKit
import CoreData

// MARK: - Class For Save Data In Core Database:-

class DatabaseManager {
    
    static let Shared = DatabaseManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Function For Add User Data in Core Database:-
    
    func addUserContext(userContext:User){
        let userEntity = UserEntity(context: context)
        userEntity.userThoughts = userContext.userThoughts
        userEntity.date = userContext.date
        userEntity.time = userContext.time
        userEntity.day = userContext.day
        userEntity.noteID = userContext.noteID
        do{
            try context.save()
            print("User Data Save Successfully...😍")
        }catch{
            print("User Context Saving Error: 😞",error)
        }
    }
    
    // MARK: - Function For get User Data from Core Database:-
    
    func getUserContext() -> [UserEntity]{
        var userData: [UserEntity] = []
        
        do{
            userData = try context.fetch(UserEntity.fetchRequest())
        }catch{
            print("Fetch Data Error: 😞",error)
        }
        
        return userData
    }
    
    // MARK: - Function For Edit User Data in Core Database:-

    func editUserContext(oldUserContext: UserEntity, newUserContext: User) {
        oldUserContext.userThoughts = newUserContext.userThoughts
        oldUserContext.date = newUserContext.date
        oldUserContext.time = newUserContext.time
        oldUserContext.day = newUserContext.day
        oldUserContext.noteID = newUserContext.noteID
        do {
            try context.save()
            print("User Data Edited Successfully...😍")
        } catch {
            print("User Context Editing Error: 😞", error)
        }
    }

    // MARK: - Function For Delete User Data from Core Database:-

    func deleteUserContext(userContext: UserEntity) {
        context.delete(userContext)
        
        do {
            try context.save()
            print("User Data Deleted Successfully...🗑️")
        } catch {
            print("User Context Deletion Error: 😞", error)
        }
    }
    
    
    // MARK: - Function For get User Data from Core Database based on day:-

    func getUserContext(forDay day: String) -> [UserEntity] {
        var userData: [UserEntity] = []
        
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "day == %@", day)
        
        do {
            userData = try context.fetch(fetchRequest)
        } catch {
            print("Fetch Data Error: 😞", error)
        }
        
        return userData
    }
    
    // MARK: - Function For get User Data from Core Database based on specific date:-

    func getUserContext(forDate dateString: String) -> [UserEntity] {
        var userData: [UserEntity] = []
        
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d"

        // Assuming date is stored as String in "yyyy-MM-dd" format
        fetchRequest.predicate = NSPredicate(format: "date == %@", dateString)

        do {
            userData = try context.fetch(fetchRequest)
        } catch {
            print("Fetch Data for Date Error: 😞", error)
        }
        
        return userData
    }
    
    // MARK: - Function For get User Data from Core Database based on note text:-

    func getUserContext(forNoteText noteText: String) -> [UserEntity] {
        var userData: [UserEntity] = []
        
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()

        // Use CONTAINS[c] for a case insensitive and diacritic insensitive search, or use CONTAINS for case sensitive
        fetchRequest.predicate = NSPredicate(format: "userThoughts CONTAINS[c] %@", noteText)

        do {
            userData = try context.fetch(fetchRequest)
        } catch {
            print("Fetch Data for Note Text Error: 😞", error)
        }
        
        return userData
    }


    

    // MARK: - Function For get User Data from Core Database based on 7 days ago:-

    func getUserContextFor7DaysAgo() -> [UserEntity] {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d"
        let sevenDaysAgoString = dateFormatter.string(from: sevenDaysAgo)
        return getUserContext(forDate: sevenDaysAgoString)
    }

    
    // MARK: - Function For Remove All User Data from Core Database:-

    
    func removeAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            print("All User Data Removed Successfully...🗑️")
        } catch {
            print("Data Removal Error: 😞", error)
        }
    }


    func convertDateFormat(_ dateString: String) -> String? {
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatterInput.date(from: dateString) {
            let dateFormatterOutput = DateFormatter()
//            dateFormatterOutput.dateFormat = "dd/MM/yyyy"
            dateFormatterOutput.dateFormat = "dd MMM, yyyy"
            dateFormatterOutput.locale = Locale(identifier: "en_US_POSIX")
            return dateFormatterOutput.string(from: date)
        }
        return nil // Return nil if the input string is not in the expected format
    }
    
    func convertTo12HourFormat(_ timeString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        if let date = dateFormatter.date(from: timeString) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        }
        
        return nil // Return nil if the input string is not in the expected format
    }

    
}
