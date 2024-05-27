//
//  Natomic_WidgetBundle.swift
//  Natomic Widget
//
//  Created by Archit Navadiya on 13/03/24.
//

import WidgetKit
import SwiftUI

@main
struct Natomic_WidgetBundle: WidgetBundle {
    var body: some Widget {
        Natomic_Widget()
        Streak_SmallView()
        Streak_MediumView()
    }
}
