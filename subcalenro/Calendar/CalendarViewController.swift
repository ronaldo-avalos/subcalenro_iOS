//
//  ViewController.swift
//  subcalenro
//
//  Created by ronaldo avalos on 02/10/24.
//

import UIKit
import FSCalendar
import ToastViewSwift

class CalendarViewController: UIViewController {
    private var calendarView : FSCalendar!
    private var calendarDataSource: CalendarDataSource?
    private var calendarDelegate: CalendarDelegate?
    private var lastTapDate: Date?
    private var dateTapped: Date?
    private var floatingBar: OptionsFloatingBarView!
    private let scrollView = UIScrollView()
    private var calendarHeight: CGFloat = 0
    private var lastCalendarHeight: CGFloat = 500
    private var bottomContainer : BottomContainer!
    private var subscriptions: [(Date, Subscription)] = []
    private var selectedSubs: [Subscription] = []  {
        didSet {
            scrollView.isScrollEnabled = selectedSubs.count > 1
            UIView.animate(withDuration: 0.4) {
                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            }
            
        }
    }
    
    private var calendarViewHeightConstraint: NSLayoutConstraint!
    private var bottomContainerHeightConstraint: NSLayoutConstraint!

    let detailEvenstIcon = UIImage(systemName: "rectangle.grid.1x2")
    let compactEventsIcon = UIImage(systemName: "ellipsis.rectangle")
    
    let toggleEvents: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = FontManager.sfProRounded(size: 14, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        reloadCalendar(completion: {})
        
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
        
        calendarDelegate?.boundingRectWillChange = { (bounds : CGRect, calendar : FSCalendar) in
            self.calendarViewHeightConstraint.constant = bounds.height
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(applyTheme), name: .themeChanged, object: nil)
        applyTheme()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSaveNewSaub(_:)), name: Notification.Name("SaveNewSubObserver"), object: nil)
        
        
    }
    
    @objc func handleSaveNewSaub(_ notification: Notification) {
        self.reloadCalendar(completion: { })
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Utility.executeFunctionWithDelay(delay: 3) {
            if NotificationManager.shared.getPermissionStatus() == PermissionType.undefined {
                let vc = NotificationPermissionViewController()
                self.present(vc, animated: true)
            }
        }
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
            selectedSubs = SubscriptionManager().readByIds(subs.map({return $0.1.id}))
            bottomContainer.loadSubscriptions(selectedSubs)
        } else {
            selectedSubs = []
            bottomContainer.loadSubscriptions([])
        }
        
        self.bottomContainerHeightConstraint.constant = CGFloat((selectedSubs.count * 83) + 138)
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
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
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
              self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
          }, completion: nil)
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
        scrollView.isScrollEnabled = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        
        floatingBar = OptionsFloatingBarView()
        floatingBar.delegate = self
        floatingBar.translatesAutoresizingMaskIntoConstraints = false
        let floatingBarWidth: CGFloat = Utility.isIpad ? 220 : 55 * 3
        let floatingBarHeight: CGFloat = Utility.isIpad ? 65 : 55
        
        // Configurar el calendarView
        
        calendarView = CustomFSCalendar()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarDelegate = CalendarDelegate()
        calendarDataSource = CalendarDataSource(calendar: calendarView)
        calendarView?.dataSource = calendarDataSource
        calendarView?.delegate = calendarDelegate
        let calendarHeight: CGFloat = Utility.isIphoneWithSmallScreen() ? 450 : Utility.isIpad ? 700 : 500
        calendarViewHeightConstraint = calendarView?.heightAnchor.constraint(equalToConstant: calendarHeight)
     
        bottomContainer = BottomContainer()
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.tableView.separatorStyle = .none
        bottomContainer.tableView.backgroundColor = .clear
        bottomContainerHeightConstraint = bottomContainer.heightAnchor.constraint(equalToConstant:300 )
        
        let todayButton = UIImageView()
        todayButton.image = UIImage(systemName: "chevron.up")
        todayButton.tintColor = ThemeManager.color(for: .secondaryBackground)
        todayButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(todayButton)
        
//        let todayLabel = UILabel()
//        todayLabel.text = "Today"
//        todayLabel.textColor = ThemeManager.color(for: .secondaryText)
//        todayLabel.font = FontManager.sfProDisplay(size: 12, weight: .bold)
//        todayLabel.translatesAutoresizingMaskIntoConstraints = false
//        todayButton.addSubview(todayLabel)
        
        
        
        contentView.addSubview(calendarView)
        contentView.addSubview(bottomContainer)
        
        view.addSubview(toggleEvents)
        view.addSubview(floatingBar)
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            calendarView.topAnchor.constraint(equalTo: contentView.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: calendarHeight),
            calendarViewHeightConstraint!,

            bottomContainer.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 16),
            bottomContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomContainerHeightConstraint!,
            
            toggleEvents.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 6),
            toggleEvents.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            floatingBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            floatingBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            floatingBar.widthAnchor.constraint(equalToConstant: floatingBarWidth),
            floatingBar.heightAnchor.constraint(equalToConstant: floatingBarHeight),
//            
//            todayLabel.centerXAnchor.constraint(equalTo: todayButton.centerXAnchor),
//            todayLabel.centerYAnchor.constraint(equalTo: todayButton.centerYAnchor),
            
            todayButton.leadingAnchor.constraint(equalTo: floatingBar.trailingAnchor, constant: 16),
            todayButton.centerYAnchor.constraint(equalTo: floatingBar.centerYAnchor)
        ])
        
        bottomContainer.deleteSub = { id in
            Utility.showDeleteConfirmationAlert(on: self, title: "Delete", message: "¿Are you sure you want to delete this subscription?") {
                SubscriptionManager().deleteById(id)
                if let sub = self.subscriptions.first(where: { $0.1.id == id })?.1 {
                    NotificationManager.shared.cancelNotifications(for: sub)
                } else {
                    print("No se encontró la suscripción con el ID: \(id)")
                }
                self.reloadCalendar(completion: {})
            }
        }
        
        bottomContainer.editSub = { id in
//            let vc = EditSubcriptionViewController()
//            let nc = UINavigationController(rootViewController: vc)
//            vc.subId = id
//            self.present(nc, animated: true)
        }
        
        bottomContainer.didSelecSub = { id in
            let vc = DetailSubcriptionViewController()
            let nv = UINavigationController(rootViewController: vc)
            vc.subId = id
            self.present(nv, animated: true)
        }
    }
    
    
        var dateSelected: Date = Date() // Fecha seleccionada, inicializada como la fecha actual

        private func reloadCalendar(completion: @escaping () -> Void) {
            // Cargar las suscripciones
            subscriptions = SubscriptionsLoader.shared.loadSubscriptionsDate()
            calendarDataSource?.set(subs: subscriptions)
            
            // Filtrar suscripciones según la fecha seleccionada
            let subs = subscriptions.filter { Calendar.current.isDate($0.0, inSameDayAs: dateSelected) }
            let selectedSubs = SubscriptionManager().readByIds(subs.map { $0.1.id })
            bottomContainer.loadSubscriptions(selectedSubs)
            print("Reload Calendar")
            completion()
        }

}




// MARK: - OptionsFloatingBarViewDelegate
extension CalendarViewController: OptionsFloatingBarViewDelegate {
    
    func analyticsButtonTapped() {
        let vc = AnalyticsViewController()
        let nc = UINavigationController(rootViewController: vc)
        self.present(nc, animated: true)
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
