//
//  DeleteAccountAlertVC.swift
//  Natomic
//
//  Created by Archit Navadiya on 02/01/24.
//

import UIKit

class DeleteAccountAlertVC: UIViewController {
    
    var dismissDeleteScreen : DismissDeleteScreen?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancelBTNtapped(_ sender: Any) {
//        dismiss()
        TrackEvent.shared.track(eventName: .closeDeleteAlertButtonClick)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func deleteBTNtapped(_ sender: Any) {
        TrackEvent.shared.track(eventName: .deleteAppDataButtonClick)
        deleteUserData()
    }
    
    func deleteUserData(){
        Loader.shared.startAnimating()
        DatabaseHelper.shared.deleteUserNote(uid: UID) { result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(ResponseModel.self, from: responseData)
                        // Now you have your response object
                        print("Successfully Delete data:", response)
                        TrackEvent.shared.track(eventName: .deleteAppDataSuccessfullyButtonClick)
                        Loader.shared.stopAnimating()
//                        self.dismiss()
                        self.dismiss(animated: false, completion: nil)
                        self.dismissDeleteScreen?.dismissDeleteVC()
                    } catch let error {
                        print("Error decoding response:", error.localizedDescription)
                        Loader.shared.stopAnimating()
                        showAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                Loader.shared.stopAnimating()
                showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}
