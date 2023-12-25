//
//  SignUpVC.swift
//  Natomic
//
//  Created by Archit's Mac on 26/07/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

import AuthenticationServices

class SignUpVC: UIViewController {
    
    // MARK: - ViewController Life Cycle:-
    
    
    // MARK: - Variable's : -
    
    let reachability = try! Reachability()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - All Fuction's : -
    
    func handleAuthorization() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email] // Request additional user information if needed
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    // MARK: - Button Action's : -
    
    @IBAction func SignUpBTNtapped(_ sender: Any) {
        
        checkInternet()
    }
    
    func checkInternet(){
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Wifi Connection 😃")
            loginWithGoogle()
        case .cellular:
            print("Cellular Connection 😃")
            loginWithGoogle()
        case .unavailable:
            print("No Connection ☹️")
            showAlert(title: "No Internet Connection", message: "Please check your internet connection.")
        }
    }
    
    @IBAction func backBTNtapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tryFreeBTNtapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loginWithGoogle(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                return print(error?.localizedDescription ?? "")
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return print("")
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                guard error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                
                guard let user = result?.user else {
                    print("Failed to get user info from Google Sign-In")
                    return
                }
                print(user.uid)
                saveDataInUserDefault(value: user.uid, key: "UID")
                print(user.displayName as Any)
                saveDataInUserDefault(value: user.displayName, key: "USER_NAME")
                saveDataInUserDefault(value: user.email, key: "USER_EMAIL")
                print(user.photoURL as Any)
                saveDataInUserDefault(value:true, key: "IS_LOGIN")
                DatabaseHelper.shared.registerUser(uid: user.uid, name: user.displayName ?? "", email: user.email ?? "") { result in
                    switch result {
                    case .success(let message):
                        // Registration was successful, and you can handle the success message
                        print("Success: \(message)")
                        self.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        // Registration failed, and you can handle the error
                        print("Error: \(error.localizedDescription)")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
                DatabaseHelper.shared.fetchUserData { result in
                    switch result {
                    case .success(let NoteModel):
                        guard let data = NoteModel.response else {
                            return
                        }
                        for i in data {
                            let userContext = User(userThoughts: i.note ?? "", date: i.notedate ?? "", time: i.notetime ?? "", day: "\(DatabaseManager.Shared.getUserContext().count + 1)")
                            
                            DatabaseManager.Shared.addUserContext(userContext: userContext)
                        }
                        NotificationCenter.default.post(name: .setUserData, object: nil)
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                
                }

                
                
            }
            //                handleAuthorization()
        }

    }
    

    
}


extension SignUpVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Use the credential for further actions (e.g., user identification, sign-up, etc.)
            let userIdentifier = appleIDCredential.user
            // Access user data if needed
            if let email = appleIDCredential.email, let fullName = appleIDCredential.fullName {
                // Handle user data
                print("Email:", email)
                print("Full Name:", fullName)
            }
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
}
