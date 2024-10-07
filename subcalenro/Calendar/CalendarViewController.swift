//
//  ViewController.swift
//  subcalenro
//
//  Created by ronaldo avalos on 02/10/24.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {
    private var calendarView = FSCalendar()
    private var calendarDataSource: CalendarDataSource?
    private var calendarDelegate: CalendarDelegate?
    private var lastTapDate: Date?
    private var dateTapped: Date?
    private var floatingBar: OptionsFloatingBarView!
    var calendarHeight: CGFloat = 0
    var lastCalendarHeight: CGFloat = 500
    var bottomContainer = BottomContainer()
    private var subscriptions: [(Date, Subscription)] = []

    let buttonToday: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Today", for: .normal)
        button.setTitleColor(ThemeManager.color(for: .secondaryText), for: .normal)
        button.backgroundColor =  ThemeManager.color(for: .secondaryBackground)
        button.layer.cornerRadius = 17
        button.titleLabel?.font = UIFont(name: "SFProRounded-Semibold", size: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let detailEvenstIcon = UIImage(systemName: "rectangle.grid.1x2")?.withTintColor(.label, renderingMode: .alwaysOriginal)
    let compactEventsIcon = UIImage(systemName: "ellipsis.rectangle")?.withTintColor(.label, renderingMode: .alwaysOriginal)
    
    let toggleEvents: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont(name: "SFProRounded-Semibold", size: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 15
        image.layer.cornerCurve = .circular
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "profileImage")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subscriptions = SubscriptionsLoader.shared.loadSubscriptionsDate()
        setupViews()
        calendarDataSource?.didCellFor = { (date: Date, cell: CalendarViewCell) in
            self.setupCell(cell: cell, date: date)
        }
        
        calendarDelegate?.didSelectDate = { [weak self] (date: Date, cell: CalendarViewCell) in
            guard let self = self else { return }
            self.handleDateSelection(date: date, cell: cell)
        }
        
        calendarDelegate?.didDeselectDate = { [weak self] (date: Date, cell: CalendarViewCell) in
            self?.setupCell(cell: cell, date: date)
        }
        
        calendarDelegate?.currentPageDidChange = { [weak self] calendar in
            self?.handlePageChange(calendar)
        }
        
        calendarDelegate?.test = { (bounds : CGRect, calendar : FSCalendar) in
            self.calendarView.frame = CGRect(origin: calendar.frame.origin, size: bounds.size)
            self.bottomContainer.frame = CGRect(x: 0, y: calendar.frame.maxY, width: self.view.frame.width, height: 200)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(applyTheme), name: .themeChanged, object: nil)
        
        applyTheme()
        
    }
    // MARK: - Apply Theme
    @objc func applyTheme() {
        view.backgroundColor = ThemeManager.color(for: .primaryBackground)
    }
    
   
    
    // MARK: - Calendar Selection Handling
    private func handleDateSelection(date: Date, cell: CalendarViewCell) {
        if date == self.dateTapped {
  //OPEN NEW EVENT
        } else {
            self.dateTapped = date
        }
        setupCell(cell: cell, date: date)
    }
    
    private func setupCell(cell: CalendarViewCell, date: Date) {
        DispatchQueue.main.async {
            cell.configure(with: date)
            if cell.isSelected {
                cell.configureBackgroud(date: date)
            }
            if cell.isPlaceholder {
                cell.alpha = 0.1
            }
        }
    }
    
    
    // MARK: - Page Change Handling
    private func handlePageChange(_ calendar: FSCalendar) {
        let currentPageComponents = Calendar.current.dateComponents([.year, .month], from: calendar.currentPage)
        var todayComponents = Calendar.current.dateComponents([.year, .month], from: Date())
        todayComponents.day = 1
        
        if let currentPageDate = Calendar.current.date(from: currentPageComponents),
           let todayDate = Calendar.current.date(from: todayComponents) {
            if currentPageDate > todayDate {
//                self.mainView.showTodayButton(false, .up)
            } else if currentPageDate == todayDate {
//                self.mainView.showTodayButton(true, .up)
            } else {
//                self.mainView.showTodayButton(false, .down)
            }
        }
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        let calendarHeight : CGFloat = Utility.isIphoneWithSmallScreen() ? 450 : Utility.isIpad ? 800 : 600
        calendarView.frame = CGRect(x: 0, y:44, width: view.frame.width, height: calendarHeight)
        calendarView.register(CalendarViewCell.self, forCellReuseIdentifier: "cell")
        calendarView.scrollDirection = .vertical
        calendarView.pagingEnabled = true
        calendarView.appearance.selectionColor = .clear
        calendarView.appearance.todayColor = .clear
        calendarView.appearance.titleDefaultColor = .clear
        calendarView.appearance.headerSeparatorColor = .clear
        calendarView.appearance.separators = .none
        calendarView.appearance.headerTitleFont = UIFont(name: "SFProRounded-Regular", size: 30)
        calendarView.appearance.headerTitleAlignment = .left
        calendarView.appearance.headerTitleOffset = CGPoint(x: 12, y: 0)
        calendarView.appearance.headerDateFormat = "MMMM"
        calendarView.appearance.headerTitleColor = ThemeManager.color(for: .primaryText)
        calendarView.appearance.titleSelectionColor = .clear
        calendarView.weekdayHeight = 12
        calendarView.appearance.weekdayTextColor =  ThemeManager.color(for: .primaryText)
        calendarView.appearance.caseOptions = .weekdayUsesSingleUpperCase
        calendarView.appearance.weekdayFont = UIFont(name: "SFProDisplay-Medium", size: 10)
        calendarView.appearance.titlePlaceholderColor = .clear
        calendarView.placeholderType = .fillHeadTail
        calendarView.adjustsBoundingRectWhenChangingMonths = true
        calendarView.rowHeight = 40
        calendarView.allowsMultipleSelection = false
        calendarView.today = nil
        calendarView.firstWeekday = UInt(PreferencesManager.shared.firstWeekday)
        calendarDelegate = CalendarDelegate()
        calendarDataSource = CalendarDataSource(calendar: calendarView)
        calendarView.dataSource = calendarDataSource
        calendarView.delegate = calendarDelegate
        
        let menu = UIMenu(title: "", children: [
            UIAction(title: "Compact", image: compactEventsIcon, handler: { [self] _ in
                toggleEvents.setImage(compactEventsIcon, for: .normal)
            }),
            UIAction(title: "Detail", image: detailEvenstIcon, handler: { [self] _ in
                toggleEvents.setImage(self.detailEvenstIcon, for: .normal)
            })
        ])
        
        toggleEvents.setImage(self.detailEvenstIcon, for: .normal)
        toggleEvents.menu = menu
        toggleEvents.showsMenuAsPrimaryAction = true
        buttonToday.isHidden = true

        
        bottomContainer.frame =  CGRect(x: 0, y: calendarView.frame.maxY, width: view.frame.width, height: 200)

        
        floatingBar = OptionsFloatingBarView()
        floatingBar.delegate = self
        floatingBar.translatesAutoresizingMaskIntoConstraints = false
        let floatingBarWidth: CGFloat = Utility.isIpad ? 320 : 220
        let floatingBarHeight: CGFloat = Utility.isIpad ? 65 : 55
        
        let views = [calendarView,toggleEvents,profileImage,bottomContainer,buttonToday]
        views.forEach(view.addSubview(_:))
        view.addSubview(floatingBar)
        view.backgroundColor = ThemeManager.color(for: .primaryBackground)
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            profileImage.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 30),
            profileImage.heightAnchor.constraint(equalToConstant:30),
            
            toggleEvents.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            toggleEvents.trailingAnchor.constraint(equalTo: profileImage.leadingAnchor,constant: -16),
            
            buttonToday.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -74),
            buttonToday.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonToday.widthAnchor.constraint(equalToConstant: 78),
            buttonToday.heightAnchor.constraint(equalToConstant: 34),
            
            floatingBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            floatingBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            floatingBar.widthAnchor.constraint(equalToConstant: floatingBarWidth),
            floatingBar.heightAnchor.constraint(equalToConstant: floatingBarHeight),
        ])
    }
    
 
    
    func showTodayButton(_ isHidden: Bool,_ imagePosition : TodayImageToggle) {
        buttonToday.isHidden = isHidden
        let imageButton: UIImage = switch imagePosition {
        case .up:
            UIImage(systemName: "chevron.up")?.withTintColor(ThemeManager.color(for: .secondaryText), renderingMode: .alwaysOriginal) ?? UIImage()
        case .down:
            UIImage(systemName: "chevron.down")?.withTintColor(ThemeManager.color(for: .secondaryText), renderingMode: .alwaysOriginal) ?? UIImage()
        }
        buttonToday.setImage(imageButton, for: .normal)
        
    }
}


// MARK: - OptionsFloatingBarViewDelegate
extension CalendarViewController: OptionsFloatingBarViewDelegate {
    
    func searchButtonTapped() {
        //TODO:
    }
    
    func calendarButtonTapped() {
      
    }
    
    func newEventButtonTapped() {
        let vc = SubscriptionViewController()
        let nc = UINavigationController(rootViewController: vc)
        self.present(nc, animated: true)
    }
    
    func settingsButtonTapped() {
        let vc = SettingsViewController()
        let nc = UINavigationController(rootViewController: vc)
        self.present(nc, animated: true)
    }
}


enum TodayImageToggle {
    case up
    case down
}
enum TypeEventView {
    case compact
    case detail
}
