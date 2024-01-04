//
//  DeleteAccountAlertVC.swift
//  Natomic
//
//  Created by Archit Navadiya on 02/01/24.
//

import UIKit

class DeleteAccountAlertVC: AlertBase {
    
    var dismissDeleteScreen : DismissDeleteScreen?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancelBTNtapped(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func deleteBTNtapped(_ sender: Any) {
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
                        Loader.shared.stopAnimating()
                        self.dismiss()
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
