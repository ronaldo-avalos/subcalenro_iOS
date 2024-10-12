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
        subscriptions = SubscriptionManager.shared.readAllSubscriptions()
        tableView.frame = view.bounds
        tableView.register(SubscriptionCell.self, forCellReuseIdentifier: "SubscriptionCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    


}


extension SubListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  83
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.cellForRow(at: indexPath)?.selectionStyle  = .none
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCell", for: indexPath) as? SubscriptionCell else {
            return UITableViewCell()
        }
        
        let subscription = subscriptions[indexPath.row]
        cell.configure(with: subscription)
        
        return cell
    }
    
    // MARK: - Menú contextual al mantener presionado
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let configuration = UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { _ in
            return self.makeContextMenu(for: indexPath)
        }
        return configuration
    }
    
    // Función para crear el menú contextual
    private func makeContextMenu(for indexPath: IndexPath) -> UIMenu {
        // Acción para editar
        let editAction = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { [weak self] _ in
            self?.editSubscription(at: indexPath)
        }
        
        // Acción para eliminar
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
            self?.deleteSubscription(at: indexPath)
        }
        
        // Crear el menú con las dos acciones
        return UIMenu(title: "", children: [editAction, deleteAction])
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
            let sub =  self.subscriptions[indexPath.row]
    }

    private func editSubscription(at indexPath: IndexPath) {
        let  sub = subscriptions[indexPath.row]
    }

}
