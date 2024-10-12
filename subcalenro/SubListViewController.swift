//
//  SubListViewController.swift
//  subcalenro
//
//  Created by ronaldo avalos on 11/10/24.
//
import UIKit

class SubListViewController: UIViewController {

    var tableView = UITableView()
    var subscriptions: [(Date, Subscription)] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var groupedSubscriptions: [Date: [Subscription]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        self.title = "Subscriptions"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        let closeIcon = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeModal))
        closeIcon.tintColor = .systemGray2
        self.navigationItem.rightBarButtonItem = closeIcon
        
        tableView.frame = view.bounds
        tableView.register(SubscriptionCell.self, forCellReuseIdentifier: "SubscriptionCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        reloadSubscriptions()
    }

    func reloadSubscriptions() {
        let today = Calendar.current.startOfDay(for: Date())
        subscriptions = SubscriptionsLoader.shared.loadSubscriptionsDate()
            .filter { Calendar.current.startOfDay(for: $0.0) >= today }
        
        groupedSubscriptions = Dictionary(grouping: subscriptions, by: { Calendar.current.startOfDay(for: $0.0) })
            .mapValues { $0.map { $0.1 } }
        
        tableView.reloadData()
    }
    @objc func closeModal() {
        self.dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SubListViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedSubscriptions.keys.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sortedDates = groupedSubscriptions.keys.sorted()
        let date = sortedDates[section]
        return groupedSubscriptions[date]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sortedDates = groupedSubscriptions.keys.sorted()
        let date = sortedDates[section]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE — MMM d yyyy"
        return dateFormatter.string(from: date).uppercased()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCell", for: indexPath) as? SubscriptionCell else {
            return UITableViewCell()
        }
        
        let sortedDates = groupedSubscriptions.keys.sorted()
        let date = sortedDates[indexPath.section]
        if let subscription = groupedSubscriptions[date]?[indexPath.row] {
            cell.configure(with: subscription)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        editSubscription(at: indexPath)
    }
    
    
    private func editSubscription(at indexPath: IndexPath) {
        // Obtener la fecha de la sección seleccionada
        let sortedDates = groupedSubscriptions.keys.sorted()
        let date = sortedDates[indexPath.section]
        
        // Obtener la suscripción correcta de la fila seleccionada
        if let sub = groupedSubscriptions[date]?[indexPath.row] {
            print(sub)
            
            // Navegar a la pantalla de edición con los detalles de la suscripción seleccionada
            let vc = DetailSubcriptionViewController()
            vc.subId = sub.id
            self.show(vc, sender: nil)
        }
    }

}
