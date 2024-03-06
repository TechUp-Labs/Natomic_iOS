//
//  ImageTheameModel.swift
//  Natomic
//
//  Created by Archit Navadiya on 06/02/24.
//

import Foundation
import UIKit


struct ImageTheameModel {
    
    var imageName       : String
    var backgroundColor : String
    var textColor       : UIColor
    
    init(imageName: String, textColor: UIColor, backgroundColor: String) {
        self.imageName = imageName
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
    
}


struct ThemeTableData {
    var themeTitle:String?
    var themes : [ImageTheameModel]?
}
