//
//  CustomFSCalendar.swift
//  subcalenro
//
//  Created by ronaldo avalos on 10/10/24.
//

import Foundation
import UIKit
import FSCalendar


class CustomFSCalendar: FSCalendar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCalendar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCalendar() {
        register(CalendarViewCell.self, forCellReuseIdentifier: "cell")
        scrollDirection = .vertical
        pagingEnabled = true
        appearance.selectionColor = .clear
        appearance.todayColor = .clear
        appearance.titleDefaultColor = .clear
        appearance.headerSeparatorColor = .clear
        appearance.separators = .none
        appearance.headerTitleFont = UIFont(name: "SFProRounded-Regular", size: 30)
        appearance.headerTitleAlignment = .left
        appearance.headerTitleOffset = CGPoint(x: 12, y: 0)
        appearance.headerDateFormat = "MMMM"
        appearance.headerTitleColor = ThemeManager.color(for: .primaryText)
        appearance.titleSelectionColor = .clear
        weekdayHeight = 12
        appearance.weekdayTextColor =  ThemeManager.color(for: .primaryText)
        appearance.caseOptions = .weekdayUsesSingleUpperCase
        appearance.weekdayFont = UIFont(name: "SFProDisplay-Medium", size: 10)
        appearance.titlePlaceholderColor = .clear
        placeholderType = .fillHeadTail
        adjustsBoundingRectWhenChangingMonths = true
        rowHeight = 40
        allowsMultipleSelection = false
        today = nil
        firstWeekday = UInt(PreferencesManager.shared.firstWeekday)
    }
    
}
