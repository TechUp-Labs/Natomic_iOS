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
        dateLBL.text = convertDateFormat(data.date ?? "")
        timeLBL.text = convertTo12HourFormat(data.time ?? "")
    }
        
    func convertDateFormat(_ dateString: String) -> String? {
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatterInput.date(from: dateString) {
            let dateFormatterOutput = DateFormatter()
            dateFormatterOutput.dateFormat = "dd/MM/yyyy"
            return dateFormatterOutput.string(from: date)
        }
        return nil // Return nil if the input string is not in the expected format
    }
    
    func convertTo12HourFormat(_ timeString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        if let date = dateFormatter.date(from: timeString) {
            dateFormatter.dateFormat = "h.mm a"
            return dateFormatter.string(from: date)
        }
        
        return nil // Return nil if the input string is not in the expected format
    }

}
