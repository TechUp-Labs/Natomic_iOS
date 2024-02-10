//
//  AppDelegate.swift
//  Natomic
//
//  Created by Archit's Mac on 23/06/23.
//

import UIKit
import CoreData
import UserNotifications
import IQKeyboardManagerSwift
import FirebaseCore
import FirebaseAnalytics
import GoogleSignIn
import Foundation
@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in 
            if granted {
                // Set the delegate for UNUserNotificationCenter to handle notifications
            }else {
                // User denied permission
            }
        }
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done"
        IQKeyboardManager.shared.toolbarTintColor = #colorLiteral(red: 0.06300000101, green: 0.05900000036, blue: 0.05099999905, alpha: 1)
        postDeletePendingData()
        NotificationCenter.default.post(name: .setUserData, object: nil)
        return true
    }
    
    func postDeletePendingData() {
        var deletePendingData = getDeletePendingDataModelArray(forKey: "DELETE_PENDING_DATA_ARRAY") ?? []

        if deletePendingData.count != 0 {
            let dispatchGroup = DispatchGroup()
            var indicesToRemove: [Int] = []

            for (index, pendingData) in deletePendingData.enumerated() {
                dispatchGroup.enter()

                DatabaseHelper.shared.deleteUserNoteByID(noteId: pendingData.noteID ?? "0") { result in
                    defer {
                        dispatchGroup.leave()
                    }

                    switch result {
                    case .success(let responseData):
                        do {
                            let decoder = JSONDecoder()
                            let response = try decoder.decode(ResponseModel.self, from: responseData ?? Data())

                            // Now you have your response object
                            print("Successfully deleted data:", response)

                            // Add the index to the list of indices to remove
                            indicesToRemove.append(index)
                        } catch let error {
                            print("Error decoding response:", error.localizedDescription)
                            // Handle the decoding error if necessary
                        }

                    case .failure(let error):
                        // Handle error
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }

            dispatchGroup.notify(queue: .main) {
                self.postEditedPendingData()

                // Remove the processed elements from the array in a safe way
                let indexesToRemoveSet = Set(indicesToRemove)
                deletePendingData = deletePendingData.enumerated().filter { !indexesToRemoveSet.contains($0.offset) }.map { $0.element }

                // Update UserDefaults with the updated array
                saveDeletePendingDataModelArray(deletePendingData, forKey: "DELETE_PENDING_DATA_ARRAY")
            }
        }else{
            self.postEditedPendingData()
        }
    }

    
    func postEditedPendingData() {
        var editedPendingData = getEditPendingDataModelArray(forKey: "EDIT_PENDING_DATA_ARRAY") ?? []

        if editedPendingData.count != 0 {
            let dispatchGroup = DispatchGroup()
            var indicesToRemove: [Int] = []

            for (index, editedData) in editedPendingData.enumerated() {
                dispatchGroup.enter()

                DatabaseHelper.shared.editUserNoteByID(noteId: editedData.noteID ?? "", newNote: editedData.newNote ?? "") { result in
                    defer {
                        dispatchGroup.leave()
                    }

                    switch result {
                    case .success(let responseData):
                        do {
                            let decoder = JSONDecoder()
                            let response = try decoder.decode(ResponseModel.self, from: responseData ?? Data())

                            // Now you have your response object
                            print("Successfully edited data:", response)

                            // Add the index to the list of indices to remove
                            indicesToRemove.append(index)
                        } catch let error {
                            print("Error decoding response:", error.localizedDescription)
                            // Handle the decoding error if necessary
                        }

                    case .failure(let error):
                        // Handle error
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }

            dispatchGroup.notify(queue: .main) {
                NotificationCenter.default.addObserver(self, selector: #selector(self.getUserData(notification:)), name: .setUserData, object: nil)
                // Remove the processed elements from the array in a safe way
                let indexesToRemoveSet = Set(indicesToRemove)
                editedPendingData = editedPendingData.enumerated().filter { !indexesToRemoveSet.contains($0.offset) }.map { $0.element }

                // Update UserDefaults with the updated array
                saveEditPendingDataModelArray(editedPendingData, forKey: "EDIT_PENDING_DATA_ARRAY")
            }
        }else{
            NotificationCenter.default.addObserver(self, selector: #selector(self.getUserData(notification:)), name: .setUserData, object: nil)
        }
    }

    
    @objc func getUserData(notification:Notification){
        if IS_LOGIN {
            DatabaseHelper.shared.fetchUserData { result in
                switch result {
                case .success(let NoteModel):
                    var pendingData = getPendingDataModelArray(forKey: "PENDING_DATA_ARRAY") ?? []

                    if pendingData.count != 0 {
                        let dispatchGroup = DispatchGroup()
                        var indicesToRemove: [Int] = []

                        for (index, data) in pendingData.enumerated() {
                            dispatchGroup.enter()

                            DatabaseHelper.shared.postUserNote(uid: UID, note: data.userThoughts ?? "", date: data.date ?? "", time: data.time ?? "") { result in
                                defer {
                                    dispatchGroup.leave()
                                }

                                switch result {
                                case .success(let responseData):
                                    do {
                                        let decoder = JSONDecoder()
                                        let response = try decoder.decode(ResponseModelNotes.self, from: responseData ?? Data())

                                        // Now you have your response object
                                        print("Successfully posted data:", response)
                                        
                                        guard let oldUserContext = DatabaseManager.Shared.getUserContext(forDay: data.day ?? "").first else {return}
                                        
                                        DatabaseManager.Shared.editUserContext(oldUserContext: oldUserContext, newUserContext: User.init(userThoughts: data.userThoughts ?? "", date: data.date ?? "", time: data.time ?? "", day: data.day ?? "", noteID: String(response.noteID)))                                        
                                        NotificationCenter.default.post(name: .saveUserData, object: nil)

                                        // Add the index to the list of indices to remove
                                        indicesToRemove.append(index)
                                    } catch let error {
                                        print("Error decoding response:", error.localizedDescription)
                                        // Handle the decoding error if necessary
                                    }

                                case .failure(let error):
                                    // Handle error
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
                        }

                        dispatchGroup.notify(queue: .main) {
                            // Remove the processed elements from the array in a safe way
                            let indexesToRemoveSet = Set(indicesToRemove)
                            pendingData = pendingData.enumerated().filter { !indexesToRemoveSet.contains($0.offset) }.map { $0.element }

                            // Update UserDefaults with the updated array
                            savePendingDataModelArray(pendingData, forKey: "PENDING_DATA_ARRAY")
                        }
                    }


                    self.dataCheck()

                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    func dataCheck(){
        DatabaseHelper.shared.fetchUserData { result in
            switch result{
            case.success(let NoteModel):
                
                if DatabaseManager.Shared.getUserContext().count == NoteModel.response?.count ?? 0 {
                        print("All good")
                    
                    for localData in DatabaseManager.Shared.getUserContext() {
                        guard let localNoteID = localData.userThoughts else {
                            continue
                        }
                        
                        // Find matching response in APIDataArray
                        if let matchingResponse = NoteModel.response?.first(where: { $0.note == localNoteID }) {
                            // Update the noteID in local data
                            localData.noteID = matchingResponse.noteID
                            
                            // Save the changes if needed
                            // Assuming DatabaseManager.Shared.editUserContext(oldUserContext:newUserContext:) updates the existing entity
                            DatabaseManager.Shared.editUserContext(oldUserContext: localData, newUserContext: User.init(userThoughts: localData.userThoughts ?? "", date: localData.date ?? "", time: localData.time ?? "", day: localData.day ?? "", noteID: localData.noteID ?? ""))
                        }
                    }
                }else{
                        
                        let pendingData = getPendingDataModelArray(forKey: "PENDING_DATA_ARRAY") ?? []

                        if DatabaseManager.Shared.getUserContext().count > NoteModel.response?.count ?? 0 && !pendingData.isEmpty {
//                            var indicesToRemove: [Int] = []
//
//                            for (index, data) in pendingData.enumerated() {
//                                DatabaseHelper.shared.postUserNote(uid: UID, note: data.userThoughts ?? "", date: data.date ?? "", time: data.time ?? "") { result in
//                                    switch result {
//                                    case .success(let data):
//                                        if let responseData = data {
//                                            do {
//                                                let decoder = JSONDecoder()
//                                                let response = try decoder.decode(ResponseModel.self, from: responseData)
//                                                // Now you have your response object
//                                                print("Successfully posted data:", response)
//                                                
//                                                // Add the index to the list of indices to be removed
//                                                indicesToRemove.append(index)
//                                            } catch let error {
//                                                print("Error decoding response:", error.localizedDescription)
                                                // Handle the decoding error if necessary
//                                            }
//                                        }
//
//                                    case .failure(let error):
//                                        // Handle error
//                                        print("Error: \(error.localizedDescription)")
//                                    }
//                                }
//                            }
//
//                            // Remove the successfully processed elements from pendingData
//                            let updatedPendingData = pendingData.enumerated().compactMap { indicesToRemove.contains($0.offset) ? nil : $0.element }
//
//                            // Update UserDefaults with the updated array
//                            savePendingDataModelArray(updatedPendingData, forKey: "PENDING_DATA_ARRAY")
                        }else{
                            
                            if let response = NoteModel.response {
                                let totalCount = response.count
                                let userContextCount = DatabaseManager.Shared.getUserContext().count

                                // Ensure dataCount is within the bounds of the array
                                let dataCount = max(0, min(totalCount, totalCount - userContextCount))

                                for data in response.prefix(dataCount) {
                                    let userContext = User(userThoughts: data.note ?? "",
                                                           date: data.notedate ?? "",
                                                           time: data.notetime ?? "",
                                                           day: "\(userContextCount + 1)",
                                                           noteID: data.noteID ?? "")

                                    DatabaseManager.Shared.addUserContext(userContext: userContext)
                                    NotificationCenter.default.post(name: .saveUserData, object: nil)
                                }
                            }

                        }
                    }
            case.failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let window = UIApplication.shared.keyWindow else {return}
        IS_FROME_NOTIFICATION = true
        let navController = UINavigationController(rootViewController: HOME_VC)
        navController.isNavigationBarHidden = true
        navController.modalPresentationStyle = .fullScreen
        window.rootViewController = navController
        window.makeKeyAndVisible()
        
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Natomic")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data  protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
   
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension Notification.Name {
    static let setUserData = Notification.Name("SetUserData")
}

class CustomURLSessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        
        if let serverTrust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
