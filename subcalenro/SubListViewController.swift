//
//  SubListViewController.swift
//  subcalenro
//
//  Created by ronaldo avalos on 11/10/24.
//
import UIKit

class SubListViewController: UIViewController {

    var tableView = UITableView()
    var subscriptions: [Subscription] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        self.title = "Subscriptions"
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
        subscriptions = SubscriptionManager().readAllSubscriptions()
        tableView.reloadData()
    }
    
    @objc func closeModal() {
        self.dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SubListViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Una sola sección para todas las suscripciones
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptions.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Total: \(subscriptions.count)"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCell", for: indexPath) as? SubscriptionCell else {
            return UITableViewCell()
        }
        
        let subscription = subscriptions[indexPath.row]
        cell.configure(with: subscription)
        
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
        let sub = subscriptions[indexPath.row]
        print(sub)
        
        let vc = DetailSubcriptionViewController()
        vc.subId = sub.id
        self.show(vc, sender: nil)
    }
}
