//
//  NoteCollectionViewCell.swift
//  Natomic
//
//  Created by Archit Navadiya on 05/04/24.
//

import UIKit

class NoteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var usersTextLBL: UILabel!
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var timeLBL: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func displayData(data:UserEntity){
        usersTextLBL.text = data.userThoughts ?? ""
        dateLBL.text = DatabaseManager.Shared.convertDateFormat(data.date ?? "")
        timeLBL.text = DatabaseManager.Shared.convertTo12HourFormat(data.time ?? "")
    }

}
