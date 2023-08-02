//
//  TextDetailVC.swift
//  Natomic
//
//  Created by Archit's Mac on 02/08/23.
//

import UIKit

class TextDetailVC: AlertBase {

    @IBOutlet weak var textLBL: UILabel!
    @IBOutlet weak var dayLBL: UILabel!
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var timeLBL: UILabel!
    
    var selectedData : UserEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLBL.text = selectedData?.userThoughts ?? ""
        dayLBL.text = "Day \(selectedData?.day ?? "")"
        dateLBL.text = DatabaseMabager.Shared.convertDateFormat(selectedData?.date ?? "")
        timeLBL.text = "-    " + DatabaseMabager.Shared.convertTo12HourFormat(selectedData?.time ?? "")!
    }
    
    @IBAction func closeBTNtapped(_ sender: Any) {
        dismiss {
            print("dismiss")
        }
    }
    

}
