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
                print(user.displayName)
                print(user.photoURL)

//                // You can access user information here.
//                let userId = user.uid // Google user ID
//                let fullName = user.profile?.name // User's full name
//                let givenName = user.profile?.givenName // User's first name
//                let familyName = user.profile?.familyName // User's last name
//                let email = user.profile?.email // User's email
//                let profileImageURL = user.profile?.imageURL(withDimension: 200) // URL for the user's profile image
//
//                // Print the retrieved information
//                print("User ID: \(userId ?? "")")
//                print("Full Name: \(fullName ?? "")")
//                print("First Name: \(givenName ?? "")")
//                print("Last Name: \(familyName ?? "")")
//                print("Email: \(email ?? "")")
//                print("Profile Image URL: \(profileImageURL?.absoluteString ?? "")")

                // Now, you can use this user information as needed.
                
                // Create a Firebase credential from the Google Sign-In information and sign in with Firebase Authentication
//                if let idToken = user.authentication.idToken {
//                    let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.authentication.accessToken)
//                    Auth.auth().signIn(with: credential) { authResult, error in
//                        if let error = error {
//                            print("Firebase Authentication Error: \(error.localizedDescription)")
//                        } else {
//                            print("User signed in with Firebase")
//                        }
//                    }
//                }
            }
        }

        
            
        
        //        handleAuthorization()
//        saveDataInUserDefault(value:true, key: "IS_LOGIN")
//        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backBTNtapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tryFreeBTNtapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
