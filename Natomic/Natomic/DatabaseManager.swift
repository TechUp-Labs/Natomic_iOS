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
