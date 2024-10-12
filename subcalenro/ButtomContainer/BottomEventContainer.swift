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
    var dateLabel = UILabel()
    var thereNotSubLabel = UILabel()
    
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
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont(name: "SFProRounded-Semibold", size: 16)
        setDateLabel(Date())
        
        thereNotSubLabel.translatesAutoresizingMaskIntoConstraints = false
        thereNotSubLabel.text = "No renewal on this day"
        thereNotSubLabel.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        thereNotSubLabel.textColor = .tertiaryLabel
        
        tableView.register(SubscriptionCell.self, forCellReuseIdentifier: "SubscriptionCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
     
        addSubview(topBorder)
        addSubview(tableView)
        addSubview(dateLabel)
        addSubview(thereNotSubLabel)

        NSLayoutConstraint.activate([
            topBorder.topAnchor.constraint(equalTo: topAnchor),
            topBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBorder.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBorder.heightAnchor.constraint(equalToConstant: 0.3),
            
            dateLabel.topAnchor.constraint(equalTo: topBorder.bottomAnchor,constant: 14),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            
            tableView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            thereNotSubLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            thereNotSubLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
        
        ])
    }

    // Método para cargar las suscripciones
    func loadSubscriptions(_ subscriptions: [Subscription]) {
        self.subscriptions = subscriptions
        thereNotSubLabel.isHidden = !subscriptions.isEmpty
        tableView.isScrollEnabled = subscriptions.count != 1
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
    
    func setDateLabel(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM, yyyy"
        dateFormatter.locale = Locale.current
        let formattedDate = dateFormatter.string(from: date)
        dateLabel.text = formattedDate
        Date.dateSelected = date
        layoutIfNeeded()
    }

    
    // MARK: - Métodos para manejar la edición y eliminación
    private func deleteSubscription(at indexPath: IndexPath) {
            let sub =  self.subscriptions[indexPath.row]
            self.deleteSub?(sub.id)
    }

    private func editSubscription(at indexPath: IndexPath) {
        let  sub = subscriptions[indexPath.row]
        editSub?(sub.id)
    }

}



