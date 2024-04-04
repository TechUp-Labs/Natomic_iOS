//
//  SharedUserDefaults.swift
//  Natomic
//
//  Created by Archit Navadiya on 07/03/24.
//

import Foundation


struct SharedUserDefaults {
    static let suiteName = "group.natomic.com.techuplabs"
    
    struct Keys {
        static let userNote = "userNote"
        static let noteDate = "noteDate"
        static let noteTime = "noteTime"
        static let launchedFromWidget = "launchedFromWidget"
    }
}
