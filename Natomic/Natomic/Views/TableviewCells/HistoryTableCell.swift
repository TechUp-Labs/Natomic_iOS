//
//  HistoryTableCell.swift
//  Natomic
//
//  Created by Archit's Mac on 24/07/23.
//

import UIKit

class HistoryTableCell: UITableViewCell {

    @IBOutlet weak var usersTextLBL: UILabel!
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var timeLBL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func displayData(data:UserEntity){
        usersTextLBL.text = data.userThoughts ?? ""
        dateLBL.text = DatabaseMabager.Shared.convertDateFormat(data.date ?? "")
        timeLBL.text = DatabaseMabager.Shared.convertTo12HourFormat(data.time ?? "")
    }
        
}
