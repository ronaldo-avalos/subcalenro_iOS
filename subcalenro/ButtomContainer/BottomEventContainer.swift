//
//  bottomEventContainer.swift
//  subcalenro
//
//  Created by ronaldo avalos on 08/09/24.
//

import Foundation
import UIKit

class BottomContainer: UIView {

    let topBorder = UIView()
    let tableView = UITableView()
    var subscriptions: [Subscription] = []
    var deleteSub: ((UUID) -> Void)?
    var editSub: ((UUID) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        backgroundColor = ThemeManager.color(for: .primaryBackground)
        topBorder.backgroundColor = .systemGray4
        topBorder.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(SubscriptionCell.self, forCellReuseIdentifier: "SubscriptionCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
     
        addSubview(topBorder)
        addSubview(tableView)

        NSLayoutConstraint.activate([
            topBorder.topAnchor.constraint(equalTo: topAnchor),
            topBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBorder.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBorder.heightAnchor.constraint(equalToConstant: 0.3),
            
            tableView.topAnchor.constraint(equalTo: topBorder.bottomAnchor, constant: 6),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // Método para cargar las suscripciones
    func loadSubscriptions(_ subscriptions: [Subscription]) {
        self.subscriptions = subscriptions
        tableView.reloadData()
    }
}

extension BottomContainer: UITableViewDataSource, UITableViewDelegate {
    
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
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        
        // Acción para editar la suscripción
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completionHandler) in
            self?.editSubscription(at: indexPath)
            completionHandler(true)
        }
        editAction.image = UIImage(systemName: "pencil")
        editAction.backgroundColor = .systemBlue
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    
    // MARK: - Métodos para manejar la edición y eliminación
    private func deleteSubscription(at indexPath: IndexPath) {
         let  sub =  subscriptions[indexPath.row]
        deleteSub?(sub.id)
        subscriptions.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    private func editSubscription(at indexPath: IndexPath) {
        let  sub = subscriptions[indexPath.row]
        editSub?(sub.id)
    }

}



