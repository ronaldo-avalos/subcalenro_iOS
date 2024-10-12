//
//  ViewController.swift
//  subcalenro
//
//  Created by ronaldo avalos on 02/10/24.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {
    private var calendarView : FSCalendar!
    private var calendarDataSource: CalendarDataSource?
    private var calendarDelegate: CalendarDelegate?
    private var lastTapDate: Date?
    private var dateTapped: Date?
    private var floatingBar: OptionsFloatingBarView!
    var calendarHeight: CGFloat = 0
    var lastCalendarHeight: CGFloat = 500
    var bottomContainer : BottomContainer!
    private var subscriptions: [(Date, Subscription)] = []
    
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
        setupViews()
        reloadCalendar()
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
            self.bottomContainer.frame = CGRect(x: 0, y: calendar.frame.maxY, width: self.view.frame.width, height: 600)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(applyTheme), name: .themeChanged, object: nil)
        applyTheme()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSaveNewSaub(_:)), name: Notification.Name("SaveNewSubObserver"), object: nil)
    }

    @objc func handleSaveNewSaub(_ notification: Notification) {
        self.reloadCalendar()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    // MARK: - Apply Theme
    @objc func applyTheme() {
        view.backgroundColor = ThemeManager.color(for: .primaryBackground)
    }
    
    
    // MARK: - Calendar Selection Handling
    private func handleDateSelection(date: Date, cell: CalendarViewCell) {
        bottomContainer.setDateLabel(date)
        let subs = subscriptions.filter{ Calendar.current.isDate($0.0, inSameDayAs: date) }
        if subs.count > 0 {
            let selectedSubs = SubscriptionManager.shared.readByIds(subs.map({return $0.1.id}))
            bottomContainer.loadSubscriptions(selectedSubs)
        } else {
            bottomContainer.loadSubscriptions([])
        }
        setupCell(cell: cell, date: date)
    }
    
    private func setupCell(cell: CalendarViewCell, date: Date) {
        DispatchQueue.main.async {
            cell.configure(with: date,subs: self.subscriptions)
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
                //                showTodayButton(false, .up)
            } else if currentPageDate == todayDate {
                //               showTodayButton(true, .up)
            } else {
                //                showTodayButton(false, .down)
            }
        }
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        let calendarHeight : CGFloat = Utility.isIphoneWithSmallScreen() ? 450 : Utility.isIpad ? 700 : 500
        calendarView = CustomFSCalendar(frame: CGRect(x: 0, y:44, width: view.frame.width, height: calendarHeight))
        calendarDelegate = CalendarDelegate()
        calendarDataSource = CalendarDataSource(calendar: calendarView ?? FSCalendar())
        calendarView?.dataSource = calendarDataSource
        calendarView?.delegate = calendarDelegate
        
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
        
        
        floatingBar = OptionsFloatingBarView()
        floatingBar.delegate = self
        floatingBar.translatesAutoresizingMaskIntoConstraints = false
        let floatingBarWidth: CGFloat = Utility.isIpad ? 320 : 220
        let floatingBarHeight: CGFloat = Utility.isIpad ? 65 : 55
        
        bottomContainer = BottomContainer(frame: CGRect(x: 0, y: calendarView.frame.maxY, width: view.frame.width, height: 600))
        bottomContainer.tableView.separatorStyle = .none
        bottomContainer.tableView.backgroundColor = .clear
        
        
        let views = [calendarView!,toggleEvents,profileImage,bottomContainer!]
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
            
            
            floatingBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            floatingBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            floatingBar.widthAnchor.constraint(equalToConstant: floatingBarWidth),
            floatingBar.heightAnchor.constraint(equalToConstant: floatingBarHeight),
            
        ])
        
        bottomContainer.deleteSub = { id in
            Utility.showDeleteConfirmationAlert(on: self, title: "Delete", message: "¿Are you sure you want to delete this subscription?") {
                SubscriptionManager.shared.deleteById(id)
                if let sub = self.subscriptions.first(where: { $0.1.id == id })?.1 {
                    NotificationManager.shared.cancelNotifications(for: sub)
                } else {
                    print("No se encontró la suscripción con el ID: \(id)")
                }
                self.reloadCalendar()
            }
        }

        bottomContainer.editSub = { id in
            let vc = SubscriptionViewController()
            let nc = UINavigationController(rootViewController: vc)
            vc.subId = id
            self.present(nc, animated: true)
        }
    }
    
    
    private func reloadCalendar() {
        // Cargar las suscripciones
        subscriptions = SubscriptionsLoader.shared.loadSubscriptionsDate()
        calendarDataSource?.set(subs: subscriptions)
        let subs = subscriptions.filter{ Calendar.current.isDate($0.0, inSameDayAs: Date.dateSelected) }
        let selectedSubs = SubscriptionManager.shared.readByIds(subs.map({return $0.1.id}))
        bottomContainer.loadSubscriptions(selectedSubs)
        print("Reload Calendar")
    }

}




// MARK: - OptionsFloatingBarViewDelegate
extension CalendarViewController: OptionsFloatingBarViewDelegate {
    
    func analyticsButtonTapped() {
        //TODO:
    }
    
    func  subListButtonTapped() {
        
    }
    
    func newEventButtonTapped() {
//        self.subscriptionVC.subId = nil
        let vc = SubscriptionsViewController()
        let nc = UINavigationController(rootViewController: vc)
        self.present(nc, animated: true)
    }
    
    func settingsButtonTapped() {
        let vc = SettingsViewController()
        let nc = UINavigationController(rootViewController: vc)
        self.present(nc, animated: true)
    }
}
