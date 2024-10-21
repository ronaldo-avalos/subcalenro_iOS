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
        view.backgroundColor = ThemeManager.color(for: .primaryBackground)
        let closeIcon = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeModal))
        closeIcon.tintColor = .systemGray2
        self.navigationItem.rightBarButtonItem = closeIcon
        
       
        tableView.register(SubscriptionCell.self, forCellReuseIdentifier: "SubscriptionCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        reloadSubscriptions()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
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
    
    // MARK: - Acciones de deslizar (Swipe actions)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Acción para eliminar la suscripción
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            self?.deleteSubscription(at: indexPath)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        deleteAction.backgroundColor = ThemeManager.color(for: .primaryBackground)
        
        // Acción para editar la suscripción
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completionHandler) in
            self?.editSubscription(at: indexPath)
            completionHandler(true)
        }
        editAction.image = UIImage(systemName: "pencil")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        editAction.backgroundColor = ThemeManager.color(for: .primaryBackground)
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    
    // MARK: - Métodos para manejar la edición y eliminación
    private func deleteSubscription(at indexPath: IndexPath) {
        Utility.showDeleteConfirmationAlert(on: self, title: "Delete", message: "¿Are you sure you want to delete this subscription?") {
            let sub =  self.subscriptions[indexPath.row]
            SubscriptionManager().deleteById(sub.id)
            self.subscriptions = SubscriptionManager().readAllSubscriptions()
        }
    }

    private func editSubscription(at indexPath: IndexPath) {
        let  sub = subscriptions[indexPath.row]
        let vc = EditSubcriptionViewController()
        let nc = UINavigationController(rootViewController: vc)
        vc.subId = sub.id
        self.present(nc, animated: true)
    }
    
    
}
