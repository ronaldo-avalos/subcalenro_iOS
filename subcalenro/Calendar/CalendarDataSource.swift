//
//  FSCalendarDateSource.swift
//  subcalenro
//
//  Created by ronaldo avalos on 03/10/24.
//
import Foundation
import FSCalendar
import EventKit

final class CalendarDataSource: NSObject, FSCalendarDataSource {
    
    private let calendar : FSCalendar
    private var eventColorsDict: [Date: UIColor] = [:]
    var didCellFor: ((Date, CalendarViewCell) -> Void)?

    private(set) var subscriptions: [(Date,Subscription)] = [] {
        didSet {
            DispatchQueue.main.async {
                self.calendar.reloadData()
            }
        }
    }
    
    func set(subs: [(Date,Subscription)]) {
        self.subscriptions = subs
    }
    
    init(calendar: FSCalendar) {
        self.calendar = calendar
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position) as! CalendarViewCell
        didCellFor?(date, cell)
        return cell
    }
}

