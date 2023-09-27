//
//  HistoryTableCell.swift
//  Natomic
//
//  Created by Archit's Mac on 24/07/23.
//

import UIKit

class HistoryTableCell: UITableViewCell {
    
    // MARK: - Outlet's :-
    
    @IBOutlet weak var usersTextLBL: UILabel!
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var timeLBL: UILabel!
    
    // MARK: - Variable's : -
    
    // MARK: - UITableViewCell Life Cycle:-
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - All Fuction's : -
    
    func displayData(data:UserEntity){
        usersTextLBL.text = data.userThoughts ?? ""
        dateLBL.text = DatabaseMabager.Shared.convertDateFormat(data.date ?? "")
        timeLBL.text = DatabaseMabager.Shared.convertTo12HourFormat(data.time ?? "")
    }
    
    
    // MARK: - Button Action's : -
    
}
