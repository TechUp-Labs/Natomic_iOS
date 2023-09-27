//
//  TextDetailVC.swift
//  Natomic
//
//  Created by Archit's Mac on 02/08/23.
//

import UIKit

class TextDetailVC: AlertBase {
    
    // MARK: - Outlet's :-
    
    @IBOutlet weak var textLBL: UILabel!
    @IBOutlet weak var dayLBL: UILabel!
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var timeLBL: UILabel!
    
    // MARK: - Variable's : -
    
    var selectedData : UserEntity?
    
    // MARK: - ViewController Life Cycle:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLBL.text = selectedData?.userThoughts ?? ""
        dayLBL.text = "Day \(selectedData?.day ?? "")"
        dateLBL.text = DatabaseMabager.Shared.convertDateFormat(selectedData?.date ?? "")
        timeLBL.text = "-    " + DatabaseMabager.Shared.convertTo12HourFormat(selectedData?.time ?? "")!
    }
    
    // MARK: - Button Action's : -
    
    @IBAction func closeBTNtapped(_ sender: Any) {
        dismiss {
            print("dismiss")
        }
    }
    
    
}
