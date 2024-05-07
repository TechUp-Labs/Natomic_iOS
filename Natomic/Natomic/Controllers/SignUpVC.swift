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
import Mixpanel

import AuthenticationServices

class SignUpVC: UIViewController {
    
    // MARK: - ViewController Life Cycle:-
    
    
    // MARK: - Variable's : -
    
    let reachability = try! Reachability()
    let slideInTransition = SlideInTransition()
    var delegate : ReloadHomeScreenData?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slideInTransition.isPresenting = true
        return slideInTransition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slideInTransition.isPresenting = false
        return slideInTransition
    }

    // MARK: - All Fuction's : -

    
    // MARK: - Button Action's : -
    
    @IBAction func googleLoginBTNtapped(_ sender: Any) {
        TrackEvent.shared.track(eventName: .googleSignupButtonClick)
        loginWithGoogle()
    }
    
    
    @IBAction func backBTNtapped(_ sender: Any) {
        TrackEvent.shared.track(eventName: .signupBackButtonClick)
//        let transition = CATransition()
//        transition.duration = 0.3
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromRight
//        navigationController?.view.layer.add(transition, forKey: kCATransition)
        
        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func appleLoginBTNtapped(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        TrackEvent.shared.track(eventName: .appleSignupButtonClick)
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
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
            Loader.shared.startAnimating()
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                guard error == nil else {
                    print(error?.localizedDescription ?? "")
                    Loader.shared.stopAnimating()
                    return
                }
                
                guard let user = result?.user else {
                    print("Failed to get user info from Google Sign-In")
                    Loader.shared.stopAnimating()
                    return
                }
                print(user.uid)
                TrackEvent.shared.registerUser(userIID: user.uid)
                TrackEvent.shared.track(eventName: .signUpWithGoogle)
                saveDataInUserDefault(value: user.uid, key: "UID")
                print(user.displayName as Any)
                saveDataInUserDefault(value: user.displayName, key: "USER_NAME")
                saveDataInUserDefault(value: user.email, key: "USER_EMAIL")
                saveDataInUserDefault(value: user.photoURL?.absoluteString, key: "PHOTO_URL")
                print(user.photoURL as Any)
                saveDataInUserDefault(value:true, key: "IS_LOGIN")
                Loader.shared.stopAnimating()
                self.registerUser(uid: user.uid, name: user.displayName ?? "", email: user.email ?? "")
            }
        }

    }
}

extension SignUpVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let identityTokenData = appleIDCredential.identityToken else {
                print("Apple Sign In Error: Identity token is nil.")
                return
            }

            // Convert the identity token to a string
            let identityToken = String(data: identityTokenData, encoding: .utf8)

            // Send the identityToken to Firebase for verification and sign in
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: identityToken!, rawNonce: "")

            Auth.auth().signIn(with: credential) { (authResult, error) in
                // Handle the sign-in result
                if let error = error {
                    print("Error signing in with Apple: \(error.localizedDescription)")
                } else {
                    // Access user information from authResult
                    guard let user = authResult?.user else {
                        // Handle the case where the user is nil
                        return
                    }

                    // Access user information from the Apple ID credential
                    let uid = user.uid
                    let displayName = appleIDCredential.fullName?.givenName ?? "Natomic"
                    let email = appleIDCredential.email ?? "User"
                    print("Successfully signed in with Apple!")
                    print("UID: \(uid)")
                    print("Display Name: \(displayName)")
                    print("Email: \(email)")
                    TrackEvent.shared.registerUser(userIID: uid)
                    TrackEvent.shared.track(eventName: .signUpWithApple)
                    saveDataInUserDefault(value: uid, key: "UID")
                    print(user.displayName as Any)
                    saveDataInUserDefault(value: displayName, key: "USER_NAME")
                    saveDataInUserDefault(value: email, key: "USER_EMAIL")
                    saveDataInUserDefault(value: user.photoURL?.absoluteString, key: "PHOTO_URL")
                    print(user.photoURL as Any)
                    saveDataInUserDefault(value:true, key: "IS_LOGIN")
                    self.registerUser(uid: uid, name: displayName, email: email)

                }
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle errors
        print("Apple Sign In Error: \(error.localizedDescription)")
    }
}
extension SignUpVC {
    func registerUser(uid:String,name:String,email:String){
        DatabaseHelper.shared.registerUser(uid: uid, name: name, email: email) { result in
            switch result {
            case .success(let message):
                // Registration was successful, and you can handle the success message
                print("Success: \(message)")
                
                DatabaseHelper.shared.fetchUserData { result in
                    switch result {
                    case .success(let NoteModel):
                        guard let data = NoteModel.response else {
                            NotificationCenter.default.post(name: .setUserData, object: nil)
                            self.dismiss(animated: true, completion: nil)
//                            self.navigationController?.popViewController(animated: true)
                            return
                        }
                        for i in data {
                            let userContext = User(userThoughts: i.note ?? "", date: i.notedate ?? "", time: i.notetime ?? "", day: "\(DatabaseManager.Shared.getUserContext().count + 1)", noteID: i.noteID ?? "")
                            
                            DatabaseManager.Shared.addUserContext(userContext: userContext)
                        }
                        NotificationCenter.default.post(name: .setUserData, object: nil)
                        self.dismiss(animated: true) {
                            self.delegate?.reloadUserData()
                        }

//                        self.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                        self.dismiss(animated: true) {
                            self.delegate?.reloadUserData()
                        }
//                        self.navigationController?.popViewController(animated: true)
                    }
                
                }
            case .failure(let error):
                // Registration failed, and you can handle the error
                print("Error: \(error.localizedDescription)")
                self.dismiss(animated: true) {
                    self.delegate?.reloadUserData()
                }
//                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
