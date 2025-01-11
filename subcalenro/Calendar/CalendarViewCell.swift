//
//  CalendarCell.swift
//  subcalenro
//
//  Created by ronaldo avalos on 03/10/24.
//

import Foundation

import UIKit
import FSCalendar
import EventKit

class CalendarViewCell: FSCalendarCell {
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = FontManager.sfProRounded(size: 16, weight: .medium)
        return label
    }()
    
    private let contentCell : UIView = {
        let content = UIView()
        content.layer.cornerRadius =  10
        content.layer.masksToBounds = true
        content.layer.cornerCurve = .continuous
        return content
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        contentCell.addSubview(dayLabel)
        contentView.addSubview(contentCell)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        contentCell.translatesAutoresizingMaskIntoConstraints = false
        self.contentCell.layer.borderColor = UIColor.white.cgColor
        
        
        NSLayoutConstraint.activate([
            contentCell.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentCell.widthAnchor.constraint(equalTo: contentView.widthAnchor , constant: -2),
            contentCell.heightAnchor.constraint(equalToConstant: contentView.frame.height - 5),
            
            dayLabel.centerXAnchor.constraint(equalTo: contentCell.centerXAnchor),
            dayLabel.topAnchor.constraint(equalTo: contentCell.topAnchor, constant: 10),
            
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentCell.frame = contentView.bounds
        dayLabel.frame = contentCell.bounds
    }
        
    func configure(with date: Date, subs: [(Date, Subscription)]) {
        self.dayLabel.text = String(Calendar.current.component(.day, from: date))
        self.contentCell.backgroundColor = .clear
        self.dayLabel.textColor = ThemeManager.color(for: .primaryText)
        
        // let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        // let fontSize: CGFloat = isIpad ? 18 : 12
        //self.dayLabel.font = UIFont(name: "SFProRounded-Semibold", size: fontSize)
        self.contentCell.subviews.forEach { subview in
            if subview is UIStackView {
                subview.removeFromSuperview()
            }
        }
        self.dayLabel.text = String(Calendar.current.component(.day, from: date))
        let eventDays = subs.filter { Calendar.current.isDate($0.0, inSameDayAs: date) }
        if !eventDays.isEmpty {
            let eventStack =  SubViewBuilder.build(for: subs, on: date)
            if let stack = eventStack {
                contentCell.addSubview(stack)
                contentCell.backgroundColor = .systemGray5.withAlphaComponent(0.2)
                stack.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    stack.centerXAnchor.constraint(equalTo: contentCell.centerXAnchor),
                    stack.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 3)
                ])
            }
        }
        
       
        //MARK: FINES DE SEMANA
        let components = NSCalendar.current.dateComponents([.weekday], from: date)
            if components.weekday == 1 || components.weekday == 7 {
                self.dayLabel.textColor = .label
                let previousDay = components.weekday == 1 ? NSCalendar.current.date(byAdding: .day, value: -1, to: date) : NSCalendar.current.date(byAdding: .day, value: 1, to: date)
                let days = subs.filter { $0.0 == date || $0.0 == previousDay }
                if days.isEmpty {
                    self.dayLabel.textColor = .systemRed
                }
            }
        
        if NSCalendar.current.isDate(date, inSameDayAs: Date()) {
          self.contentCell.backgroundColor = .systemBlue.withAlphaComponent(0.7)
            self.dayLabel.textColor = .white
        }
    }
    
    func configureBackgroud(date: Date) {
        self.contentCell.backgroundColor = ThemeManager.color(for: .secondaryBackground)
        self.dayLabel.textColor = ThemeManager.color(for: .secondaryText)
        self.layoutIfNeeded()
    }

}

