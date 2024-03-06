//
//  EditTableView.swift
//  Natomic
//
//  Created by Archit Navadiya on 12/01/24.
//

import UIKit

class EditDeleteTableView: UIView {
    @IBOutlet weak var BGView: UIView!
    @IBOutlet weak var iconeIMGView: UIImageView!
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "EditDeleteTableView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EditDeleteTableView
    }
}