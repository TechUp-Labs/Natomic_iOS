//
//  SceneDelegate.swift
//  Natomic
//
//  Created by Archit's Mac on 23/06/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        handleQuickAction(shortcutItem, completionHandler: completionHandler)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
        if url.absoluteString == "natomic://openSpecificView" {
            IS_FROME_NOTIFICATION = true
            showHomeViewController()
        }
    }
    
    
    
    func handleQuickAction(_ shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        guard let shortcutItemType = ShortcutItemType(rawValue: shortcutItem.type) else {
            completionHandler(false)
            return
        }
        
        switch shortcutItemType {
        case .writeNow:
            IS_FROME_NOTIFICATION = true
            showHomeViewController()
            break
        }
        
        // Call the completion handler to indicate that you've handled the action
        completionHandler(true)
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        if let urlContext = connectionOptions.urlContexts.first {
            handleURL(urlContext.url)
        }

        // Check for quick actions during app launch
        if let shortcutItem = connectionOptions.shortcutItem {
            handleQuickAction(shortcutItem, completionHandler: { _ in })
        }
        
//        window = UIWindow(windowScene: windowScene)
//        let initialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
//        window?.rootViewController = initialViewController
//        window?.makeKeyAndVisible()
    }
    
    private func handleURL(_ url: URL) {
        if url.absoluteString == "natomic://openSpecificView" {
            IS_FROME_NOTIFICATION = true
            showHomeViewController()
        }
    }
    
    
    private func showHomeViewController() {
        print("showHomeViewController called")
        let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let navController = UINavigationController(rootViewController: homeVC)
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .fullScreen
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

enum ShortcutItemType: String {
    case writeNow = "com.yourapp.writenow"
    // Remove the "newItem" case if not needed
}
