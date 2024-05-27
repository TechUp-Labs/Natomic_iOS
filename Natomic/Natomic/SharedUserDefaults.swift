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
        static let streak = "streak"
        static let launchedFromWidget = "launchedFromWidget"
        static let weekData = "weekData"
    }
}

// MARK: - Save Week Data to UserDefaults

func saveWeekDataToUserDefaults(weekData: [WeekDayData]) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(weekData) {
        sharedUserDefaults?.set(encoded, forKey: SharedUserDefaults.Keys.weekData)
    } else {
        print("Failed to encode week data")
    }
}

// MARK: - Retrieve Week Data from UserDefaults

func retrieveWeekDataFromUserDefaults() -> [WeekDayData]? {
    if let savedWeekData = sharedUserDefaults?.data(forKey: SharedUserDefaults.Keys.weekData) {
        let decoder = JSONDecoder()
        if let loadedWeekData = try? decoder.decode([WeekDayData].self, from: savedWeekData) {
            return loadedWeekData
        } else {
            print("Failed to decode week data")
        }
    }
    return nil
}
