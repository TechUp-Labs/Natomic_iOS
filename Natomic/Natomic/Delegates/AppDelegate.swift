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
        Analytics.setUserProperty(UIDevice.current.name, forName: "user_device")
        NotificationCenter.default.addObserver(self, selector: #selector(getUserData(notification:)), name: .setUserData, object: nil)
        NotificationCenter.default.post(name: .setUserData, object: nil)

        return true
    }
    
    
    @objc func getUserData(notification:Notification){
        if IS_LOGIN {
            DatabaseHelper.shared.fetchUserData { result in
                switch result {
                case .success(let NoteModel):
                    let pendingData = getPendingDataModelArray(forKey: "PENDING_DATA_ARRAY") ?? []
                    if pendingData.count != 0 {
                        
                            let pendingData = getPendingDataModelArray(forKey: "PENDING_DATA_ARRAY") ?? []
                            for data in pendingData {
                                DatabaseHelper.shared.postUserNote(uid: UID, note: data.userThoughts ?? "", date: data.date ?? "", time: data.time ?? "") { result in
                                    switch result {
                                    case .success(let data):
                                        if let responseData = data {
                                            do {
                                                let decoder = JSONDecoder()
                                                let response = try decoder.decode(ResponseModel.self, from: responseData)
                                                // Now you have your response object
                                                 print("Successfully posted data:", response)
                                                NotificationCenter.default.post(name: .saveUserData, object: nil)
                                            } catch let error {
                                                print("Error decoding response:", error.localizedDescription)
                                                // Handle the decoding error if necessary
                                            }
                                        }
                                        
                                    case .failure(let error):
                                        // Handle error
                                        print("Error: \(error.localizedDescription)")
                                    }
                                }
                            }
                            UserDefaults.standard.removeObject(forKey: "PENDING_DATA_ARRAY")
                        
                    }
                if DatabaseManager.Shared.getUserContext().count == NoteModel.response?.count ?? 0 {
                        print("All good")
                    }else{
                        
                        if DatabaseManager.Shared.getUserContext().count > NoteModel.response?.count ?? 0 {
                            let pendingData = getPendingDataModelArray(forKey: "PENDING_DATA_ARRAY") ?? []
                            for data in pendingData {
                                DatabaseHelper.shared.postUserNote(uid: UID, note: data.userThoughts ?? "", date: data.date ?? "", time: data.time ?? "") { result in
                                    switch result {
                                    case .success(let data):
                                        if let responseData = data {
                                            do {
                                                let decoder = JSONDecoder()
                                                let response = try decoder.decode(ResponseModel.self, from: responseData)
                                                // Now you have your response object
                                                print("Successfully posted data:", response)
                                            } catch let error {
                                                print("Error decoding response:", error.localizedDescription)
                                                // Handle the decoding error if necessary
                                            }
                                        }
                                        
                                    case .failure(let error):
                                        // Handle error
                                        print("Error: \(error.localizedDescription)")
                                    }
                                }
                            }
                            UserDefaults.standard.removeObject(forKey: "PENDING_DATA_ARRAY")
                        }else{
                            
                            var dataCount = (NoteModel.response?.count ?? 0) - DatabaseManager.Shared.getUserContext().count
                            
                            if let response = NoteModel.response {
                                let dataCount = min(dataCount, response.count) // Ensure dataCount is within the bounds of the array
                                
                                for data in response.prefix(dataCount) {
                                    let userContext = User(userThoughts: data.note ?? "", date: data.notedate ?? "", time: data.notetime ?? "", day: "\(DatabaseManager.Shared.getUserContext().count + 1)")
                                    
                                    DatabaseManager.Shared.addUserContext(userContext: userContext)
                                    NotificationCenter.default.post(name: .saveUserData, object: nil)
                                }
                            }
                            
                        }
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
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
