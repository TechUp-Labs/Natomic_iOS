//
//  MenuTableViewCell.swift
//  Natomic
//
//  Created by Archit Navadiya on 25/08/23.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    // MARK: - Outlet's :-
    
    @IBOutlet weak var menuImg: UIImageView!
    @IBOutlet weak var menuLBL: UILabel!
    @IBOutlet weak var arrowImg: UIImageView!
    
    // MARK: - UITableViewCell Life Cycle:-
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - All Fuction's : -
    
    
    // MARK: - Button Action's : -
    
    
}
