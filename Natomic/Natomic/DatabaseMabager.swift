//
//  DatabaseMabager.swift
//  Natomic
//
//  Created by Archit's Mac on 23/06/23.
//

import Foundation
import UIKit

// MARK: - Class For Save Data In Core Database:-

class DatabaseMabager {
    
    static let Shared = DatabaseMabager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Function For Add User Data in Core Database:-
    
    func addUserContext(userContext:User){
        let userEntity = UserEntity(context: context)
        userEntity.userThoughts = userContext.userThoughts
        userEntity.date = userContext.date
        userEntity.time = userContext.time
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
    
}
